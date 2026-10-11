import os

def write_file(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)

# Profile Screen
profile_screen = """/// Profile Screen
///
/// Displays detailed academic and personal information.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/profile_controller.dart';
import '../utils/responsive_utils.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileController>(context).profile;
    final theme = Theme.of(context);
    
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: ResponsiveUtils.getMaxWidth(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildInfoCard(
                  context,
                  title: 'Personal Info',
                  icon: Icons.person_outline,
                  children: [
                    _buildDataRow(context, 'Full Name', profile.fullName),
                    _buildDataRow(context, 'Title', profile.title),
                    _buildDataRow(context, 'Location', profile.location),
                  ],
                ),
                const SizedBox(height: 24),
                _buildInfoCard(
                  context,
                  title: 'Academic Info',
                  icon: Icons.school_outlined,
                  children: [
                    _buildDataRow(context, 'University', profile.university),
                    _buildDataRow(context, 'Degree', profile.degreeProgram),
                    _buildDataRow(context, 'Semester', profile.semester.toString()),
                  ],
                ),
                const SizedBox(height: 24),
                _buildInfoCard(
                  context,
                  title: 'Biography',
                  icon: Icons.article_outlined,
                  children: [
                    Text(
                      profile.shortBio,
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required String title, required IconData icon, required List<Widget> children}) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: theme.colorScheme.primary),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ResponsiveUtils.isCompactMobile(context)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    value,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
    );
  }
}
"""

# Skills Screen
skills_screen = """/// Skills Screen
///
/// Displays skills in categories with beautiful cards and indicators.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/profile_controller.dart';
import '../models/skill.dart';
import '../utils/responsive_utils.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final skills = Provider.of<ProfileController>(context).skills;
    
    // Group skills by category
    final Map<SkillCategory, List<Skill>> groupedSkills = {};
    for (var skill in skills) {
      if (!groupedSkills.containsKey(skill.category)) {
        groupedSkills[skill.category] = [];
      }
      groupedSkills[skill.category]!.add(skill);
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: ResponsiveUtils.getMaxWidth(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: groupedSkills.entries.map((entry) {
                return _buildCategorySection(context, entry.key, entry.value);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, SkillCategory category, List<Skill> skills) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getCategoryName(category),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: skills.map((skill) => _buildSkillCard(context, skill)).toList(),
          ),
        ],
      ),
    );
  }

  String _getCategoryName(SkillCategory category) {
    switch (category) {
      case SkillCategory.mobileDevelopment: return 'Mobile Development';
      case SkillCategory.programming: return 'Programming Languages';
      case SkillCategory.tools: return 'Tools & Frameworks';
      case SkillCategory.versionControl: return 'Version Control';
      case SkillCategory.design: return 'Design';
      case SkillCategory.other: return 'Other';
    }
  }

  Widget _buildSkillCard(BuildContext context, Skill skill) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final baseColor = skill.color;
    
    // Width calculation for Wrap
    double width = MediaQuery.of(context).size.width - 32; // Full width minus padding
    if (ResponsiveUtils.isTablet(context)) {
      width = (width - 16) / 2; // 2 columns
    } else if (ResponsiveUtils.isDesktop(context)) {
      width = (ResponsiveUtils.getMaxWidth(context) - 32) / 3; // 3 columns
    }

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: baseColor.withOpacity(isDark ? 0.3 : 0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {}, // Hover and ripple effect trigger
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: baseColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.code, color: baseColor), // Using generic icon
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        skill.name,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  skill.description,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: skill.proficiency,
                    backgroundColor: baseColor.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(baseColor),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
"""

# Education Screen
education_screen = """/// Education Screen
///
/// Timeline style academic history.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/profile_controller.dart';
import '../models/education.dart';
import '../utils/responsive_utils.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final educationTimeline = Provider.of<ProfileController>(context).educationTimeline;
    
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: educationTimeline.length,
        itemBuilder: (context, index) {
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: ResponsiveUtils.getMaxWidth(context)),
              child: _buildTimelineItem(context, educationTimeline[index], index == educationTimeline.length - 1),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, Education education, bool isLast) {
    final theme = Theme.of(context);
    
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline graphics
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(top: 24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.colorScheme.surface, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.4),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: theme.colorScheme.primary.withOpacity(0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Content card
          Expanded(
            child: Card(
              margin: const EdgeInsets.only(bottom: 24),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        education.timelineString,
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      education.degree,
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      education.institute,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      education.description,
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
"""

