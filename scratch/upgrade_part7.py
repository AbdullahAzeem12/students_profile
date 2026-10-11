import os

def write_file(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content.strip() + '\n')

def main():
    # Fix lib/controllers/profile_controller.dart
    write_file('lib/controllers/profile_controller.dart', """
import 'package:flutter/foundation.dart';
import '../models/student_profile.dart';
import '../models/skill.dart';
import '../models/education.dart';
import '../models/project.dart';
import '../models/contact_info.dart';
import '../data/mock_data.dart';

class ProfileController extends ChangeNotifier {
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

  int get totalProjects => _projects.length;
  double get averageSkillMastery {
    if (_skills.isEmpty) return 0;
    return _skills.map((s) => s.masteryPercentage).reduce((a, b) => a + b) / _skills.length;
  }

  Future<void> loadAllData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _profile = MockData.mockProfile;
      _skills = MockData.mockSkills;
      _education = MockData.mockEducation;
      _projects = MockData.mockProjects;
      _contactInfo = MockData.mockContactInfo;
    } catch (e) {
      _errorMessage = 'Failed to load data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
""")

    # Fix lib/widgets/bottom_navigation.dart
    write_file('lib/widgets/bottom_navigation.dart', """
import 'package:flutter/material.dart';

class AnimatedBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AnimatedBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, Icons.home_rounded, 'Home', 0),
              _buildNavItem(context, Icons.person_rounded, 'Profile', 1),
              _buildNavItem(context, Icons.code_rounded, 'Skills', 2),
              _buildNavItem(context, Icons.work_rounded, 'Projects', 3),
              _buildNavItem(context, Icons.mail_rounded, 'Contact', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index) {
    final theme = Theme.of(context);
    final isSelected = currentIndex == index;
    
    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryColor.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? theme.primaryColor : theme.iconTheme.color,
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  label,
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
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

    # Fix lib/models/education.dart
    write_file('lib/models/education.dart', """
import 'package:flutter/foundation.dart';

@immutable
class Education {
  final String institutionName;
  final String degree;
  final String fieldOfStudy;
  final DateTime startDate;
  final DateTime? endDate;
  final double? gpa;
  final String? description;

  const Education({
    required this.institutionName,
    required this.degree,
    required this.fieldOfStudy,
    required this.startDate,
    this.endDate,
    this.gpa,
    this.description,
  });
}
""")

    # Fix lib/models/contact_info.dart
    write_file('lib/models/contact_info.dart', """
import 'package:flutter/foundation.dart';

@immutable
class ContactInfo {
  final String email;
  final String phone;
  final String address;
  final String? linkedInUrl;
  final String? githubUrl;
  final String? portfolioUrl;

  const ContactInfo({
    required this.email,
    required this.phone,
    required this.address,
    this.linkedInUrl,
    this.githubUrl,
    this.portfolioUrl,
  });
}
""")

if __name__ == '__main__':
    main()
    print("Upgrade Part 7 complete.")
