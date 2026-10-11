import os

def write_file(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content.strip() + '\n')

def main():
    # 1. Fix lib/widgets/navigation_drawer.dart
    write_file('lib/widgets/navigation_drawer.dart', """
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

  static const List<NavigationItemData> items = [
    NavigationItemData('Home', Icons.home_rounded, 0),
    NavigationItemData('Profile', Icons.person_rounded, 1),
    NavigationItemData('Skills', Icons.code_rounded, 2),
    NavigationItemData('Projects', Icons.work_rounded, 3),
    NavigationItemData('Contact', Icons.mail_rounded, 4),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final profileProvider = Provider.of<ProfileController>(context);
    final profile = profileProvider.profile;

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
                  backgroundImage: profile != null && profile.profileImage.isNotEmpty
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: ListTile(
                    leading: Icon(
                      item.icon,
                      color: isSelected ? theme.primaryColor : theme.iconTheme.color,
                    ),
                    title: Text(
                      item.title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isSelected ? theme.primaryColor : null,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor: theme.primaryColor.withValues(alpha: 0.1),
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
                  activeColor: theme.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
""")

    # 2. Fix Profile Screen
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

    // Fallback cover image
    const String defaultCoverUrl = 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80';

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(context, defaultCoverUrl, profile.profileImage),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.getResponsivePadding(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Text(profile.fullName, style: theme.textTheme.displayMedium),
                const SizedBox(height: 8),
                Text(
                  profile.title,
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
                    Text('${profile.university} \\nSemester ${profile.semester}', style: theme.textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: 32),
                _buildActionButtons(theme),
                const SizedBox(height: 32),
                _buildBioSection(theme, profile.shortBio),
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
              backgroundImage: NetworkImage(avatarUrl.isNotEmpty ? avatarUrl : 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'),
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

    # 3. Fix Projects Screen
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
  final List<String> _categories = ['All', 'Mobile', 'Web', 'Backend', 'AI/ML', 'General'];

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
                        project.shortDescription,
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
                        if (project.githubUrl != null && project.projectUrl != null)
                          const SizedBox(width: 8),
                        if (project.projectUrl != null)
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _launchUrl(project.projectUrl),
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

    # 4. Fix Skills Screen
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
                    const Padding(
                      padding: EdgeInsets.only(right: 12.0),
                      child: Icon(Icons.code, size: 24),
                    ),
                    Text(skill.name, style: theme.textTheme.titleMedium),
                  ],
                ),
                Text('${skill.masteryPercentage.toInt()}%', style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: skill.masteryPercentage / 100.0,
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

    # 5. Fix MockData 
    write_file('lib/data/mock_data.dart', """
import '../models/contact_info.dart';
import '../models/education.dart';
import '../models/experience.dart';
import '../models/project.dart';
import '../models/skill.dart';
import '../models/student_profile.dart';

class MockData {
  static const StudentProfile mockProfile = StudentProfile(
      fullName: 'Alex Anderson',
      title: 'Senior Computer Science Student',
      introduction: 'Passionate about creating elegant solutions to complex problems.',
      university: 'State University',
      degreeProgram: 'B.S. Computer Science',
      semester: 7,
      shortBio: 'Hi! I\\'m Alex, a software engineering student specializing in mobile and web development. I love building tools that make people\\'s lives easier and participating in hackathons. When I\\'m not coding, you can find me hiking or contributing to open-source projects. Always eager to learn new technologies and collaborate with creative minds.',
      location: 'San Francisco, CA',
      profileImage: 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
      email: 'alex.anderson@example.com',
      phone: '(555) 123-4567',
      github: 'https://github.com/alexanderson',
      linkedin: 'https://linkedin.com/in/alexanderson',
      portfolio: 'https://alexanderson.dev',
      profileStatus: 'Actively looking for Summer 2024 Internships',
  );

  static final List<Education> mockEducation = [
    Education(
        institutionName: 'State University',
        degree: 'Bachelor of Science',
        fieldOfStudy: 'Computer Science',
        startDate: DateTime(2021, 8),
        endDate: DateTime(2025, 5),
        gpa: 3.8,
        description: 'Relevant Coursework: Data Structures, Algorithms, Web Development, Mobile Development.',
    ),
    Education(
        institutionName: 'Community College',
        degree: 'Associate of Science',
        fieldOfStudy: 'Computer Science',
        startDate: DateTime(2019, 8),
        endDate: DateTime(2021, 5),
        gpa: 3.9,
    ),
  ];

  static final List<Experience> mockExperience = [
    Experience(
      id: 'exp_1',
      company: 'Tech Solutions Inc.',
      position: 'Software Engineering Intern',
      startDate: DateTime(2023, 5),
      endDate: DateTime(2023, 8),
      description: 'Developed and maintained scalable web applications using React and Node.js. Improved database query performance by 20%.',
      technologiesUsed: ['React', 'Node.js', 'PostgreSQL', 'Docker'],
    ),
    Experience(
      id: 'exp_2',
      company: 'University IT Department',
      position: 'Student Web Developer',
      startDate: DateTime(2022, 1),
      endDate: DateTime(2023, 5),
      description: 'Assisted in the redesign of the university portal. Created responsive UI components using HTML, CSS, and JavaScript.',
      technologiesUsed: ['HTML', 'CSS', 'JavaScript', 'Figma'],
    ),
  ];

  static final List<Project> mockProjects = [
    Project(
      id: 'proj_1',
      title: 'Portfolio App',
      shortDescription: 'A dynamic portfolio application built with Flutter.',
      fullDescription: 'A fully responsive and dynamic portfolio application designed to showcase projects, skills, and experience. Built entirely with Flutter, utilizing Provider for state management and custom animations for a premium user experience.',
      imageUrl: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      technologies: ['Flutter', 'Dart', 'Provider'],
      githubUrl: 'https://github.com/alexanderson/portfolio',
      projectUrl: 'https://alexanderson.dev',
      category: 'Mobile',
    ),
    Project(
      id: 'proj_2',
      title: 'Task Manager API',
      shortDescription: 'A robust RESTful API for task management.',
      fullDescription: 'Developed a scalable RESTful API for a task management system. Includes user authentication, role-based access control, and complete CRUD operations for tasks and projects. Deployed on AWS.',
      imageUrl: 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      technologies: ['Node.js', 'Express', 'MongoDB', 'JWT'],
      githubUrl: 'https://github.com/alexanderson/task-api',
      category: 'Backend',
    ),
    Project(
      id: 'proj_3',
      title: 'Weather Dashboard',
      shortDescription: 'Real-time weather data visualization.',
      fullDescription: 'A responsive web application that displays real-time weather data using a public API. Features include location search, 7-day forecast, and dynamic background changing based on weather conditions.',
      imageUrl: 'https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      technologies: ['React', 'Redux', 'CSS Modules'],
      githubUrl: 'https://github.com/alexanderson/weather-app',
      projectUrl: 'https://weather.alexanderson.dev',
      category: 'Web',
    ),
  ];

  static final List<Skill> mockSkills = [
    Skill(id: 'sk_1', name: 'Flutter', masteryPercentage: 85.0, category: 'Mobile'),
    Skill(id: 'sk_2', name: 'Dart', masteryPercentage: 80.0, category: 'Mobile'),
    Skill(id: 'sk_3', name: 'JavaScript', masteryPercentage: 90.0, category: 'Web'),
    Skill(id: 'sk_4', name: 'React', masteryPercentage: 85.0, category: 'Web'),
    Skill(id: 'sk_5', name: 'Node.js', masteryPercentage: 75.0, category: 'Backend'),
    Skill(id: 'sk_6', name: 'Python', masteryPercentage: 70.0, category: 'General'),
    Skill(id: 'sk_7', name: 'Git', masteryPercentage: 85.0, category: 'Tools'),
    Skill(id: 'sk_8', name: 'Figma', masteryPercentage: 65.0, category: 'Design'),
  ];

  static const ContactInfo mockContactInfo = ContactInfo(
      email: 'alex.anderson@example.com',
      phone: '(555) 123-4567',
      address: '123 University Ave, Tech City, ST 12345',
      linkedInUrl: 'https://linkedin.com/in/alexanderson',
      githubUrl: 'https://github.com/alexanderson',
  );
}
""")

if __name__ == '__main__':
    main()
    print("Upgrade Part 6 complete.")
