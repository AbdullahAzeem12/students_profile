import os

def write_file(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)

# Data
profile_data = """/// Profile Data Repository
///
/// Simulates a data source for the student profile.
import '../models/student_profile.dart';

class ProfileData {
  static const StudentProfile studentProfile = StudentProfile(
    fullName: 'Jane Doe',
    title: 'Mobile App Developer Intern',
    introduction: 'Passionate about building responsive, beautiful mobile apps.',
    university: 'Devixo University of Technology',
    degreeProgram: 'B.Sc. Software Engineering',
    semester: 6,
    shortBio: 'I am a dedicated software engineering student with a strong focus on Flutter and mobile development. My goal is to build scalable, beautiful applications that deliver an exceptional user experience. During my academic journey, I have explored various technologies and methodologies, ranging from native Android development to cross-platform solutions like Flutter. I thrive in challenging environments and constantly seek to improve my coding skills and architectural knowledge.',
    location: 'San Francisco, CA',
    profileImage: 'assets/images/profile.png',
    email: 'jane.doe@example.com',
    phone: '+1 234 567 8900',
    github: 'https://github.com/janedoe',
    linkedin: 'https://linkedin.com/in/janedoe',
    portfolio: 'https://janedoe.dev',
    profileStatus: 'Actively learning and building.',
  );
}
"""

skills_data = """/// Skills Data Repository
///
/// Contains predefined skills for the student.
import '../models/skill.dart';

class SkillsData {
  static const List<Skill> skills = [
    Skill(
      name: 'Flutter',
      category: SkillCategory.mobileDevelopment,
      icon: 'flutter',
      colorMetadata: '#02569B',
      proficiency: 0.85,
      description: 'Extensive experience building cross-platform applications with rich UIs and animations.',
    ),
    Skill(
      name: 'Dart',
      category: SkillCategory.programming,
      icon: 'dart',
      colorMetadata: '#0175C2',
      proficiency: 0.90,
      description: 'Deep understanding of Dart language, asynchronous programming, and object-oriented design.',
    ),
    Skill(
      name: 'Python',
      category: SkillCategory.programming,
      icon: 'python',
      colorMetadata: '#3776AB',
      proficiency: 0.75,
      description: 'Used for scripting, automation, and backend development with frameworks like Django/Flask.',
    ),
    Skill(
      name: 'C++',
      category: SkillCategory.programming,
      icon: 'cplusplus',
      colorMetadata: '#00599C',
      proficiency: 0.70,
      description: 'Strong foundation in memory management, data structures, and algorithms.',
    ),
    Skill(
      name: 'Java',
      category: SkillCategory.programming,
      icon: 'java',
      colorMetadata: '#007396',
      proficiency: 0.80,
      description: 'Experience in native Android development and enterprise application patterns.',
    ),
    Skill(
      name: 'Git/GitHub',
      category: SkillCategory.versionControl,
      icon: 'git',
      colorMetadata: '#F05032',
      proficiency: 0.88,
      description: 'Proficient in branching, merging, rebasing, and collaborating in team environments.',
    ),
    Skill(
      name: 'Firebase',
      category: SkillCategory.tools,
      icon: 'firebase',
      colorMetadata: '#FFCA28',
      proficiency: 0.82,
      description: 'Integration of Auth, Firestore, Cloud Functions, and Analytics in mobile projects.',
    ),
  ];
}
"""

education_data = """/// Education Data Repository
///
/// Contains predefined educational history.
import '../models/education.dart';

class EducationData {
  static const List<Education> timeline = [
    Education(
      degree: 'B.Sc. in Software Engineering',
      institute: 'Devixo University of Technology',
      startYear: 2021,
      expectedGraduationYear: 2025,
      currentSemester: 6,
      description: 'Focusing on software architecture, mobile development, and UI/UX design. Consistently maintained a high GPA while participating in coding bootcamps.',
    ),
    Education(
      degree: 'High School Diploma (Computer Science)',
      institute: 'Tech Valley High',
      startYear: 2017,
      expectedGraduationYear: 2021,
      currentSemester: 8,
      description: 'Graduated with honors. Developed a passion for programming during advanced placement computer science courses.',
    ),
  ];
}
"""

