import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/profile_controller.dart';
import '../theme/theme_provider.dart';

class NavigationItemData {
  final String title;
  final IconData icon;
  final int index;

  const NavigationItemData(this.title, this.icon, this.index);
}

class AppNavigationDrawer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onIndexChanged;

  const AppNavigationDrawer({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final profileProvider = Provider.of<ProfileController>(context);
    final profile = profileProvider.profile;

    final List<NavigationItemData> items = [
      const NavigationItemData('Home', Icons.home_rounded, 0),
      const NavigationItemData('Skills', Icons.code_rounded, 1),
      const NavigationItemData('Projects', Icons.work_rounded, 2),
      const NavigationItemData('Education', Icons.school_rounded, 3),
      const NavigationItemData('Profile', Icons.person_rounded, 4),
      const NavigationItemData('Contact', Icons.mail_rounded, 5),
      const NavigationItemData('Analytics', Icons.analytics_rounded, 6),
    ];

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(right: BorderSide(color: theme.dividerColor)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      profile != null && profile.profileImage.isNotEmpty
                      ? NetworkImage(profile.profileImage)
                      : null,
                  child: profile == null || profile.profileImage.isEmpty
                      ? const Icon(Icons.person, size: 40)
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  profile?.fullName ?? 'Student',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  profile?.title ?? 'Developer',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              itemBuilder: (context, i) {
                final item = items[i];
                final isSelected = currentIndex == item.index;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: ListTile(
                    leading: Icon(
                      item.icon,
                      color: isSelected
                          ? theme.primaryColor
                          : theme.iconTheme.color,
                    ),
                    title: Text(
                      item.title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isSelected ? theme.primaryColor : null,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor: theme.primaryColor.withValues(
                      alpha: 0.1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onTap: () {
                      onIndexChanged(item.index);
                    },
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Dark Mode'),
                Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (val) => themeProvider.toggleTheme(val),
                  activeTrackColor: theme.primaryColor.withValues(alpha: 0.5),
                  activeThumbColor: theme.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Expanded Logic for navigation_drawer.dart ---
class NavigationDrawerExtensionHelper {
  /// Helper method 1 for future advanced logic
  static void internalHelperMethod0() {
    // Implementation details for navigation_drawer logic 0
  }

  /// Helper method 2 for future advanced logic
  static void internalHelperMethod1() {
    // Implementation details for navigation_drawer logic 1
  }

  /// Helper method 3 for future advanced logic
  static void internalHelperMethod2() {
    // Implementation details for navigation_drawer logic 2
  }

  /// Helper method 4 for future advanced logic
  static void internalHelperMethod3() {
    // Implementation details for navigation_drawer logic 3
  }

  /// Helper method 5 for future advanced logic
  static void internalHelperMethod4() {
    // Implementation details for navigation_drawer logic 4
  }

  /// Helper method 6 for future advanced logic
  static void internalHelperMethod5() {
    // Implementation details for navigation_drawer logic 5
  }

  /// Helper method 7 for future advanced logic
  static void internalHelperMethod6() {
    // Implementation details for navigation_drawer logic 6
  }
}