# Projects Screen
projects_screen = """/// Projects Screen
///
/// Responsive grid of projects with GitHub links.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/profile_controller.dart';
import '../models/project.dart';
import '../utils/responsive_utils.dart';
import '../services/link_launcher_service.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projects = Provider.of<ProfileController>(context).projects;
    
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: ResponsiveUtils.getMaxWidth(context) + 200), // Wider for projects
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: projects.map((p) => _buildProjectCard(context, p)).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, Project project) {
    final theme = Theme.of(context);
    
    double width = MediaQuery.of(context).size.width - 32;
    if (ResponsiveUtils.isTablet(context)) {
      width = (width - 16) / 2;
    } else if (ResponsiveUtils.isDesktop(context)) {
      width = (ResponsiveUtils.getMaxWidth(context) + 200 - 64) / 3;
    }

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Image Placeholder
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Icon(Icons.image_outlined, size: 48, color: theme.colorScheme.primary.withOpacity(0.5)),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.name,
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  project.description,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: project.technologies.map((tech) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.colorScheme.secondary.withOpacity(0.3)),
                      ),
                      child: Text(
                        tech,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: project.hasGithubLink() 
                        ? () => LinkLauncherService.launchWebUrl(project.githubUrl)
                        : null,
                    icon: const Icon(Icons.code),
                    label: const Text('View on GitHub'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
"""

# Contact Screen
contact_screen = """/// Contact Screen
///
/// Provides interactive links for communication.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/profile_controller.dart';
import '../utils/responsive_utils.dart';
import '../services/link_launcher_service.dart';
import '../widgets/animated_button.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contact = Provider.of<ProfileController>(context).contactInfo;
    
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: ResponsiveUtils.getMaxWidth(context) * 0.8),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Icon(Icons.connect_without_contact, size: 80, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 24),
                Text(
                  'Let\\'s Connect',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Feel free to reach out for collaborations or just a friendly hello!',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                _buildContactCard(
                  context, 
                  icon: Icons.email_rounded, 
                  title: 'Email', 
                  subtitle: contact.email, 
                  color: Colors.red,
                  onTap: () => LinkLauncherService.launchEmail(contact.email),
                ),
                const SizedBox(height: 16),
                _buildContactCard(
                  context, 
                  icon: Icons.phone_rounded, 
                  title: 'Phone', 
                  subtitle: contact.phone, 
                  color: Colors.green,
                  onTap: () => LinkLauncherService.launchPhone(contact.phone),
                ),
                const SizedBox(height: 16),
                _buildContactCard(
                  context, 
                  icon: Icons.link_rounded, 
                  title: 'LinkedIn', 
                  subtitle: 'Connect professionally', 
                  color: Colors.blue,
                  onTap: () => LinkLauncherService.launchWebUrl(contact.linkedin),
                ),
                const SizedBox(height: 16),
                _buildContactCard(
                  context, 
                  icon: Icons.code_rounded, 
                  title: 'GitHub', 
                  subtitle: 'View my repositories', 
                  color: Colors.grey.shade700,
                  onTap: () => LinkLauncherService.launchWebUrl(contact.github),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, {
    required IconData icon, 
    required String title, 
    required String subtitle, 
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return AnimatedBounceButton(
      color: theme.colorScheme.surface,
      onPressed: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withOpacity(0.3)),
        ],
      ),
    );
  }
}
"""

write_file('lib/screens/profile_screen.dart', profile_screen)
write_file('lib/screens/skills_screen.dart', skills_screen)
write_file('lib/screens/education_screen.dart', education_screen)
write_file('lib/screens/projects_screen.dart', projects_screen)
write_file('lib/screens/contact_screen.dart', contact_screen)

print("Part 5 generated")
