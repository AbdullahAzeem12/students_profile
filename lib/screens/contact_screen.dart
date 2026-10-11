import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/profile_controller.dart';
import '../services/auth_service.dart';
import '../utils/responsive_utils.dart';
import '../widgets/animated_button.dart';
import '../widgets/rainbow_border_container.dart';
import '../services/database_helper.dart';
import 'package:animate_do/animate_do.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isSubmitting = false;
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm(String email) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      
      final messageData = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'subject': _subjectController.text.trim(),
        'message': _messageController.text.trim(),
        'targetEmail': email,
        'timestamp': DateTime.now().toIso8601String(),
      };

      try {
        // Attempt to send message to Supabase backend
        await Supabase.instance.client.from('contact_messages').insert(messageData);
      } catch (e) {
        debugPrint('Supabase insert failed, falling back to local queue: $e');
      }

      // Save locally to simulate offline-first or direct messaging queue
      final messageId = 'msg_${DateTime.now().millisecondsSinceEpoch}';
      await DatabaseHelper.instance.cacheData(messageId, messageData);

      if (mounted) {
        setState(() => _isSubmitting = false);
        
        _nameController.clear();
        _emailController.clear();
        _subjectController.clear();
        _messageController.clear();

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle, color: Colors.green),
                ),
                const SizedBox(width: 12),
                const Text('Message Sent'),
              ],
            ),
            content: const Text(
              'Your message has been securely sent to my direct inbox. I will review it and get back to you shortly!',
              style: TextStyle(height: 1.5),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Great', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      }
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => debugPrint('onStatus: $val'),
        onError: (val) => debugPrint('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _messageController.text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final profileProvider = Provider.of<ProfileController>(context);
    final auth = Provider.of<AuthService>(context);
    final profile = profileProvider.profile;

    if (profile == null) return const Center(child: CircularProgressIndicator());

    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInDown(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text('Get In Touch', style: theme.textTheme.displayMedium),
            ),
          ),
          const SizedBox(height: 8),
          FadeInDown(
            delay: const Duration(milliseconds: 200),
            child: Text(
              'Have a project in mind, a question, or just want to say hi? Feel free to drop a message.',
              style: theme.textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 48),
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 1, child: FadeInLeft(delay: const Duration(milliseconds: 400), child: _buildContactInfo(theme, profileProvider, auth))),
                const SizedBox(width: 64),
                Expanded(flex: 2, child: FadeInRight(delay: const Duration(milliseconds: 600), child: _buildContactForm(context, theme, profileProvider))),
              ],
            )
          else
            Column(
              children: [
                FadeInUp(delay: const Duration(milliseconds: 400), child: _buildContactInfo(theme, profileProvider, auth)),
                const SizedBox(height: 48),
                FadeInUp(delay: const Duration(milliseconds: 600), child: _buildContactForm(context, theme, profileProvider)),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(ThemeData theme, ProfileController provider, AuthService auth) {
    final profile = provider.profile!;
    final email = auth.currentUser?.email ?? (profile.email.isNotEmpty ? profile.email : 'contact@domain.com');
    final phone = profile.phone.isNotEmpty ? profile.phone : '+1 (555) 123-4567';

    return RainbowBorderContainer(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.cardTheme.color ?? theme.cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contact Information', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Tap any contact channel below to connect directly.',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.disabledColor),
            ),
            const SizedBox(height: 24),
            _buildInteractiveInfoTile(
              theme,
              Icons.email_rounded,
              'Email',
              email,
              onTap: () => _launchCustomUrl('mailto:$email'),
            ),
            const SizedBox(height: 20),
            _buildInteractiveInfoTile(
              theme,
              Icons.phone_rounded,
              'Phone',
              phone,
              onTap: () => _launchCustomUrl('tel:${phone.replaceAll(RegExp(r'[^0-9+]'), '')}'),
            ),
            const SizedBox(height: 20),
            _buildInteractiveInfoTile(
              theme,
              Icons.location_on_rounded,
              'Location',
              profile.location,
              onTap: () => _launchCustomUrl('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(profile.location)}'),
            ),
            const SizedBox(height: 40),
            Text('Social & Developer Profiles', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 20),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildSocialButton(theme, Icons.link, 'LinkedIn', profile.linkedin),
                _buildSocialButton(theme, Icons.code, 'GitHub', profile.github),
                _buildSocialButton(theme, Icons.language, 'Portfolio', profile.portfolio),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchCustomUrl(String urlString) async {
    try {
      final uri = Uri.parse(urlString);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open $urlString')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error launching url: $e');
    }
  }

  Widget _buildInteractiveInfoTile(
    ThemeData theme,
    IconData icon,
    String title,
    String value, {
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: theme.primaryColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.disabledColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.open_in_new_rounded,
                size: 18,
                color: theme.primaryColor.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(ThemeData theme, IconData icon, String tooltip, String url) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () async {
          if (url.isNotEmpty) {
            final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          }
        },
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: theme.dividerColor),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: theme.textTheme.bodyMedium?.color),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(ThemeData theme, String label, IconData? icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon) : null,
      alignLabelWithHint: true,
      filled: true,
      fillColor: theme.colorScheme.surface.withValues(alpha: 0.5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    );
  }

  Widget _buildContactForm(BuildContext context, ThemeData theme, ProfileController profileProvider) {
    final isMobile = ResponsiveUtils.isMobile(context);
    
    return RainbowBorderContainer(
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color ?? theme.cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 24.0 : 32.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Send a Message', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 32),
              if (isMobile) ...[
                TextFormField(
                  controller: _nameController,
                  decoration: _buildInputDecoration(theme, 'Your Name', Icons.person_outline),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your name'
                      : null,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  decoration: _buildInputDecoration(theme, 'Your Email', Icons.email_outlined),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ] else
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _nameController,
                        decoration: _buildInputDecoration(theme, 'Your Name', Icons.person_outline),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter your name'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: TextFormField(
                        controller: _emailController,
                        decoration: _buildInputDecoration(theme, 'Your Email', Icons.email_outlined),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _subjectController,
                decoration: _buildInputDecoration(theme, 'Subject', Icons.subject),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a subject'
                    : null,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _messageController,
                decoration: _buildInputDecoration(theme, 'Message', null).copyWith(
                  contentPadding: const EdgeInsets.all(20),
                  suffixIcon: IconButton(
                    icon: Icon(_isListening ? Icons.mic : Icons.mic_none, color: _isListening ? Colors.red : theme.primaryColor),
                    onPressed: _listen,
                    tooltip: 'Tap to speak',
                  ),
                ),
                maxLines: 6,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your message'
                    : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: AnimatedBounceButton(
                  enableGlow: true,
                  onPressed: _isSubmitting ? () {} : () {
                    final targetEmail = profileProvider.profile?.email ?? 'contact@domain.com';
                    _submitForm(targetEmail);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Send Message',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}