projects_data = """/// Projects Data Repository
///
/// Contains predefined projects.
import '../models/project.dart';

class ProjectsData {
  static const List<Project> projects = [
    Project(
      name: 'Student Portfolio App',
      description: 'A comprehensive, responsive mobile application built with Flutter to showcase academic and professional achievements.',
      technologies: ['Flutter', 'Dart', 'Provider'],
      imageAsset: 'assets/images/project1.png',
      icon: 'portfolio',
      githubUrl: 'https://github.com/janedoe/student-portfolio',
    ),
    Project(
      name: 'Weather Tracker Pro',
      description: 'A beautifully designed weather forecasting app that integrates with public REST APIs to provide real-time updates and notifications.',
      technologies: ['Flutter', 'Dart', 'REST API', 'JSON'],
      imageAsset: 'assets/images/project2.png',
      icon: 'cloud',
      githubUrl: 'https://github.com/janedoe/weather-tracker',
    ),
    Project(
      name: 'E-Commerce UI Kit',
      description: 'A modern, accessible, and responsive UI kit for building e-commerce applications in Flutter. Focuses on animations and glassmorphism.',
      technologies: ['Flutter', 'Figma', 'UI/UX'],
      imageAsset: 'assets/images/project3.png',
      icon: 'shopping_cart',
      githubUrl: 'https://github.com/janedoe/ecommerce-ui',
    ),
  ];
}
"""

contact_data = """/// Contact Data Repository
///
/// Contains contact info.
import '../models/contact_info.dart';

class ContactData {
  static const ContactInfo contactInfo = ContactInfo(
    email: 'jane.doe@example.com',
    phone: '+1 234 567 8900',
    location: 'San Francisco, CA',
    github: 'https://github.com/janedoe',
    linkedin: 'https://linkedin.com/in/janedoe',
    portfolio: 'https://janedoe.dev',
  );
}
"""

# Controllers
profile_controller = """/// Profile Controller
///
/// Manages the state for the student profile, skills, education, and projects.
/// Serves as the central data provider for the application UI.
import 'package:flutter/material.dart';
import '../models/student_profile.dart';
import '../models/skill.dart';
import '../models/education.dart';
import '../models/project.dart';
import '../models/contact_info.dart';

import '../data/profile_data.dart';
import '../data/skills_data.dart';
import '../data/education_data.dart';
import '../data/projects_data.dart';
import '../data/contact_data.dart';

class ProfileController extends ChangeNotifier {
  StudentProfile _profile = ProfileData.studentProfile;
  List<Skill> _skills = SkillsData.skills;
  List<Education> _educationTimeline = EducationData.timeline;
  List<Project> _projects = ProjectsData.projects;
  ContactInfo _contactInfo = ContactData.contactInfo;

  bool _isLoading = false;
  String? _error;

  /// Getters
  StudentProfile get profile => _profile;
  List<Skill> get skills => _skills;
  List<Education> get educationTimeline => _educationTimeline;
  List<Project> get projects => _projects;
  ContactInfo get contactInfo => _contactInfo;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Refreshes data. In a real app, this would hit an API.
  Future<void> reloadData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 800)); // Simulate network
      // Just re-assigning mock data for demonstration
      _profile = ProfileData.studentProfile;
      _skills = SkillsData.skills;
      _educationTimeline = EducationData.timeline;
      _projects = ProjectsData.projects;
      _contactInfo = ContactData.contactInfo;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
"""

theme_controller = """/// Theme Controller
///
/// Manages the theme mode (light vs dark) across the application.
import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      // Cannot reliably determine system theme without context here,
      // assuming light as fallback. 
      return false; // Will be properly resolved in the UI
    }
    return _themeMode == ThemeMode.dark;
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
    } else if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.dark;
    }
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }
}
"""

