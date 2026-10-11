import os

def write_file(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content.strip() + '\n')

def main():
    # 1. Home Screen
    write_file('lib/screens/home_screen.dart', """
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/profile_controller.dart';
import '../utils/responsive_utils.dart';
import '../widgets/animated_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileController>(context);
    final theme = Theme.of(context);

    if (profileProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (profileProvider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(profileProvider.errorMessage!, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            AnimatedBounceButton(
              onPressed: () => profileProvider.loadAllData(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(color: theme.primaryColor, borderRadius: BorderRadius.circular(8)),
                child: const Text('Retry', style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      );
    }

    final profile = profileProvider.profile;
    if (profile == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_getGreeting()},',
            style: theme.textTheme.titleLarge?.copyWith(color: theme.textTheme.bodyMedium?.color),
          ),
          const SizedBox(height: 8),
          Text(
            profile.fullName.split(' ').first,
            style: theme.textTheme.displayLarge?.copyWith(fontSize: ResponsiveUtils.isMobile(context) ? 36 : 48),
          ),
          const SizedBox(height: 32),
          _buildQuickStats(context, profileProvider),
          const SizedBox(height: 32),
          Text('Featured Skills', style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),
          _buildTopSkills(context, profileProvider),
          const SizedBox(height: 32),
          _buildRecentActivity(context, theme),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, ProfileController provider) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildStatCard(context, Icons.work_rounded, 'Projects', provider.totalProjects.toString()),
        _buildStatCard(context, Icons.star_rounded, 'Avg. Mastery', '${provider.averageSkillMastery.toStringAsFixed(0)}%'),
        _buildStatCard(context, Icons.code_rounded, 'Top Skill', provider.skills.isNotEmpty ? provider.skills.first.name : 'N/A'),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    final width = ResponsiveUtils.isMobile(context) 
        ? (MediaQuery.of(context).size.width - 48) / 2 
        : 200.0;
        
    return AnimatedBounceButton(
      enableGlow: true,
      onPressed: () {},
      child: Container(
        width: width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.dividerColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: theme.primaryColor, size: 28),
            const SizedBox(height: 12),
            Text(value, style: theme.textTheme.displayMedium?.copyWith(fontSize: 24)),
            const SizedBox(height: 4),
            Text(label, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSkills(BuildContext context, ProfileController provider) {
    final topSkills = provider.skills.take(4).toList();
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: topSkills.map((skill) {
        return Chip(
          label: Text(skill.name),
          avatar: const Icon(Icons.check_circle_outline, size: 16),
          backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          labelStyle: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        );
      }).toList(),
    );
  }

  Widget _buildRecentActivity(BuildContext context, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent Activity', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildTimelineItem(theme, 'Committed to open-source repository', '2 hours ago', true),
            _buildTimelineItem(theme, 'Completed Advanced State Management Course', 'Yesterday', false),
            _buildTimelineItem(theme, 'Published new portfolio version', '3 days ago', false, isLast: true),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(ThemeData theme, String title, String time, bool isRecent, {bool isLast = false}) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isRecent ? theme.primaryColor : theme.disabledColor,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: theme.dividerColor,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: isRecent ? FontWeight.bold : FontWeight.normal)),
                  const SizedBox(height: 4),
                  Text(time, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
""")

    # 2. Profile Screen
    write_file('lib/screens/profile_screen.dart', """
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/profile_controller.dart';
import '../utils/responsive_utils.dart';
import '../widgets/animated_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isBioExpanded = false;
  bool _isDownloading = false;

  void _simulateDownload() async {
    setState(() => _isDownloading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isDownloading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Resume downloaded successfully!'),
          backgroundColor: Theme.of(context).primaryColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileController>(context);
    final theme = Theme.of(context);

    if (profileProvider.isLoading) return const Center(child: CircularProgressIndicator());
    final profile = profileProvider.profile;
    if (profile == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(context, profile.coverImageUrl, profile.profileImageUrl),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.getResponsivePadding(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Text(profile.fullName, style: theme.textTheme.displayMedium),
                const SizedBox(height: 8),
                Text(
                  profile.headline,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(color: theme.primaryColor),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, color: theme.textTheme.bodyMedium?.color, size: 16),
                    const SizedBox(width: 4),
                    Text(profile.location, style: theme.textTheme.bodyMedium),
                    const SizedBox(width: 16),
                    Icon(Icons.school, color: theme.textTheme.bodyMedium?.color, size: 16),
                    const SizedBox(width: 4),
                    Text('${profile.university} \\'${profile.graduationYear.toString().substring(2)}', style: theme.textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: 32),
                _buildActionButtons(theme),
                const SizedBox(height: 32),
                _buildBioSection(theme, profile.bio),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String coverUrl, String avatarUrl) {
    final screenWidth = MediaQuery.of(context).size.width;
    final coverHeight = ResponsiveUtils.isMobile(context) ? 150.0 : 250.0;
    
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: screenWidth,
          height: coverHeight,
          decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(coverUrl), fit: BoxFit.cover),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -50,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(avatarUrl),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: [
        AnimatedBounceButton(
          enableGlow: true,
          onPressed: _isDownloading ? () {} : _simulateDownload,
          child: Container(
            width: 200,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: theme.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _isDownloading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.download_rounded, color: Colors.white),
                const SizedBox(width: 12),
                Text(
                  _isDownloading ? 'Downloading...' : 'Download Resume',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBioSection(ThemeData theme, String bio) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('About Me', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            AnimatedCrossFade(
              firstChild: Text(
                bio,
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              secondChild: Text(
                bio,
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
              ),
              crossFadeState: _isBioExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => setState(() => _isBioExpanded = !_isBioExpanded),
              child: Text(
                _isBioExpanded ? 'Read Less' : 'Read More',
                style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
""")

if __name__ == '__main__':
    main()
    print("Upgrade Part 3 complete.")
