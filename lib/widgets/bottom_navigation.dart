import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'rainbow_border_container.dart';

class AnimatedBottomNavigation extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AnimatedBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<AnimatedBottomNavigation> createState() => _AnimatedBottomNavigationState();
}

class _AnimatedBottomNavigationState extends State<AnimatedBottomNavigation> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      7,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1500),
      )..repeat(reverse: true),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0),
      child: RainbowBorderContainer(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withValues(alpha: 0.15),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildNavItem(context, Icons.home_rounded, 'Home', 0),
                      const SizedBox(width: 8),
                      _buildNavItem(context, Icons.code_rounded, 'Skills', 1),
                      const SizedBox(width: 8),
                      _buildNavItem(context, Icons.work_rounded, 'Projects', 2),
                      const SizedBox(width: 8),
                      _buildNavItem(context, Icons.school_rounded, 'Education', 3),
                      const SizedBox(width: 8),
                      _buildNavItem(context, Icons.person_rounded, 'Profile', 4),
                      const SizedBox(width: 8),
                      _buildNavItem(context, Icons.mail_rounded, 'Contact', 5),
                      const SizedBox(width: 8),
                      _buildNavItem(context, Icons.analytics_rounded, 'Analytics', 6),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
  ) {
    final theme = Theme.of(context);
    final isSelected = widget.currentIndex == index;
    final animation = _controllers[index];

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastLinearToSlowEaseIn,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 24 : 12,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    theme.primaryColor.withValues(alpha: 0.2),
                    theme.primaryColor.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: isSelected ? 1.0 + (animation.value * 0.1) : 1.0,
                  child: child,
                );
              },
              child: Icon(
                icon,
                color: isSelected ? theme.primaryColor : theme.iconTheme.color?.withValues(alpha: 0.6),
                size: 24,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCirc,
              child: SizedBox(
                width: isSelected ? null : 0,
                child: Padding(
                  padding: EdgeInsets.only(left: isSelected ? 8.0 : 0),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: theme.primaryColor.withValues(alpha: 0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        )
                      ]
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
