import os

def write_file(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)

responsive_utils = """/// Responsive Utilities
///
/// Contains breakpoints and helpers for responsive layouts.
import 'package:flutter/material.dart';

class ResponsiveUtils {
  static const double compactMobile = 480;
  static const double largeMobile = 600;
  static const double tablet = 840;
  static const double desktop = 1200;

  static bool isCompactMobile(BuildContext context) => MediaQuery.of(context).size.width < compactMobile;
  static bool isLargeMobile(BuildContext context) => MediaQuery.of(context).size.width >= compactMobile && MediaQuery.of(context).size.width < largeMobile;
  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= largeMobile && MediaQuery.of(context).size.width < tablet;
  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= tablet;

  static int getCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < largeMobile) return 1;
    if (width < desktop) return 2;
    return 3;
  }
  
  static double getMaxWidth(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width >= desktop) return 1000.0;
    if (width >= tablet) return 800.0;
    return width;
  }
}
"""

bottom_navigation = """/// Bottom Navigation
///
/// A highly animated responsive bottom navigation bar.
import 'package:flutter/material.dart';

class AnimatedBottomNavigation extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AnimatedBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  State<AnimatedBottomNavigation> createState() => _AnimatedBottomNavigationState();
}

class _AnimatedBottomNavigationState extends State<AnimatedBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, 'Home', 0),
              _buildNavItem(Icons.person_rounded, 'Profile', 1),
              _buildNavItem(Icons.auto_awesome, 'Skills', 2),
              _buildNavItem(Icons.school_rounded, 'Education', 3),
              _buildNavItem(Icons.work_rounded, 'Projects', 4),
              _buildNavItem(Icons.mail_rounded, 'Contact', 5),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = widget.currentIndex == index;
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return GestureDetector(
      onTap: () => widget.onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                color: isSelected ? primaryColor : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                size: 24,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
"""

animated_button = """/// Animated Button Widget
///
/// Provides bounce scale animation and ripple effect.
import 'package:flutter/material.dart';

class AnimatedBounceButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color? color;
  
  const AnimatedBounceButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  State<AnimatedBounceButton> createState() => _AnimatedBounceButtonState();
}

class _AnimatedBounceButtonState extends State<AnimatedBounceButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
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
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: widget.color ?? Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: (widget.color ?? Theme.of(context).colorScheme.primary).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
"""

drawer = """/// Navigation Drawer
///
/// Responsive sidebar navigation.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/theme_controller.dart';

class AppDrawer extends StatelessWidget {
  final Function(int) onNavigate;
  final int currentIndex;

  const AppDrawer({
    Key? key,
    required this.onNavigate,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    child: Icon(Icons.person, size: 30, color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Jane Doe', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                        Text('Developer Intern', style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _buildDrawerItem(context, 0, Icons.home_rounded, 'Home'),
                  _buildDrawerItem(context, 1, Icons.person_rounded, 'Profile'),
                  _buildDrawerItem(context, 2, Icons.auto_awesome, 'Skills'),
                  _buildDrawerItem(context, 3, Icons.school_rounded, 'Education'),
                  _buildDrawerItem(context, 4, Icons.work_rounded, 'Projects'),
                  _buildDrawerItem(context, 5, Icons.mail_rounded, 'Contact'),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(themeController.isDarkMode ? Icons.light_mode : Icons.dark_mode),
              title: Text(themeController.isDarkMode ? 'Light Mode' : 'Dark Mode'),
              onTap: () {
                themeController.toggleTheme();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, int index, IconData icon, String title) {
    final isSelected = currentIndex == index;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? primaryColor : Theme.of(context).iconTheme.color,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? primaryColor : Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          onNavigate(index);
        },
      ),
    );
  }
}
"""

write_file('lib/utils/responsive_utils.dart', responsive_utils)
write_file('lib/widgets/bottom_navigation.dart', bottom_navigation)
write_file('lib/widgets/animated_button.dart', animated_button)
write_file('lib/widgets/navigation_drawer.dart', drawer)

print("Part 3 generated")
