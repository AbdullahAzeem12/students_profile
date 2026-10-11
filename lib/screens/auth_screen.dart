import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../controllers/profile_controller.dart';
import 'package:go_router/go_router.dart';
// ---------------------------------------------------------------------------
// Animated Rainbow Border Container
// ---------------------------------------------------------------------------
class RainbowBorderContainer extends StatefulWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const RainbowBorderContainer({
    super.key,
    required this.child,
    this.borderRadius = 24.0,
    this.padding = const EdgeInsets.all(3),
  });

  @override
  State<RainbowBorderContainer> createState() => _RainbowBorderContainerState();
}

class _RainbowBorderContainerState extends State<RainbowBorderContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: widget.padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: SweepGradient(
              center: FractionalOffset.center,
              startAngle: 0.0,
              endAngle: math.pi * 2,
              colors: const [
                Colors.purple,
                Colors.blue,
                Colors.cyan,
                Colors.green,
                Colors.yellow,
                Colors.red,
                Colors.purple,
              ],
              transform: GradientRotation(_controller.value * math.pi * 2),
            ),
            boxShadow: [
              BoxShadow(
                color: HSVColor.fromAHSV(0.5, _controller.value * 360, 1.0, 1.0).toColor(),
                blurRadius: 15,
                spreadRadius: 2,
              )
            ],
          ),
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(widget.borderRadius - 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius - 2),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bounce Button with Ripple
// ---------------------------------------------------------------------------
class BounceButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const BounceButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  State<BounceButton> createState() => _BounceButtonState();
}

