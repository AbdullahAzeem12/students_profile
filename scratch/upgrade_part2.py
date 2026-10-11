import os

def write_file(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content.strip() + '\n')

def main():
    # 1. Profile Controller Update
    write_file('lib/controllers/profile_controller.dart', """
import 'package:flutter/foundation.dart';
import '../models/student_profile.dart';
import '../models/skill.dart';
import '../models/education.dart';
import '../models/project.dart';
import '../models/contact_info.dart';
import '../data/mock_data.dart';

class ProfileController with ChangeNotifier {
  StudentProfile? _profile;
  List<Skill> _skills = [];
  List<Education> _education = [];
  List<Project> _projects = [];
  ContactInfo? _contactInfo;

  bool _isLoading = false;
  String? _errorMessage;

  StudentProfile? get profile => _profile;
  List<Skill> get skills => _skills;
  List<Education> get education => _education;
  List<Project> get projects => _projects;
  ContactInfo? get contactInfo => _contactInfo;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Analytics logic
  int get totalProjects => _projects.length;
  double get averageSkillMastery {
    if (_skills.isEmpty) return 0.0;
    final total = _skills.fold(0.0, (sum, skill) => sum + skill.masteryPercentage);
    return total / _skills.length;
  }

  // Categories extraction
  List<String> get projectCategories {
    final categories = _projects.map((p) => p.category).toSet().toList();
    categories.insert(0, 'All');
    return categories;
  }

  List<String> get skillCategories {
    final categories = _skills.map((s) => s.category).toSet().toList();
    categories.insert(0, 'All');
    return categories;
  }

  Future<void> loadAllData() async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate network delay for realism
      await Future.delayed(const Duration(milliseconds: 1500));

      _profile = MockData.getProfile();
      _skills = MockData.getSkills();
      _education = MockData.getEducation();
      _projects = MockData.getProjects();
      _contactInfo = MockData.getContactInfo();

    } catch (e) {
      _errorMessage = 'Failed to load profile data: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Filtering Logic
  List<Project> getProjectsByCategory(String category) {
    if (category == 'All') return _projects;
    return _projects.where((p) => p.category == category).toList();
  }

  List<Skill> getSkillsByCategory(String category) {
    if (category == 'All') return _skills;
    return _skills.where((s) => s.category == category).toList();
  }

  List<Project> searchProjects(String query) {
    if (query.isEmpty) return _projects;
    final lowerQuery = query.toLowerCase();
    return _projects.where((p) {
      return p.title.toLowerCase().contains(lowerQuery) ||
             p.shortDescription.toLowerCase().contains(lowerQuery) ||
             p.technologies.any((t) => t.toLowerCase().contains(lowerQuery));
    }).toList();
  }
}
""")

    # 2. Animated Button
    write_file('lib/widgets/animated_button.dart', """
import 'package:flutter/material.dart';

/// A highly interactive, professional animated button with scale, elevation, and glow physics.
class AnimatedBounceButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double scaleDownFactor;
  final Duration duration;
  final bool enableGlow;
  final Color? glowColor;

  const AnimatedBounceButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.scaleDownFactor = 0.95,
    this.duration = const Duration(milliseconds: 150),
    this.enableGlow = false,
    this.glowColor,
  });

  @override
  State<AnimatedBounceButton> createState() => _AnimatedBounceButtonState();
}

class _AnimatedBounceButtonState extends State<AnimatedBounceButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scaleDownFactor).animate(
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  boxShadow: (widget.enableGlow && _isHovered) ? [
                    BoxShadow(
                      color: (widget.glowColor ?? theme.primaryColor).withValues(alpha: isDark ? 0.4 : 0.2),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    )
                  ] : [],
                ),
                child: widget.child,
              ),
            );
          },
        ),
      ),
    );
  }
}
""")

    # 3. Bottom Navigation
    write_file('lib/widgets/bottom_navigation.dart', """
import 'package:flutter/material.dart';
import '../models/navigation_item.dart';
import '../utils/responsive_utils.dart';

class AnimatedBottomNavigation extends StatefulWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  const AnimatedBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  State<AnimatedBottomNavigation> createState() => _AnimatedBottomNavigationState();
}

class _AnimatedBottomNavigationState extends State<AnimatedBottomNavigation> {
  final List<NavigationItem> _items = [
    NavigationItem(title: 'Home', icon: Icons.home_rounded, index: 0),
    NavigationItem(title: 'Profile', icon: Icons.person_rounded, index: 1),
    NavigationItem(title: 'Skills', icon: Icons.bolt_rounded, index: 2),
    NavigationItem(title: 'Education', icon: Icons.school_rounded, index: 3),
    NavigationItem(title: 'Projects', icon: Icons.work_rounded, index: 4),
    NavigationItem(title: 'Contact', icon: Icons.mail_rounded, index: 5),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: GlassContainer(
        color: theme.scaffoldBackgroundColor.withValues(alpha: 0.8),
        blur: 15.0,
        borderRadius: 24.0,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _items.map((item) {
            final isSelected = widget.currentIndex == item.index;
            return GestureDetector(
              onTap: () => widget.onItemSelected(item.index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutQuint,
                padding: EdgeInsets.symmetric(
                  horizontal: isSelected ? 16 : 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? theme.primaryColor.withValues(alpha: isDark ? 0.2 : 0.1) 
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                      child: Icon(
                        item.icon,
                        key: ValueKey<bool>(isSelected),
                        color: isSelected ? theme.primaryColor : theme.iconTheme.color?.withValues(alpha: 0.6),
                        size: isSelected ? 26 : 22,
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.title,
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
""")

    # 4. Navigation Drawer
    write_file('lib/widgets/navigation_drawer.dart', """
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/navigation_item.dart';
import '../controllers/profile_controller.dart';
import '../controllers/theme_controller.dart';
import '../utils/responsive_utils.dart';

class AppDrawer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  const AppDrawer({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileProvider = Provider.of<ProfileController>(context);
    final profile = profileProvider.profile;

    final List<NavigationItem> items = [
      NavigationItem(title: 'Home', icon: Icons.home_rounded, index: 0),
      NavigationItem(title: 'Profile', icon: Icons.person_rounded, index: 1),
      NavigationItem(title: 'Skills', icon: Icons.bolt_rounded, index: 2),
      NavigationItem(title: 'Education', icon: Icons.school_rounded, index: 3),
      NavigationItem(title: 'Projects', icon: Icons.work_rounded, index: 4),
      NavigationItem(title: 'Contact', icon: Icons.mail_rounded, index: 5),
    ];

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.1),
            ),
            accountName: Text(
              profile?.fullName ?? 'Student Name',
              style: theme.textTheme.titleLarge,
            ),
            accountEmail: Text(
              profile?.headline ?? 'Student Headline',
              style: theme.textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            currentAccountPicture: profile?.profileImageUrl != null
                ? CircleAvatar(backgroundImage: NetworkImage(profile!.profileImageUrl))
                : const CircleAvatar(child: Icon(Icons.person)),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: items.map((item) {
                final isSelected = currentIndex == item.index;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    tileColor: isSelected ? theme.primaryColor.withValues(alpha: 0.1) : Colors.transparent,
                    leading: Icon(
                      item.icon,
                      color: isSelected ? theme.primaryColor : theme.iconTheme.color,
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? theme.primaryColor : theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    onTap: () {
                      onItemSelected(item.index);
                      if (ResponsiveUtils.isMobile(context)) {
                        Navigator.pop(context); // Close drawer on mobile
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Dark Mode', style: theme.textTheme.bodyLarge),
                Consumer<ThemeController>(
                  builder: (context, themeController, child) {
                    return Switch(
                      value: themeController.isDarkMode,
                      onChanged: (val) => themeController.toggleTheme(),
                      activeColor: theme.primaryColor,
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
""")

if __name__ == '__main__':
    main()
    print("Upgrade Part 2 complete.")
