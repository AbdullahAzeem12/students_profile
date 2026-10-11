import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/interactive_3d_card.dart';
import '../services/remote_config_service.dart';

import '../controllers/profile_controller.dart';
import '../models/project.dart';
import '../utils/responsive_utils.dart';
import '../widgets/animated_button.dart';
import '../widgets/rainbow_border_container.dart';
import '../widgets/floating_rive_animation.dart';
import '../services/notification_service.dart';
import 'package:animate_do/animate_do.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = [
    'All',
    'Mobile',
    'Web',
    'Backend',
    'AI/ML',
    'General',
  ];

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
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Could not launch $url')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileController>(context);
    final theme = Theme.of(context);

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(
            ResponsiveUtils.getResponsivePadding(context),
          ),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            border: Border(bottom: BorderSide(color: theme.dividerColor)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FadeInDown(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text('Portfolio Projects', style: theme.textTheme.displayMedium),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications_active, color: theme.primaryColor),
                    tooltip: 'Subscribe to updates',
                    onPressed: () {
                      NotificationService.instance.showNewProjectNotification('Flutter E-Commerce App');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Subscribed! You will be notified of new projects.')),
                      );
                    },
                  ),
                  const FloatingRiveAnimation(
                    networkUrl: 'https://public.rive.app/community/runtime-files/2244-4437-cat-and-mouse.riv',
                    width: 80,
                    height: 80,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              FadeInDown(
                delay: const Duration(milliseconds: 200),
                child: Text(
                  'Explore my latest works, open-source contributions, and side projects.',
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 24),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorColor: theme.primaryColor,
                  labelColor: theme.primaryColor,
                  unselectedLabelColor: theme.textTheme.bodyMedium?.color,
                  padding: EdgeInsets.zero,
                  indicatorPadding: EdgeInsets.zero,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  tabs: _categories.map((c) => Tab(text: c)).toList(),
                  onTap: (index) {
                    setState(() {});
                  },
                ),
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
                  : provider.projects
                        .where((p) => p.category == category)
                        .toList();

              if (projects.isEmpty) {
                return Center(
                  child: Text(
                    'No projects found in this category.',
                    style: theme.textTheme.bodyLarge,
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(
                  ResponsiveUtils.getResponsivePadding(context),
                ),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final proj = projects[index];
                  return FadeInUp(
                    key: ValueKey('project_${proj.id}_$category'),
                    duration: const Duration(milliseconds: 500),
                    delay: Duration(milliseconds: (index * 100).clamp(0, 500)),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: RainbowBorderContainer(
                        child: _buildProjectCard(context, proj),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectCard(BuildContext context, Project project) {
    final theme = Theme.of(context);
    final remoteConfig = Provider.of<RemoteConfigService>(context);

    final cardContent = Container(
        decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          )
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            if (project.imageUrl.isNotEmpty)
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      project.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: theme.disabledColor.withValues(alpha: 0.2),
                        child: const Icon(
                          Icons.broken_image,
                          size: 48,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 80,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            theme.cardTheme.color ?? theme.cardColor,
                            (theme.cardTheme.color ?? theme.cardColor).withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            Padding(
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            project.category,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      project.shortDescription,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: project.technologies.take(3).map((tech) {
                        return Text(
                          '#$tech',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.secondary,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (project.githubUrl != null)
                          Expanded(
                            child: AnimatedBounceButton(
                              onPressed: () => _launchUrl(project.githubUrl),
                              child: OutlinedButton.icon(
                                onPressed: () => _launchUrl(project.githubUrl),
                                icon: const Icon(Icons.code, size: 18),
                                label: const Text('Source'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (project.githubUrl != null &&
                            project.projectUrl != null)
                          const SizedBox(width: 12),
                        if (project.projectUrl != null)
                          Expanded(
                            child: AnimatedBounceButton(
                              enableGlow: true,
                              onPressed: () => _launchUrl(project.projectUrl),
                              child: ElevatedButton.icon(
                                onPressed: () => _launchUrl(project.projectUrl),
                                icon: const Icon(Icons.launch, size: 18),
                                label: const Text('Live'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      );

    if (remoteConfig.enable3DEffects) {
      return Interactive3DCard(
        depth: 1.5,
        child: cardContent,
      );
    } else {
      return cardContent;
    }
  }
}