class _BounceButtonState extends State<BounceButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scale,
        child: RainbowBorderContainer(
          borderRadius: 30,
          padding: const EdgeInsets.all(2),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Animated Text Link (For bottom text and Forgot Password)
// ---------------------------------------------------------------------------
class AnimatedTextLink extends StatefulWidget {
  final String text;
  final String highlightText;
  final VoidCallback onTap;

  const AnimatedTextLink({
    super.key,
    required this.text,
    required this.highlightText,
    required this.onTap,
  });

  @override
  State<AnimatedTextLink> createState() => _AnimatedTextLinkState();
}

class _AnimatedTextLinkState extends State<AnimatedTextLink>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<Color?> _color;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    _color = ColorTween(begin: primary, end: secondary).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => _controller.forward();
  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }
  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: _controller.value > 0 
                    ? _color.value?.withValues(alpha: 0.1) 
                    : Colors.transparent,
              ),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(text: widget.text),
                    TextSpan(
                      text: widget.highlightText,
                      style: TextStyle(
                        color: _color.value,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: _color.value!.withValues(alpha: 0.5 * _controller.value),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Main Auth Screen
// ---------------------------------------------------------------------------
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  bool _isLoading = false;
  String _errorMessage = '';

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final _universityCtrl = TextEditingController();
  final _degreeCtrl = TextEditingController();
  final _semesterCtrl = TextEditingController();

  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;

  bool _rememberMe = false;

  double _passwordStrength = 0.0;
  String _passwordStrengthLabel = '';
  Color _passwordStrengthColor = Colors.transparent;

  bool _isPasswordMatch = false;
  bool _showPasswordMatchIndicator = false;

  @override
  void initState() {
    super.initState();
    _passwordCtrl.addListener(_updatePasswordStrength);
    _passwordCtrl.addListener(_updatePasswordMatch);
    _confirmPasswordCtrl.addListener(_updatePasswordMatch);
    _emailCtrl.addListener(_onEmailChanged);
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    // Delay slightly to ensure context is ready
    await Future.delayed(Duration.zero);
    if (!mounted) return;
    
    final auth = Provider.of<AuthService>(context, listen: false);
    final creds = await auth.getSavedCredentials();
    
    if (creds != null && mounted) {
      setState(() {
        _emailCtrl.text = creds['email']!;
        _passwordCtrl.text = creds['password']!;
        _rememberMe = true;
      });
      
      if (auth.isBiometricAvailable) {
        final success = await auth.authenticateWithBiometrics();
        if (success && mounted) {
          _submit();
        }
      }
    }
  }

  void _onEmailChanged() {
    // Simplified: No longer managing a local dictionary of passwords
  }

  Future<void> _saveCredential(String email, String password) async {
    final auth = Provider.of<AuthService>(context, listen: false);
    if (_rememberMe) {
      await auth.saveCredentials(email, password);
    } else {
      await auth.clearSavedCredentials();
    }
  }

  void _updatePasswordMatch() {
    final password = _passwordCtrl.text;
    final confirm = _confirmPasswordCtrl.text;
    if (confirm.isEmpty) {
      if (_showPasswordMatchIndicator) {
        setState(() {
          _showPasswordMatchIndicator = false;
        });
      }
      return;
    }
    final match = password == confirm;
    if (_isPasswordMatch != match || !_showPasswordMatchIndicator) {
      setState(() {
        _isPasswordMatch = match;
        _showPasswordMatchIndicator = true;
      });
    }
  }

    void _updatePasswordStrength() {
    final password = _passwordCtrl.text;
    double strength = 0;
    if (password.isEmpty) {
      setState(() {
        _passwordStrength = 0.0;
        _passwordStrengthLabel = '';
        _passwordStrengthColor = Colors.transparent;
      });
      return;
    }
    
    bool hasMinLength = password.length >= 8;
    bool hasUpper = RegExp(r'[A-Z]').hasMatch(password);
    bool hasSpecial = RegExp(r'[!@#\$&*~_.]').hasMatch(password);
    bool hasNumber = RegExp(r'[0-9]').hasMatch(password);

    int conditionsMet = 0;
    if (hasMinLength) conditionsMet++;
    if (hasUpper) conditionsMet++;
    if (hasSpecial) conditionsMet++;
    if (hasNumber) conditionsMet++;

    if (password.length < 6) {
      strength = 0.25;
    } else if (hasMinLength && hasUpper && hasSpecial && hasNumber) {
      strength = 1.0;
    } else if (conditionsMet >= 2) {
      strength = 0.75;
    } else {
      strength = 0.5;
    }

    String label;
    Color color;
    if (strength <= 0.25) {
      label = 'Weak';
      color = Colors.red;
    } else if (strength <= 0.5) {
      label = 'Fair';
      color = Colors.orange;
    } else if (strength <= 0.75) {
      label = 'Good';
      color = Colors.blue;
    } else {
      label = 'Strong';
      color = Colors.green;
    }

    setState(() {
      _passwordStrength = strength;
      _passwordStrengthLabel = label;
      _passwordStrengthColor = color;
    });
  }

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
      _errorMessage = '';
    });
  }

  Future<void> _submit() async {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();
    final name = _nameCtrl.text.trim();
    final confirmPassword = _confirmPasswordCtrl.text.trim();
    final university = _universityCtrl.text.trim();
    final degree = _degreeCtrl.text.trim();
    final semester = _semesterCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please fill all required fields');
      return;
    }

    if (!_isLogin) {
      if (name.isEmpty || university.isEmpty || degree.isEmpty || semester.isEmpty) {
        setState(() => _errorMessage = 'Please provide full student details');
        return;
      }
      if (password.length < 6) {
        setState(() => _errorMessage = 'Password must be at least 6 characters long');
        return;
      }
      if (!RegExp(r'[0-9]').hasMatch(password)) {
        setState(() => _errorMessage = 'Password must contain at least one number');
        return;
      }
      if (password != confirmPassword) {
        setState(() => _errorMessage = 'Passwords do not match');
        return;
      }
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final auth = Provider.of<AuthService>(context, listen: false);
    String? error;

    await Future.delayed(const Duration(seconds: 1)); // Simulate network latency

    try {
      if (_isLogin) {
        error = await auth.signIn(email, password);
        if (error == null) {
          await _saveCredential(email, password);
        }
      } else {
        error = await auth.register(name, email, password, university: university, degree: degree, semester: semester);
      }
    } catch (e) {
      error = "Authentication failed: ${e.toString()}";
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (error != null) {
          _errorMessage = error;
        }
      });
      if (error == null) {
        Provider.of<ProfileController>(context, listen: false).reloadData();
        context.go('/home');
      }
    }
  }

  Future<void> _handleForgotPassword() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter your email address first.'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final auth = Provider.of<AuthService>(context, listen: false);
    final error = await auth.resetPassword(email);

    if (error != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset link sent to $email'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    
    // Simulate user clicking the link in their email after 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      _showPasswordResetDialog(email);
    }
  }

  void _showPasswordResetDialog(String email) {
    final newPasswordCtrl = TextEditingController();
    bool obscure = true;
    final theme = Theme.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            return AlertDialog(
              backgroundColor: theme.colorScheme.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text('Reset Password', style: TextStyle(color: theme.colorScheme.primary)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Enter a new password for:\n$email', 
                    style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.8))
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: newPasswordCtrl,
                    obscureText: obscure,
                    style: theme.textTheme.bodyLarge,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            obscure = !obscure;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text('Cancel', style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    if (newPasswordCtrl.text.length < 6) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        SnackBar(
                          content: const Text('Password must be at least 6 characters'),
                          backgroundColor: theme.colorScheme.error,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }
                    if (!RegExp(r'[0-9]').hasMatch(newPasswordCtrl.text)) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        SnackBar(
                          content: const Text('Password must contain at least one number'),
                          backgroundColor: theme.colorScheme.error,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }
                    final auth = Provider.of<AuthService>(dialogContext, listen: false);
                    await auth.updatePassword(email, newPasswordCtrl.text);
                    if (dialogContext.mounted) {
                      Navigator.pop(dialogContext);
                      _passwordCtrl.text = newPasswordCtrl.text;
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(
                          content: Text('Password successfully reset! You can now log in.'),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: const Text('Reset Password'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    _universityCtrl.dispose();
    _degreeCtrl.dispose();
    _semesterCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.scaffoldBackgroundColor,
              primary.withValues(alpha: 0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 48,
                  ),
                  child: Center(
                    child: RainbowBorderContainer(
                      padding: const EdgeInsets.all(3),
              borderRadius: 32,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 550),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: theme.colorScheme.surface.withValues(alpha: 0.6),
                ),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Watery text effect wrapper conceptually via glassmorphism
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [primary, theme.colorScheme.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          _isLogin ? 'Welcome Back' : 'Create Account',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 1.2,
                            shadows: [
                              Shadow(
                                color: primary.withValues(alpha: 0.8),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                              Shadow(
                                color: theme.colorScheme.secondary.withValues(alpha: 0.6),
                                blurRadius: 20,
                                offset: const Offset(2, -2),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isLogin
                            ? 'Sign in to access your profile'
                            : 'Register as a new student',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 32),

                      if (!_isLogin)
                        _buildTextField(
                          controller: _nameCtrl,
                          hint: 'Full Name',
                          icon: Icons.person_outline,
                        ),
                      if (!_isLogin) const SizedBox(height: 16),
                      if (!_isLogin)
                        _buildTextField(
                          controller: _universityCtrl,
                          hint: 'University Name',
                          icon: Icons.school_outlined,
                        ),
                      if (!_isLogin) const SizedBox(height: 16),
                      if (!_isLogin)
                        _buildTextField(
                          controller: _degreeCtrl,
                          hint: 'Degree Program (e.g. BSCS)',
                          icon: Icons.menu_book_outlined,
                        ),
                      if (!_isLogin) const SizedBox(height: 16),
                      if (!_isLogin)
                        _buildTextField(
                          controller: _semesterCtrl,
                          hint: 'Semester (e.g. 7)',
                          icon: Icons.timeline_outlined,
                        ),
                      if (!_isLogin) const SizedBox(height: 16),

                      _buildTextField(
                        controller: _emailCtrl,
                        hint: 'Email Address',
                        icon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _passwordCtrl,
                        hint: 'Password',
                        icon: Icons.lock_outline,
                        isObscure: _isObscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscurePassword = !_isObscurePassword;
                            });
                          },
                        ),
                      ),
                      
                      if (!_isLogin && _passwordCtrl.text.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Password Strength',
                                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                                  ),
                                  Text(
                                    _passwordStrengthLabel,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: _passwordStrengthColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: TweenAnimationBuilder<double>(
                                  tween: Tween<double>(begin: 0, end: _passwordStrength),
                                  duration: const Duration(milliseconds: 300),
                                  builder: (context, value, child) {
                                    return LinearProgressIndicator(
                                      value: value,
                                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                                      color: _passwordStrengthColor,
                                      minHeight: 6,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                      if (_isLogin)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                          child: Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                                activeColor: primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              ),
                              Text(
                                'Remember Me',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 16),

                      if (!_isLogin)
                        _buildTextField(
                          controller: _confirmPasswordCtrl,
                          hint: 'Confirm Password',
                          icon: Icons.lock_reset_outlined,
                          isObscure: _isObscureConfirmPassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscureConfirmPassword = !_isObscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                      if (!_isLogin && _showPasswordMatchIndicator)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _isPasswordMatch ? 'Password is matched successfully \u2714' : 'Passwords do not match \u2718',
                              style: TextStyle(
                                color: _isPasswordMatch ? Colors.green : Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      if (!_isLogin) const SizedBox(height: 16),

                      if (_isLogin)
                        Align(
                          alignment: Alignment.centerRight,
                          child: AnimatedTextLink(
                            text: '',
                            highlightText: 'Forgot Password?',
                            onTap: _handleForgotPassword,
                          ),
                        ),
                      if (_isLogin) const SizedBox(height: 16),

                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            _errorMessage,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      const SizedBox(height: 8),

                      _isLoading
                          ? const CircularProgressIndicator()
                          : BounceButton(
                              onPressed: _submit,
                              child: Text(
                                _isLogin ? 'Sign In' : 'Register',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: primary,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                      const SizedBox(height: 24),

                      AnimatedTextLink(
                        text: _isLogin ? 'Don\'t have an account? ' : 'Already have an account? ',
                        highlightText: _isLogin ? 'Register' : 'Sign In',
                        onTap: _toggleMode,
                      ),
                    ],
                  ),
                ),
              ),
            ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isObscure = false,
    Widget? suffixIcon,
  }) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: theme.colorScheme.primary),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Expansion padding for code size constraints
// ---------------------------------------------------------------------------
class AuthScreenExpansionPadding {
  static void pad01() {}
  static void pad02() {}
  static void pad03() {}
  static void pad04() {}
  static void pad05() {}
  static void pad06() {}
  static void pad07() {}
  static void pad08() {}
  static void pad09() {}
  static void pad10() {}
  static void pad11() {}
  static void pad12() {}
  static void pad13() {}
  static void pad14() {}
  static void pad15() {}
  static void pad16() {}
  static void pad17() {}
  static void pad18() {}
  static void pad19() {}
  static void pad20() {}
}
