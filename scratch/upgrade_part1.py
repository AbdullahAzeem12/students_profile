import os

def write_file(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content.strip() + '\n')

def main():
    # 1. Color Palette & Spacing
    write_file('lib/theme/color_palette.dart', """
import 'package:flutter/material.dart';

/// Centralized professional color palette and spacing system.
class AppColors {
  // Light Mode
  static const Color lightBackground = Color(0xFFF8FAFC); // Softer, more modern slate
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightPrimary = Color(0xFF2563EB); // Royal Blue
  static const Color lightSecondary = Color(0xFF0EA5E9); // Sky Blue
  static const Color lightAccent = Color(0xFF8B5CF6); // Violet accent
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Dark Mode
  static const Color darkBackground = Color(0xFF0B1120); // Deep slate
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkPrimary = Color(0xFF3B82F6);
  static const Color darkSecondary = Color(0xFF38BDF8);
  static const Color darkAccent = Color(0xFFA78BFA);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF334155);

  static const Color darkError = Color(0xFFEF4444);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
}

/// Centralized spacing system for uniform margins and padding.
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  
  static EdgeInsets get paddingAllSm => const EdgeInsets.all(sm);
  static EdgeInsets get paddingAllMd => const EdgeInsets.all(md);
  static EdgeInsets get paddingAllLg => const EdgeInsets.all(lg);
  
  static EdgeInsets get paddingScreen => const EdgeInsets.symmetric(horizontal: lg, vertical: md);
}
""")

    # 2. App Theme
    write_file('lib/app/app_theme.dart', """
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
        titleLarge: TextStyle(color: AppColors.lightTextPrimary, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: AppColors.lightTextPrimary),
        bodyMedium: TextStyle(color: AppColors.lightTextSecondary),
        labelLarge: TextStyle(color: AppColors.lightPrimary, fontWeight: FontWeight.w600),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
        titleTextStyle: TextStyle(color: AppColors.lightTextPrimary, fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'SpaceGrotesk'),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.lightBorder, thickness: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightPrimary, width: 2),
        ),
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
        titleLarge: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: AppColors.darkTextPrimary),
        bodyMedium: TextStyle(color: AppColors.darkTextSecondary),
        labelLarge: TextStyle(color: AppColors.darkPrimary, fontWeight: FontWeight.w600),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
        titleTextStyle: TextStyle(color: AppColors.darkTextPrimary, fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'SpaceGrotesk'),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.darkBorder, thickness: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkPrimary, width: 2),
        ),
      ),
    );
  }
}
""")

    # 3. Responsive & UI Utils
    write_file('lib/utils/responsive_utils.dart', """
import 'package:flutter/material.dart';
import 'dart:ui';

/// Advanced utilities for responsiveness and visual effects.
class ResponsiveUtils {
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 600;
  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 1200;
  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1200;

  static int getGridCrossAxisCount(BuildContext context) {
    if (isDesktop(context)) return 4;
    if (isTablet(context)) return 2;
    return 1;
  }

  static double getResponsivePadding(BuildContext context) {
    if (isDesktop(context)) return 48.0;
    if (isTablet(context)) return 32.0;
    return 16.0;
  }
}

/// Glassmorphism utility wrapper for modern premium UI elements
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Color color;
  final double blur;
  final Border? border;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 16.0,
    this.color = Colors.white10,
    this.blur = 10.0,
    this.border,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ?? Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: color,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
""")

    # 4. Models update (Skill, Project)
    write_file('lib/models/skill.dart', """
class Skill {
  final String id;
  final String name;
  final double masteryPercentage;
  final String category; // Added category for filtering

  Skill({
    required this.id,
    required this.name,
    required this.masteryPercentage,
    required this.category,
  }) {
    if (masteryPercentage < 0 || masteryPercentage > 100) {
      throw ArgumentError('Mastery percentage must be between 0 and 100');
    }
    if (name.isEmpty) {
      throw ArgumentError('Skill name cannot be empty');
    }
  }
}
""")
    write_file('lib/models/project.dart', """
class Project {
  final String id;
  final String title;
  final String shortDescription;
  final String fullDescription; // Added full description
  final String imageUrl;
  final List<String> technologies;
  final String? projectUrl;
  final String? githubUrl;
  final String category; // Added category

  Project({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.fullDescription,
    required this.imageUrl,
    required this.technologies,
    this.projectUrl,
    this.githubUrl,
    this.category = 'General',
  }) {
    if (title.isEmpty) throw ArgumentError('Project title is required');
  }
}
""")
    # 5. Data update
    write_file('lib/data/mock_data.dart', """
import '../models/student_profile.dart';
import '../models/skill.dart';
import '../models/education.dart';
import '../models/project.dart';
import '../models/contact_info.dart';

class MockData {
  static StudentProfile getProfile() {
    return StudentProfile(
      id: 'usr_001',
      fullName: 'Alex Johnson',
      headline: 'Senior Computer Science Student | UI/UX Enthusiast | Flutter Developer',
      bio: 'I am a passionate software engineering student specializing in cross-platform mobile development and cloud architecture. With a strong foundation in modern design principles and robust backend systems, I strive to create applications that are not only highly functional but also a joy to use. I am constantly learning new technologies and currently exploring AI integrations in mobile apps.',
      profileImageUrl: 'https://i.pravatar.cc/300?img=11',
      coverImageUrl: 'https://images.unsplash.com/photo-1550439062-609e1531270e?q=80&w=2070&auto=format&fit=crop',
      university: 'Tech Global University',
      graduationYear: 2025,
      location: 'San Francisco, CA',
    );
  }

  static List<Skill> getSkills() {
    return [
      Skill(id: 'sk_1', name: 'Flutter', masteryPercentage: 90, category: 'Mobile Dev'),
      Skill(id: 'sk_2', name: 'Dart', masteryPercentage: 85, category: 'Languages'),
      Skill(id: 'sk_3', name: 'Firebase', masteryPercentage: 80, category: 'Backend'),
      Skill(id: 'sk_4', name: 'UI/UX Design', masteryPercentage: 75, category: 'Design'),
      Skill(id: 'sk_5', name: 'Python', masteryPercentage: 70, category: 'Languages'),
      Skill(id: 'sk_6', name: 'Git & GitHub', masteryPercentage: 85, category: 'Tools'),
      Skill(id: 'sk_7', name: 'React Native', masteryPercentage: 60, category: 'Mobile Dev'),
      Skill(id: 'sk_8', name: 'Public Speaking', masteryPercentage: 85, category: 'Soft Skills'),
    ];
  }

  static List<Education> getEducation() {
    return [
      Education(
        id: 'ed_1',
        degree: 'B.S. in Computer Science',
        institution: 'Tech Global University',
        startDate: DateTime(2021, 9, 1),
        endDate: DateTime(2025, 5, 30),
        description: 'Focus on Software Engineering, Mobile Computing, and Human-Computer Interaction. GPA: 3.9/4.0.',
        achievements: ['Dean\\'s List 2021-2023', 'President of Mobile Dev Club', 'Hackathon 2022 Winner'],
      ),
      Education(
        id: 'ed_2',
        degree: 'High School Diploma',
        institution: 'Innovation High',
        startDate: DateTime(2017, 9, 1),
        endDate: DateTime(2021, 5, 30),
        description: 'Graduated with honors. Lead programmer for the Robotics Team.',
        achievements: ['National Merit Scholar', 'Robotics State Champions'],
      ),
    ];
  }

  static List<Project> getProjects() {
    return [
      Project(
        id: 'pj_1',
        title: 'Aurora Task Manager',
        shortDescription: 'A cross-platform task management application with cloud sync.',
        fullDescription: 'Aurora Task Manager is a full-featured productivity app built with Flutter and Firebase. It features real-time cloud synchronization, push notifications, offline support, and a highly customizable UI with both Light and Dark modes. Users can categorize tasks, set priorities, and track their productivity over time with interactive charts.',
        imageUrl: 'https://images.unsplash.com/photo-1611162617474-5b21e879e113?q=80&w=1000&auto=format&fit=crop',
        technologies: ['Flutter', 'Firebase', 'Provider'],
        githubUrl: 'https://github.com/example/aurora_tasks',
        projectUrl: 'https://example.com/aurora',
        category: 'Mobile App',
      ),
      Project(
        id: 'pj_2',
        title: 'WeatherSense IoT',
        shortDescription: 'Smart home weather dashboard connecting to IoT sensors.',
        fullDescription: 'WeatherSense is an IoT project that collects real-time environmental data (temperature, humidity, air quality) from custom-built ESP32 sensors. The Flutter frontend displays this data using dynamic, animated charts and provides predictive insights based on local weather APIs.',
        imageUrl: 'https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?q=80&w=1000&auto=format&fit=crop',
        technologies: ['Flutter', 'Dart', 'REST API', 'IoT'],
        githubUrl: 'https://github.com/example/weathersense',
        category: 'IoT / Hardware',
      ),
      Project(
        id: 'pj_3',
        title: 'E-Commerce UI Kit',
        shortDescription: 'A premium, open-source UI kit for Flutter developers.',
        fullDescription: 'Designed and open-sourced a comprehensive E-Commerce UI kit for the Flutter community. It includes 40+ screens, 100+ reusable components, and deep support for theming. It focuses on micro-interactions, accessibility, and high performance.',
        imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=1000&auto=format&fit=crop',
        technologies: ['Flutter', 'UI/UX', 'Animation'],
        githubUrl: 'https://github.com/example/ecommerce_ui',
        category: 'UI/UX',
      ),
    ];
  }

  static ContactInfo getContactInfo() {
    return ContactInfo(
      id: 'ci_1',
      email: 'alex.johnson@example.com',
      linkedInUrl: 'https://linkedin.com/in/alexjohnson',
      githubUrl: 'https://github.com/alexjohnson',
      phoneNumber: '+1 (555) 123-4567',
      websiteUrl: 'https://alexjohnson.dev',
    );
  }
}
""")

if __name__ == '__main__':
    main()
    print("Upgrade Part 1 complete.")
