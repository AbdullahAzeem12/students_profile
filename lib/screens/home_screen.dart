import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

import '../controllers/profile_controller.dart';
import '../utils/responsive_utils.dart';
import '../widgets/animated_button.dart';
import '../widgets/rainbow_border_container.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';

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
    final auth = Provider.of<AuthService>(context);
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
            Text(
              profileProvider.errorMessage!,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            AnimatedBounceButton(
              onPressed: () => profileProvider.loadAllData(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInDown(
                      duration: const Duration(milliseconds: 600),
                      child: Text(
                        '${_getGreeting()},',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    FadeInDown(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 600),
                      child: Text(
                        profile.fullName.split(' ').first,
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontSize: ResponsiveUtils.isMobile(context) ? 36 : 48,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    FadeInDown(
                      delay: const Duration(milliseconds: 300),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          profile.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (profile.profileImage.isNotEmpty || (auth.currentUser?.profilePicBase64.isNotEmpty ?? false))
                FadeInRight(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => _showNotificationsPanel(context),
                        icon: Stack(
                          children: [
                            const Icon(Icons.notifications_none, size: 28),
                            Positioned(
                              right: 2,
                              top: 2,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 10,
                                  minHeight: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: ResponsiveUtils.isMobile(context) ? 40 : 60,
                        backgroundColor: theme.primaryColor.withValues(alpha: 0.15),
                        backgroundImage: _getProfileImageProvider(profile.profileImage, auth.currentUser?.profilePicBase64),
                        onBackgroundImageError: (error, stackTrace) {},
                        child: (profile.profileImage.isEmpty && (auth.currentUser?.profilePicBase64.isEmpty ?? true))
                            ? Icon(Icons.person, size: ResponsiveUtils.isMobile(context) ? 36 : 50, color: theme.primaryColor)
                            : null,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          FadeInDown(
            delay: const Duration(milliseconds: 400),
            child: Text(
              profile.shortBio,
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.5,
                shadows: [
                  Shadow(
                    color: theme.primaryColor.withValues(alpha: 0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: _buildQuickStats(context, profileProvider),
          ),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 500),
            child: _buildNavigationOptions(context, theme),
          ),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 600),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text('Featured Skills', style: theme.textTheme.titleLarge),
            ),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 800),
            child: _buildTopSkills(context, profileProvider),
          ),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 1000),
            child: _buildRecentActivity(context, theme),
          ),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 1200),
            child: ResponsiveUtils.isMobile(context)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildUpcomingGoals(context, theme),
                      const SizedBox(height: 16),
                      _buildLiveSchedule(context, theme),
                    ],
                  )
                : IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: _buildUpcomingGoals(context, theme)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildLiveSchedule(context, theme)),
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, ProfileController provider) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final crossAxisCount = isMobile ? 2 : 4;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      childAspectRatio: isMobile ? 0.6 : 0.8, // Gives more vertical space to prevent pixel overflow
      children: [
        _buildStatCard(
          context,
          Icons.work_rounded,
          'Projects',
          provider.totalProjects.toString(),
          'You have completed ${provider.totalProjects} projects so far. Click on the Projects tab to view details.',
          trendText: '+2 recently',
          progressValue: (provider.totalProjects / 10).clamp(0.0, 1.0),
        ),
        _buildStatCard(
          context,
          Icons.star_rounded,
          'Avg. Mastery',
          '${provider.averageSkillMastery.toStringAsFixed(0)}%',
          'Your overall skill mastery is ${provider.averageSkillMastery.toStringAsFixed(0)}%. Keep learning to increase this!',
          trendText: '+5% up',
          progressValue: (provider.averageSkillMastery / 100).clamp(0.0, 1.0),
        ),
        _buildStatCard(
          context,
          Icons.code_rounded,
          'Top Skill',
          provider.skills.isNotEmpty ? provider.skills.first.name : 'N/A',
          'Your most proficient skill is ${provider.skills.isNotEmpty ? provider.skills.first.name : 'N/A'} at ${provider.skills.isNotEmpty ? provider.skills.first.masteryPercentage : 0}%.',
          trendText: 'Rank #1',
          progressValue: provider.skills.isNotEmpty ? (provider.skills.first.masteryPercentage / 100.0) : 0.0,
        ),
        _buildStatCard(
          context,
          Icons.workspace_premium_rounded,
          'Certificates',
          '5',
          'You have earned 5 professional certificates. Great work!',
          trendText: '+1 this month',
          progressValue: 5 / 10,
        ),
        _buildStatCard(
          context,
          Icons.timer_rounded,
          'Hours Logged',
          '120h',
          'You have logged 120 hours of focused coding and learning.',
          trendText: 'Trending',
          progressValue: 120 / 200,
        ),
        _buildStatCard(
          context,
          Icons.people_alt_rounded,
          'Connections',
          '150+',
          'You have connected with over 150 professionals and students.',
          trendText: 'Growing',
          progressValue: 150 / 500,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    String description, {
    String? trendText,
    bool isTrendPositive = true,
    double? progressValue,
  }) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: AnimatedBounceButton(
        enableGlow: true,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Row(
                children: [
                  Icon(icon, color: theme.primaryColor),
                  const SizedBox(width: 8),
                  Expanded(child: Text(label)),
                ],
              ),
              content: SingleChildScrollView(
                child: Text(description, style: theme.textTheme.bodyLarge),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          );
        },
        child: RainbowBorderContainer(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.cardTheme.color ?? theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.primaryColor.withValues(alpha: 0.15),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: theme.primaryColor, size: 24),
                  ),
                  if (trendText != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: (isTrendPositive ? Colors.greenAccent : Colors.redAccent).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        trendText,
                        style: TextStyle(
                          color: isTrendPositive ? Colors.greenAccent : Colors.redAccent,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
              ),
              if (progressValue != null) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progressValue,
                    minHeight: 4,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildTopSkills(BuildContext context, ProfileController provider) {
    final topSkills = provider.skills.take(4).toList();
    final isMobile = ResponsiveUtils.isMobile(context);
    final crossAxisCount = isMobile ? 2 : 4;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      childAspectRatio: 2.5, // 2.5 makes them look like nice wide chips
      children: topSkills.map((skill) {
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: AnimatedBounceButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('${skill.name} Mastery'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mastery: ${skill.masteryPercentage}%', style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 8),
                        Text('Category: ${skill.category.toString().split('.').last}', style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: skill.masteryPercentage / 100,
                          backgroundColor: Theme.of(context).dividerColor,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              );
            },
            child: RainbowBorderContainer(
              child: SizedBox(
                width: double.infinity,
              child: Chip(
                label: Text(skill.name, overflow: TextOverflow.ellipsis),
                avatar: const Icon(Icons.check_circle_outline, size: 16),
                backgroundColor: Theme.of(context).primaryColor
                    .withValues(alpha: 0.1),
                labelStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ));
      }).toList(),
    );
  }

  Widget _buildRecentActivity(BuildContext context, ThemeData theme) {
    final provider = Provider.of<ProfileController>(context, listen: false);
    final activities = provider.recentActivities;

    return AnimatedBounceButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Recent Activity Log'),
            content: SingleChildScrollView(
              child: Text('This is your complete activity timeline and history loaded directly from your professional profile.', style: theme.textTheme.bodyLarge),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        );
      },
      child: RainbowBorderContainer(
        child: Container(
          decoration: BoxDecoration(
            color: theme.cardTheme.color ?? theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.primaryColor.withValues(alpha: 0.15),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text('Recent Activity', style: theme.textTheme.titleLarge),
            ),
            const SizedBox(height: 16),
            ...activities.asMap().entries.map((entry) {
              final index = entry.key;
              final activity = entry.value;
              return _buildTimelineItem(
                theme,
                activity.title,
                activity.time,
                activity.isRecent,
                isLast: index == activities.length - 1,
              );
            }),
          ],
        ),
      ),
    ),
  ),
);
}

  Widget _buildTimelineItem(
    ThemeData theme,
    String title,
    String time,
    bool isRecent, {
    bool isLast = false,
  }) {
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
                Expanded(child: Container(width: 2, color: theme.dividerColor)),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: isRecent
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingGoals(BuildContext context, ThemeData theme) {
    return AnimatedBounceButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Goal Details'),
            content: SingleChildScrollView(
              child: const Text('This section tracks your upcoming milestones and semester goals. Complete courses and projects to progress!'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        );
      },
      child: RainbowBorderContainer(
        child: Container(
          height: 260, // Fixed height to ensure equal sizes
          padding: const EdgeInsets.all(20.0), // Better padding
          decoration: BoxDecoration(
            color: theme.cardTheme.color ?? theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.primaryColor.withValues(alpha: 0.15),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text('Upcoming Goals', style: theme.textTheme.titleLarge),
              ),
              const SizedBox(height: 16),
              Expanded(child: _buildGoalItem(theme, 'Master Flutter Animations', 0.7)),
              const SizedBox(height: 8),
              Expanded(child: _buildGoalItem(theme, 'Complete Final Year Project', 0.3)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalItem(ThemeData theme, String title, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title, 
                style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text('${(progress * 100).toInt()}%', style: theme.textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: theme.dividerColor,
          color: theme.primaryColor,
          borderRadius: BorderRadius.circular(8),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildLiveSchedule(BuildContext context, ThemeData theme) {
    return AnimatedBounceButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Live Class Schedule'),
            content: SingleChildScrollView(
              child: const Text('These are your upcoming live classes and meetings. Stay on top of your schedule!'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        );
      },
      child: RainbowBorderContainer(
        child: Container(
          height: 260, // Fixed height to ensure equal sizes
          padding: const EdgeInsets.all(20.0), // Better padding
          decoration: BoxDecoration(
            color: theme.cardTheme.color ?? theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.primaryColor.withValues(alpha: 0.15),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text('Live Schedule', style: theme.textTheme.titleLarge),
              ),
              const SizedBox(height: 16),
              Expanded(child: _buildScheduleItem(theme, 'Data Structures', '10:00 AM', true)),
              const SizedBox(height: 8),
              Expanded(child: _buildScheduleItem(theme, 'Software Eng.', '02:00 PM', false)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleItem(ThemeData theme, String title, String time, bool isLive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(time, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
        if (isLive)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.redAccent),
            ),
            child: const Text('LIVE', style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
      ],
    );
  }

  void _showNotificationsPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        final theme = Theme.of(sheetContext);
        return Container(
          height: MediaQuery.of(sheetContext).size.height * 0.6,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notifications',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(sheetContext),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildNotificationItem(
                      theme,
                      icon: Icons.work,
                      color: Colors.blueAccent,
                      title: 'New Profile View',
                      subtitle: 'A recruiter from TechCorp viewed your profile.',
                      time: '2 mins ago',
                    ),
                    _buildNotificationItem(
                      theme,
                      icon: Icons.star,
                      color: Colors.orangeAccent,
                      title: 'Project Milestone',
                      subtitle: 'Your "AI ChatBot" project reached 100 simulated views.',
                      time: '1 hour ago',
                    ),
                    _buildNotificationItem(
                      theme,
                      icon: Icons.update,
                      color: Colors.greenAccent,
                      title: 'App Update',
                      subtitle: 'New features have been added to your dashboard.',
                      time: '1 day ago',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationItem(ThemeData theme, {required IconData icon, required Color color, required String title, required String subtitle, required String time}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationOptions(BuildContext context, ThemeData theme) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isDark = theme.brightness == Brightness.dark;

    final navItems = [
      const _HomeNavOption(
        title: 'Student Profile',
        subtitle: 'Personal & Academic Info',
        icon: Icons.person_rounded,
        color: Color(0xFF6366F1),
        route: '/profile',
      ),
      const _HomeNavOption(
        title: 'Technical Skills',
        subtitle: 'Proficiencies & Stacks',
        icon: Icons.code_rounded,
        color: Color(0xFF06B6D4),
        route: '/skills',
      ),
      const _HomeNavOption(
        title: 'Education History',
        subtitle: 'University & Semesters',
        icon: Icons.school_rounded,
        color: Color(0xFF8B5CF6),
        route: '/education',
      ),
      const _HomeNavOption(
        title: 'Portfolio Projects',
        subtitle: 'Featured Work & Repos',
        icon: Icons.work_rounded,
        color: Color(0xFF10B981),
        route: '/projects',
      ),
      const _HomeNavOption(
        title: 'Get In Touch',
        subtitle: 'Email, Phone & Socials',
        icon: Icons.mail_rounded,
        color: Color(0xFFF59E0B),
        route: '/contact',
      ),
      const _HomeNavOption(
        title: 'Analytics & Insights',
        subtitle: 'Activity & Growth Tracking',
        icon: Icons.analytics_rounded,
        color: Color(0xFFEC4899),
        route: '/analytics',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Navigation Options',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Quick access to major application sections',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.disabledColor,
                  ),
                ),
              ],
            ),
            Icon(Icons.explore_rounded, color: theme.primaryColor),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 2 : 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: isMobile ? 1.4 : 2.2,
          ),
          itemCount: navItems.length,
          itemBuilder: (context, index) {
            final item = navItems[index];
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.go(item.route),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color ?? theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: item.color.withValues(alpha: isDark ? 0.35 : 0.2),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: item.color.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: item.color.withValues(alpha: isDark ? 0.25 : 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(item.icon, color: item.color, size: 20),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 13,
                            color: theme.disabledColor,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.subtitle,
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  ImageProvider? _getProfileImageProvider(String? imagePath, String? base64String) {
    if (base64String != null && base64String.isNotEmpty) {
      try {
        return MemoryImage(base64Decode(base64String));
      } catch (_) {}
    }
    if (imagePath != null && imagePath.isNotEmpty) {
      if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
        return NetworkImage(imagePath);
      }
      return AssetImage(imagePath);
    }
    return null;
  }
}

class _HomeNavOption {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;

  const _HomeNavOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
  });
}