# Services
link_launcher_service = """/// Link Launcher Service
///
/// Provides robust, error-handled methods to open external links, emails, and phone calls.
import 'package:url_launcher/url_launcher.dart';

class LinkLauncherService {
  /// Opens a generic URL in the external browser.
  static Future<bool> launchWebUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Opens the default email client.
  static Future<bool> launchEmail(String email) async {
    try {
      final uri = Uri(
        scheme: 'mailto',
        path: email,
      );
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Opens the device dialer.
  static Future<bool> launchPhone(String phone) async {
    try {
      final uri = Uri(
        scheme: 'tel',
        path: phone,
      );
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
"""

# Theme
color_palette = """/// Color Palette
///
/// Defines the central color tokens for Aurora Student Theme.
import 'package:flutter/material.dart';

class AppColors {
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF070B17);
  static const Color darkSurface = Color(0xFF101729);
  static const Color darkElevatedSurface = Color(0xFF151E34);
  static const Color darkPrimary = Color(0xFF6C63FF);
  static const Color darkSecondary = Color(0xFF28D7FF);
  static const Color darkAccent = Color(0xFFB56CFF);
  static const Color darkSuccess = Color(0xFF39D98A);
  static const Color darkWarning = Color(0xFFFFB84D);
  static const Color darkError = Color(0xFFFF5C7A);
  static const Color darkTextPrimary = Color(0xFFF7F9FF);
  static const Color darkTextSecondary = Color(0xFFA9B2C7);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF6F8FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightElevatedSurface = Color(0xFFEEF2FF);
  static const Color lightPrimary = Color(0xFF5B50E6);
  static const Color lightSecondary = Color(0xFF009ED8);
  static const Color lightAccent = Color(0xFF9347D8);
  static const Color lightTextPrimary = Color(0xFF12182A);
  static const Color lightTextSecondary = Color(0xFF5E687C);
}
"""

app_theme = """/// App Theme configuration
import 'package:flutter/material.dart';
import '../theme/color_palette.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.lightPrimary,
      scaffoldBackgroundColor: AppColors.lightBackground,
      fontFamily: 'SpaceGrotesk',
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        secondary: AppColors.lightSecondary,
        surface: AppColors.lightSurface,
        error: AppColors.darkError,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.lightTextPrimary,
        onError: Colors.white,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.lightTextPrimary, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: AppColors.lightTextPrimary, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: AppColors.lightTextPrimary),
        bodyMedium: TextStyle(color: AppColors.lightTextSecondary),
      ),
      cardTheme: CardTheme(
        color: AppColors.lightSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
        titleTextStyle: TextStyle(color: AppColors.lightTextPrimary, fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'SpaceGrotesk'),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.darkPrimary,
      scaffoldBackgroundColor: AppColors.darkBackground,
      fontFamily: 'SpaceGrotesk',
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        secondary: AppColors.darkSecondary,
        surface: AppColors.darkSurface,
        error: AppColors.darkError,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: AppColors.darkTextPrimary,
        onError: Colors.white,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: AppColors.darkTextPrimary),
        bodyMedium: TextStyle(color: AppColors.darkTextSecondary),
      ),
      cardTheme: CardTheme(
        color: AppColors.darkSurface,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
        titleTextStyle: TextStyle(color: AppColors.darkTextPrimary, fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'SpaceGrotesk'),
      ),
    );
  }
}
"""

write_file('lib/data/profile_data.dart', profile_data)
write_file('lib/data/skills_data.dart', skills_data)
write_file('lib/data/education_data.dart', education_data)
write_file('lib/data/projects_data.dart', projects_data)
write_file('lib/data/contact_data.dart', contact_data)

write_file('lib/controllers/profile_controller.dart', profile_controller)
write_file('lib/controllers/theme_controller.dart', theme_controller)

write_file('lib/services/link_launcher_service.dart', link_launcher_service)

write_file('lib/theme/color_palette.dart', color_palette)
write_file('lib/app/app_theme.dart', app_theme)

print("Part 2 generated")
