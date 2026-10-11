import os

def write_file(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content.strip() + '\n')

def main():
    # 1. Projects Screen
    write_file('lib/screens/projects_screen.dart', """
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/profile_controller.dart';
import '../models/project.dart';
import '../utils/responsive_utils.dart';
import '../widgets/animated_button.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = ['All', 'Mobile', 'Web', 'Backend', 'AI/ML'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileController>(context);
    final theme = Theme.of(context);

    if (provider.isLoading) return const Center(child: CircularProgressIndicator());

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context)),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            border: Border(bottom: BorderSide(color: theme.dividerColor)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Portfolio Projects', style: theme.textTheme.displayMedium),
              const SizedBox(height: 8),
              Text(
                'Explore my latest works, open-source contributions, and side projects.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: theme.primaryColor,
                labelColor: theme.primaryColor,
                unselectedLabelColor: theme.textTheme.bodyMedium?.color,
                tabs: _categories.map((c) => Tab(text: c)).toList(),
                onTap: (index) {
                  setState(() {});
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: _categories.map((category) {
              final projects = category == 'All'
                  ? provider.projects
                  : provider.projects.where((p) => p.category == category).toList();
              
              if (projects.isEmpty) {
                return Center(
                  child: Text('No projects found in this category.', style: theme.textTheme.bodyLarge),
                );
              }

              return GridView.builder(
                padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context)),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveUtils.isMobile(context) ? 1 : (ResponsiveUtils.isTablet(context) ? 2 : 3),
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 0.8,
                ),
                itemCount: projects.length,
                itemBuilder: (context, index) => _buildProjectCard(context, projects[index]),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectCard(BuildContext context, Project project) {
    final theme = Theme.of(context);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (project.imageUrl.isNotEmpty)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  project.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: theme.disabledColor.withValues(alpha: 0.2),
                    child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
                  ),
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            project.title,
                            style: theme.textTheme.titleLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            project.category,
                            style: TextStyle(fontSize: 12, color: theme.primaryColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        project.description,
                        style: theme.textTheme.bodyMedium,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: project.technologies.take(3).map((tech) {
                        return Text(
                          '#$tech',
                          style: TextStyle(fontSize: 12, color: theme.colorScheme.secondary),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (project.githubUrl != null)
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _launchUrl(project.githubUrl),
                              icon: const Icon(Icons.code, size: 18),
                              label: const Text('Source'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        if (project.githubUrl != null && project.liveUrl != null)
                          const SizedBox(width: 8),
                        if (project.liveUrl != null)
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _launchUrl(project.liveUrl),
                              icon: const Icon(Icons.launch, size: 18),
                              label: const Text('Live'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
""")

    # 2. Skills Screen
    write_file('lib/screens/skills_screen.dart', """
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/profile_controller.dart';
import '../models/skill.dart';
import '../utils/responsive_utils.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileController>(context);
    final theme = Theme.of(context);

    if (provider.isLoading) return const Center(child: CircularProgressIndicator());

    // Group skills by category
    final Map<String, List<Skill>> groupedSkills = {};
    for (var skill in provider.skills) {
      groupedSkills.putIfAbsent(skill.category, () => []).add(skill);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Technical Expertise', style: theme.textTheme.displayMedium),
          const SizedBox(height: 8),
          Text(
            'A comprehensive breakdown of my skills, proficiencies, and tools.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          ...groupedSkills.entries.map((entry) => _buildSkillCategory(context, entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildSkillCategory(BuildContext context, String category, List<Skill> skills) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.category, color: theme.primaryColor),
              const SizedBox(width: 12),
              Text(category, style: theme.textTheme.headlineSmall),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = ResponsiveUtils.isMobile(context) ? 1 : 2;
              final width = (constraints.maxWidth - ((crossAxisCount - 1) * 24)) / crossAxisCount;
              
              return Wrap(
                spacing: 24,
                runSpacing: 24,
                children: skills.map((skill) {
                  return SizedBox(
                    width: width,
                    child: _buildSkillItem(context, skill),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSkillItem(BuildContext context, Skill skill) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 0,
      color: theme.cardTheme.color?.withValues(alpha: 0.5),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (skill.iconUrl != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Image.network(skill.iconUrl!, width: 24, height: 24, errorBuilder: (_,__,___) => const Icon(Icons.code, size: 24)),
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Icon(Icons.code, size: 24),
                      ),
                    Text(skill.name, style: theme.textTheme.titleMedium),
                  ],
                ),
                Text('${(skill.proficiency * 100).toInt()}%', style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: skill.proficiency,
                minHeight: 8,
                backgroundColor: theme.dividerColor,
                valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
""")

    # 3. Contact Screen
    write_file('lib/screens/contact_screen.dart', """
import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';
import '../widgets/animated_button.dart';

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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        setState(() => _isSubmitting = false);
        _nameController.clear();
        _emailController.clear();
        _subjectController.clear();
        _messageController.clear();
        
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Message Sent!'),
              ],
            ),
            content: const Text('Thank you for reaching out. I will get back to you as soon as possible.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = ResponsiveUtils.isDesktop(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Get In Touch', style: theme.textTheme.displayMedium),
          const SizedBox(height: 8),
          Text(
            'Have a project in mind, a question, or just want to say hi? Feel free to drop a message.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 48),
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 1, child: _buildContactInfo(theme)),
                const SizedBox(width: 64),
                Expanded(flex: 2, child: _buildContactForm(theme)),
              ],
            )
          else
            Column(
              children: [
                _buildContactInfo(theme),
                const SizedBox(height: 48),
                _buildContactForm(theme),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Contact Information', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 24),
        _buildInfoTile(theme, Icons.email, 'Email', 'hello@example.com'),
        const SizedBox(height: 24),
        _buildInfoTile(theme, Icons.phone, 'Phone', '+1 (555) 123-4567'),
        const SizedBox(height: 24),
        _buildInfoTile(theme, Icons.location_on, 'Location', 'San Francisco, CA'),
        const SizedBox(height: 48),
        Text('Social Profiles', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 24),
        Row(
          children: [
            _buildSocialButton(theme, Icons.link, 'LinkedIn'),
            const SizedBox(width: 16),
            _buildSocialButton(theme, Icons.code, 'GitHub'),
            const SizedBox(width: 16),
            _buildSocialButton(theme, Icons.alternate_email, 'Twitter'),
          ],
        )
      ],
    );
  }

  Widget _buildInfoTile(ThemeData theme, IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: theme.primaryColor),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.bodyMedium?.copyWith(color: theme.disabledColor)),
            const SizedBox(height: 4),
            Text(value, style: theme.textTheme.titleMedium),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(ThemeData theme, IconData icon, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () {},
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

  Widget _buildContactForm(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Send a Message', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Your Name', prefixIcon: Icon(Icons.person_outline)),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Your Email', prefixIcon: Icon(Icons.email_outlined)),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter your email';
                        if (!value.contains('@')) return 'Please enter a valid email';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(labelText: 'Subject', prefixIcon: Icon(Icons.subject)),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a subject' : null,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(labelText: 'Message', alignLabelWithHint: true),
                maxLines: 6,
                validator: (value) => value == null || value.isEmpty ? 'Please enter your message' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: AnimatedBounceButton(
                  enableGlow: true,
                  onPressed: _isSubmitting ? () {} : _submitForm,
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
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
""")

if __name__ == '__main__':
    main()
    print("Upgrade Part 4 complete.")
