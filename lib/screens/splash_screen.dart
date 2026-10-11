// Splash Screen
//
// A stunning animated entry point for the Aurora Student Portfolio application.
// Shows the logo, student name, animated progress bar, and floating gradient
// orbs. The screen is guaranteed to display for at least 7 seconds before
// navigating to the home page, giving the user a polished first impression.
//
// Key design decisions:
//   - NO BackdropFilter / ImageFilter.blur — those widgets are GPU-heavy and
//     cause a visible black-screen delay on cold starts (especially on
//     mid-range physical devices). Instead we simulate the "glowing orb" look
//     with large, semi-transparent, rounded containers that already look
//     blurred because of their huge border-radius.
//   - Provider.of is captured inside addPostFrameCallback so that it is never
//     called before the widget tree is fully built.
//   - A Stopwatch tracks wall-clock time so we can guarantee the 7-second
//     minimum even if data-loading finishes earlier.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/profile_controller.dart';
import '../services/auth_service.dart';
import 'package:go_router/go_router.dart';

// ---------------------------------------------------------------------------
// SplashScreen widget
// ---------------------------------------------------------------------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ---- Animation controllers ------------------------------------------------
  late final AnimationController _bgFadeCtrl;
  late final Animation<double> _bgFade;

  late final AnimationController _logoCtrl;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoRotation;

  late final AnimationController _textCtrl;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _textScale;

  late final AnimationController _progressCtrl;
  late final Animation<double> _progressValue;

  late final AnimationController _blobCtrl;

  late final AnimationController _shimmerCtrl;

  // ---- State flags ----------------------------------------------------------
  bool _initialized = false;

  // ---- Minimum display duration (wall-clock) --------------------------------
  static const Duration _minDisplayDuration = Duration(milliseconds: 2500);
  late final Stopwatch _stopwatch;

  // ---- Lifecycle ------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    _setupAnimations();

    // Defer the async sequence until the very first frame is painted so that
    // Provider.of and the widget tree are guaranteed to be available.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSequence();
    });
  }

  @override
  void dispose() {
    _bgFadeCtrl.dispose();
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _progressCtrl.dispose();
    _blobCtrl.dispose();
    _shimmerCtrl.dispose();
    super.dispose();
  }

  // ---- Animation setup ------------------------------------------------------
  void _setupAnimations() {
    // Background fade-in (fast — removes the native-splash color quickly)
    _bgFadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _bgFade = CurvedAnimation(parent: _bgFadeCtrl, curve: Curves.easeIn);

    // Logo scale + rotation
    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut),
    );
    _logoRotation = Tween<double>(begin: -0.25, end: 0.0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOutCubic),
    );

    // Text slide + fade
    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textCtrl,
        curve: const Interval(0.15, 1.0, curve: Curves.easeIn),
      ),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textCtrl, curve: Curves.easeOutCubic),
    );
    _textScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _textCtrl, curve: Curves.easeOutBack),
    );

    // Linear progress bar (fills across the full 7 seconds)
    _progressCtrl = AnimationController(
      vsync: this,
      duration: _minDisplayDuration,
    );
    _progressValue = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressCtrl, curve: Curves.easeInOut),
    );

    // Floating blob orbit
    _blobCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    // Shimmer effect
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  // ---- Choreographed sequence -----------------------------------------------
  Future<void> _startSequence() async {
    if (!mounted) return;

    final profileCtrl = Provider.of<ProfileController>(context, listen: false);

    // Start the progress bar immediately
    _progressCtrl.forward();

    // Phase 1: Background fade-in
    _bgFadeCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    // Phase 2: Logo pops in
    _logoCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    // Phase 3: Text slides up
    _textCtrl.forward();

    // Phase 4: Pre-load profile data in the background
    if (!profileCtrl.isLoading) {
      await profileCtrl.reloadData();
    }

    // Phase 5: Wait for the remaining time so the total is >= 7 seconds
    _stopwatch.stop();
    final elapsed = _stopwatch.elapsed;
    if (elapsed < _minDisplayDuration) {
      await Future.delayed(_minDisplayDuration - elapsed);
    }
    if (!mounted) return;

    // Mark as done and navigate
    setState(() {
      _initialized = true;
    });
    _navigateToHome();
  }

  void _navigateToHome() {
    if (!mounted) return;
    final auth = Provider.of<AuthService>(context, listen: false);
    if (auth.isLoggedIn) {
      context.go('/home');
    } else {
      context.go('/auth');
    }
  }

  // ---- Build ----------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.secondary;
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF070B17) : const Color(0xFFF6F8FC),
      body: FadeTransition(
        opacity: _bgFade,
        child: Stack(
          children: [
            // ---- Animated gradient blobs -----------------------------------
            _buildAnimatedBlobs(primary, secondary, isDark, screenSize),

            // ---- Radial gradient overlay for depth -------------------------
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [
                    Colors.transparent,
                    (isDark ? Colors.black : Colors.white).withValues(
                      alpha: 0.4,
                    ),
                  ],
                ),
              ),
            ),

            // ---- Main content column ---------------------------------------
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      const Spacer(flex: 3),

                      // Logo
                      _buildLogo(theme, primary, secondary),

                      const SizedBox(height: 56),

                      // Text block
                      _buildTextBlock(theme, isDark, primary),

                      const Spacer(flex: 3),

                      // Progress bar + footer
                      _buildProgressSection(theme, primary),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Subwidget: Animated Blobs --------------------------------------------
  Widget _buildAnimatedBlobs(
    Color primary,
    Color secondary,
    bool isDark,
    Size screenSize,
  ) {
    return AnimatedBuilder(
      animation: _blobCtrl,
      builder: (context, _) {
        final t = _blobCtrl.value * 2 * math.pi;
        return Stack(
          children: [
            // Top-left blob
            Positioned(
              top: math.sin(t) * 60 - 120,
              left: math.cos(t) * 60 - 100,
              child: _GlowingOrb(
                size: screenSize.width * 0.95,
                color: primary.withValues(alpha: isDark ? 0.12 : 0.15),
              ),
            ),
            // Bottom-right blob
            Positioned(
              bottom: math.cos(t * 0.7) * 50 - 100,
              right: math.sin(t * 0.7) * 50 - 80,
              child: _GlowingOrb(
                size: screenSize.width * 0.85,
                color: secondary.withValues(alpha: isDark ? 0.10 : 0.12),
              ),
            ),
            // Center-right accent blob
            Positioned(
              top: screenSize.height * 0.35 + math.sin(t * 1.3) * 30,
              right: -60 + math.cos(t * 1.3) * 40,
              child: _GlowingOrb(
                size: 220,
                color: primary.withValues(alpha: isDark ? 0.08 : 0.10),
              ),
            ),
          ],
        );
      },
    );
  }

  // ---- Subwidget: Logo ------------------------------------------------------
  Widget _buildLogo(ThemeData theme, Color primary, Color secondary) {
    return AnimatedBuilder(
      animation: _logoCtrl,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScale.value,
          child: Transform.rotate(
            angle: _logoRotation.value,
            child: child,
          ),
        );
      },
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.scaffoldBackgroundColor.withValues(alpha: 0.75),
          border: Border.all(
            color: primary.withValues(alpha: 0.45),
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.45),
              blurRadius: 40,
              spreadRadius: 8,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: secondary.withValues(alpha: 0.25),
              blurRadius: 60,
              spreadRadius: -4,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Center(
          child: ClipOval(
            child: Image.asset(
              'assets/images/app_logo.jpg',
              width: 145,
              height: 145,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  // ---- Subwidget: Text Block ------------------------------------------------
  Widget _buildTextBlock(ThemeData theme, bool isDark, Color primary) {
    return SlideTransition(
      position: _textSlide,
      child: FadeTransition(
        opacity: _textOpacity,
        child: ScaleTransition(
          scale: _textScale,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Hero text with glow shadow
              Text(
                'STUDENTS PROFILE',
                textAlign: TextAlign.center,
                style: theme.textTheme.displaySmall?.copyWith(
                  letterSpacing: 4,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : Colors.black87,
                  shadows: [
                    Shadow(
                      color: primary.withValues(alpha: 0.8),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                    Shadow(
                      color: primary.withValues(alpha: 0.5),
                      blurRadius: 40,
                      offset: const Offset(0, 8),
                    ),
                    Shadow(
                      color: theme.colorScheme.secondary.withValues(alpha: 0.3),
                      blurRadius: 60,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Student real dynamic name
              Consumer<ProfileController>(
                builder: (context, ctrl, _) {
                  final name = ctrl.isLoading
                      ? 'LOADING...'
                      : (ctrl.profile?.fullName.toUpperCase() ?? 'STUDENT');
                  
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween<Offset>(
                                begin: const Offset(0, 0.2), end: Offset.zero)
                            .animate(anim),
                        child: child,
                      ),
                    ),
                    child: Container(
                      key: ValueKey<String>(name),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primary.withValues(alpha: 0.2),
                            theme.colorScheme.secondary.withValues(alpha: 0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: primary.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.15),
                            blurRadius: 15,
                            spreadRadius: 2,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Text(
                        name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          letterSpacing: 6,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : primary,
                          shadows: [
                            Shadow(
                              color: primary.withValues(alpha: 0.6),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Subwidget: Progress Section ------------------------------------------
  Widget _buildProgressSection(ThemeData theme, Color primary) {
    return AnimatedOpacity(
      opacity: _initialized ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 400),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated shimmer progress bar
          AnimatedBuilder(
            animation: Listenable.merge([_progressCtrl, _shimmerCtrl]),
            builder: (context, _) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  height: 6,
                  width: 200,
                  child: CustomPaint(
                    painter: _ShimmerProgressPainter(
                      progress: _progressValue.value,
                      shimmerPhase: _shimmerCtrl.value,
                      baseColor: primary,
                      trackColor: primary.withValues(alpha: 0.15),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 18),

          // Footer text
          Text(
            'Devixo Internship — Task 01',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _GlowingOrb — a simple, GPU-friendly alternative to BackdropFilter blobs
// ---------------------------------------------------------------------------
class _GlowingOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowingOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color,
            color.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 1.0],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _ShimmerProgressPainter — draws the thin progress bar with a shimmer sweep
// ---------------------------------------------------------------------------
class _ShimmerProgressPainter extends CustomPainter {
  final double progress;
  final double shimmerPhase;
  final Color baseColor;
  final Color trackColor;

  _ShimmerProgressPainter({
    required this.progress,
    required this.shimmerPhase,
    required this.baseColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Track
    final trackPaint = Paint()..color = trackColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(6),
      ),
      trackPaint,
    );

    // Filled portion
    final fillWidth = size.width * progress;
    if (fillWidth <= 0) return;

    final fillRect = Rect.fromLTWH(0, 0, fillWidth, size.height);
    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          baseColor,
          baseColor.withValues(alpha: 0.7),
          baseColor,
        ],
        stops: [
          (shimmerPhase - 0.3).clamp(0.0, 1.0),
          shimmerPhase.clamp(0.0, 1.0),
          (shimmerPhase + 0.3).clamp(0.0, 1.0),
        ],
      ).createShader(fillRect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(fillRect, const Radius.circular(6)),
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ShimmerProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.shimmerPhase != shimmerPhase;
  }
}
