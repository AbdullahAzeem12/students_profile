import os

def write_file(path, content):
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)

# Models
student_profile_model = """/// Student Profile Model
///
/// This class represents the complete student identity. It includes personal details,
/// academic information, and social connections.
/// This model forms the core of the portfolio application.
import 'package:flutter/foundation.dart';

@immutable
class StudentProfile {
  /// The full name of the student.
  final String fullName;
  
  /// A professional or academic title, e.g., 'Computer Science Student'.
  final String title;
  
  /// A short introduction displayed on the home screen.
  final String introduction;
  
  /// The name of the university or institute the student is attending.
  final String university;
  
  /// The specific degree program, e.g., 'B.Sc. in Software Engineering'.
  final String degreeProgram;
  
  /// The current semester of study.
  final int semester;
  
  /// A detailed biographical text for the profile screen.
  final String shortBio;
  
  /// The student's current location, e.g., 'New York, USA'.
  final String location;
  
  /// An asset path or URL for the student's profile image.
  final String profileImage;
  
  /// The student's primary email address for contact.
  final String email;
  
  /// The student's phone number.
  final String phone;
  
  /// A link to the student's GitHub profile.
  final String github;
  
  /// A link to the student's LinkedIn profile.
  final String linkedin;
  
  /// A link to the student's personal portfolio website.
  final String portfolio;
  
  /// A status message for the profile.
  final String profileStatus;

  /// Primary constructor for [StudentProfile].
  /// Requires all properties to be explicitly defined.
  const StudentProfile({
    required this.fullName,
    required this.title,
    required this.introduction,
    required this.university,
    required this.degreeProgram,
    required this.semester,
    required this.shortBio,
    required this.location,
    required this.profileImage,
    required this.email,
    required this.phone,
    required this.github,
    required this.linkedin,
    required this.portfolio,
    required this.profileStatus,
  });

  /// Creates a copy of this [StudentProfile] but with the given fields replaced with the new values.
  StudentProfile copyWith({
    String? fullName,
    String? title,
    String? introduction,
    String? university,
    String? degreeProgram,
    int? semester,
    String? shortBio,
    String? location,
    String? profileImage,
    String? email,
    String? phone,
    String? github,
    String? linkedin,
    String? portfolio,
    String? profileStatus,
  }) {
    return StudentProfile(
      fullName: fullName ?? this.fullName,
      title: title ?? this.title,
      introduction: introduction ?? this.introduction,
      university: university ?? this.university,
      degreeProgram: degreeProgram ?? this.degreeProgram,
      semester: semester ?? this.semester,
      shortBio: shortBio ?? this.shortBio,
      location: location ?? this.location,
      profileImage: profileImage ?? this.profileImage,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      github: github ?? this.github,
      linkedin: linkedin ?? this.linkedin,
      portfolio: portfolio ?? this.portfolio,
      profileStatus: profileStatus ?? this.profileStatus,
    );
  }

  /// Converts the [StudentProfile] instance into a `Map<String, dynamic>`.
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'title': title,
      'introduction': introduction,
      'university': university,
      'degreeProgram': degreeProgram,
      'semester': semester,
      'shortBio': shortBio,
      'location': location,
      'profileImage': profileImage,
      'email': email,
      'phone': phone,
      'github': github,
      'linkedin': linkedin,
      'portfolio': portfolio,
      'profileStatus': profileStatus,
    };
  }

  /// Creates a [StudentProfile] instance from a `Map<String, dynamic>`.
  factory StudentProfile.fromMap(Map<String, dynamic> map) {
    return StudentProfile(
      fullName: map['fullName'] ?? '',
      title: map['title'] ?? '',
      introduction: map['introduction'] ?? '',
      university: map['university'] ?? '',
      degreeProgram: map['degreeProgram'] ?? '',
      semester: map['semester']?.toInt() ?? 1,
      shortBio: map['shortBio'] ?? '',
      location: map['location'] ?? '',
      profileImage: map['profileImage'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      github: map['github'] ?? '',
      linkedin: map['linkedin'] ?? '',
      portfolio: map['portfolio'] ?? '',
      profileStatus: map['profileStatus'] ?? '',
    );
  }

  /// Validates the profile data.
  /// Returns a list of error messages if any validation fails.
  /// Returns an empty list if validation is successful.
  List<String> validate() {
    final errors = <String>[];
    if (fullName.isEmpty) errors.add('Full name cannot be empty.');
    if (email.isEmpty || !email.contains('@')) errors.add('Invalid email address.');
    if (semester < 1 || semester > 12) errors.add('Invalid semester value.');
    return errors;
  }

  /// Checks if the academic information is complete.
  bool hasCompleteAcademicInfo() {
    return university.isNotEmpty && degreeProgram.isNotEmpty && semester > 0;
  }

  /// Checks if the basic contact information is valid and present.
  bool hasValidContactInfo() {
    return email.isNotEmpty && email.contains('@') && phone.isNotEmpty;
  }

  @override
  String toString() {
    return 'StudentProfile(fullName: $fullName, title: $title, university: $university, semester: $semester)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is StudentProfile &&
      other.fullName == fullName &&
      other.email == email &&
      other.university == university &&
      other.semester == semester;
  }

  @override
  int get hashCode {
    return fullName.hashCode ^ email.hashCode ^ university.hashCode ^ semester.hashCode;
  }
}
"""

skill_model = """/// Skill Model
///
/// Represents an individual skill possesed by the student.
/// Used in the Skills Section to display technical abilities.
import 'package:flutter/material.dart';

/// Categories of skills to logically group them.
enum SkillCategory {
  mobileDevelopment,
  programming,
  tools,
  versionControl,
  design,
  other,
}

@immutable
class Skill {
  /// The name of the skill, e.g., 'Flutter'.
  final String name;
  
  /// The category to which this skill belongs.
  final SkillCategory category;
  
  /// An icon path or identifier representing the skill visually.
  final String icon;
  
  /// Hex color code or description for the skill card background.
  final String colorMetadata;
  
  /// A float value between 0.0 and 1.0 representing proficiency.
  final double proficiency;
  
  /// A brief description of the skill and experience.
  final String description;

  /// Creates a [Skill] instance.
  const Skill({
    required this.name,
    required this.category,
    required this.icon,
    this.colorMetadata = '#6C63FF',
    this.proficiency = 0.5,
    required this.description,
  });

  /// Copy with functionality for updating existing [Skill] objects.
  Skill copyWith({
    String? name,
    SkillCategory? category,
    String? icon,
    String? colorMetadata,
    double? proficiency,
    String? description,
  }) {
    return Skill(
      name: name ?? this.name,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      colorMetadata: colorMetadata ?? this.colorMetadata,
      proficiency: proficiency ?? this.proficiency,
      description: description ?? this.description,
    );
  }

  /// Converts the [Skill] to a Map.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category.toString(),
      'icon': icon,
      'colorMetadata': colorMetadata,
      'proficiency': proficiency,
      'description': description,
    };
  }

  /// Factory to create a [Skill] from a Map.
  factory Skill.fromMap(Map<String, dynamic> map) {
    return Skill(
      name: map['name'] ?? '',
      category: _parseCategory(map['category']),
      icon: map['icon'] ?? '',
      colorMetadata: map['colorMetadata'] ?? '#000000',
      proficiency: map['proficiency']?.toDouble() ?? 0.0,
      description: map['description'] ?? '',
    );
  }

  /// Internal helper to parse categories from string safely.
  static SkillCategory _parseCategory(String? categoryStr) {
    if (categoryStr == null) return SkillCategory.other;
    for (var value in SkillCategory.values) {
      if (value.toString() == categoryStr) return value;
    }
    return SkillCategory.other;
  }

  /// Gets a formatted display label for the category.
  String displayLabel() {
    switch (category) {
      case SkillCategory.mobileDevelopment:
        return 'Mobile Development';
      case SkillCategory.programming:
        return 'Programming';
      case SkillCategory.tools:
        return 'Tools';
      case SkillCategory.versionControl:
        return 'Version Control';
      case SkillCategory.design:
        return 'Design';
      case SkillCategory.other:
        return 'Other';
    }
  }

  /// Validates the skill data constraints.
  bool isValid() {
    return name.isNotEmpty && proficiency >= 0.0 && proficiency <= 1.0;
  }

  /// Parses color metadata into an actual Flutter [Color] object.
  Color get color {
    try {
      if (colorMetadata.startsWith('#')) {
        final hex = colorMetadata.substring(1);
        if (hex.length == 6) {
          return Color(int.parse('0xFF$hex'));
        }
      }
      return Colors.blue;
    } catch (_) {
      return Colors.blue;
    }
  }

  @override
  String toString() {
    return 'Skill(name: $name, category: $category, proficiency: $proficiency)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Skill && other.name == name && other.category == category;
  }

  @override
  int get hashCode => name.hashCode ^ category.hashCode;
}
"""

education_model = """/// Education Model
///
/// Holds academic timeline information for the student.
/// Enforces validation to prevent impossible date ranges.
import 'package:flutter/foundation.dart';

@immutable
class Education {
  /// Name of the degree, e.g., 'Bachelor of Science'.
  final String degree;
  
  /// The institution offering the degree.
  final String institute;
  
  /// The year the studies began.
  final int startYear;
  
  /// The expected or actual year of graduation.
  final int expectedGraduationYear;
  
  /// Current semester in the program.
  final int currentSemester;
  
  /// Detailed description of accomplishments or coursework.
  final String description;

  /// Primary constructor.
  const Education({
    required this.degree,
    required this.institute,
    required this.startYear,
    required this.expectedGraduationYear,
    required this.currentSemester,
    required this.description,
  });

  /// Copy with updates.
  Education copyWith({
    String? degree,
    String? institute,
    int? startYear,
    int? expectedGraduationYear,
    int? currentSemester,
    String? description,
  }) {
    return Education(
      degree: degree ?? this.degree,
      institute: institute ?? this.institute,
      startYear: startYear ?? this.startYear,
      expectedGraduationYear: expectedGraduationYear ?? this.expectedGraduationYear,
      currentSemester: currentSemester ?? this.currentSemester,
      description: description ?? this.description,
    );
  }

  /// Serialization to Map.
  Map<String, dynamic> toMap() {
    return {
      'degree': degree,
      'institute': institute,
      'startYear': startYear,
      'expectedGraduationYear': expectedGraduationYear,
      'currentSemester': currentSemester,
      'description': description,
    };
  }

  /// Deserialization from Map.
  factory Education.fromMap(Map<String, dynamic> map) {
    return Education(
      degree: map['degree'] ?? '',
      institute: map['institute'] ?? '',
      startYear: map['startYear']?.toInt() ?? 2000,
      expectedGraduationYear: map['expectedGraduationYear']?.toInt() ?? 2004,
      currentSemester: map['currentSemester']?.toInt() ?? 1,
      description: map['description'] ?? '',
    );
  }

  /// Checks if the education record has valid constraints.
  /// Validation rules:
  /// - startYear <= expectedGraduationYear
  /// - currentSemester >= 1
  /// - expectedGraduationYear >= startYear
  bool get isValid {
    return startYear <= expectedGraduationYear &&
           currentSemester >= 1 &&
           degree.isNotEmpty &&
           institute.isNotEmpty;
  }
  
  /// Provides a formatted timeline string.
  String get timelineString {
    return '$startYear - $expectedGraduationYear';
  }

  @override
  String toString() {
    return 'Education(degree: $degree, institute: $institute, years: $startYear-$expectedGraduationYear)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Education &&
      other.degree == degree &&
      other.institute == institute &&
      other.startYear == startYear;
  }

  @override
  int get hashCode => degree.hashCode ^ institute.hashCode ^ startYear.hashCode;
}
"""

project_model = """/// Project Model
///
/// Encapsulates information about a technical project created by the student.
/// Allows links to GitHub and formatted technology lists.
import 'package:flutter/foundation.dart';

@immutable
class Project {
  /// Name of the project.
  final String name;
  
  /// Short description of what the project does.
  final String description;
  
  /// A list of technologies used, e.g., ['Flutter', 'Dart', 'Firebase'].
  final List<String> technologies;
  
  /// The asset path to an image representing the project.
  final String imageAsset;
  
  /// An icon representation if an image is not used.
  final String icon;
  
  /// A valid GitHub URL to the project repository.
  final String githubUrl;

  const Project({
    required this.name,
    required this.description,
    required this.technologies,
    required this.imageAsset,
    required this.icon,
    required this.githubUrl,
  });

  Project copyWith({
    String? name,
    String? description,
    List<String>? technologies,
    String? imageAsset,
    String? icon,
    String? githubUrl,
  }) {
    return Project(
      name: name ?? this.name,
      description: description ?? this.description,
      technologies: technologies ?? this.technologies,
      imageAsset: imageAsset ?? this.imageAsset,
      icon: icon ?? this.icon,
      githubUrl: githubUrl ?? this.githubUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'technologies': technologies,
      'imageAsset': imageAsset,
      'icon': icon,
      'githubUrl': githubUrl,
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      technologies: List<String>.from(map['technologies'] ?? const []),
      imageAsset: map['imageAsset'] ?? '',
      icon: map['icon'] ?? '',
      githubUrl: map['githubUrl'] ?? '',
    );
  }

  /// Validates the project data.
  bool validate() {
    if (name.isEmpty) return false;
    if (description.isEmpty) return false;
    return true;
  }

  /// Returns true if a valid github URL is present.
  bool hasGithubLink() {
    return githubUrl.isNotEmpty && githubUrl.startsWith('http');
  }
  
  /// Formats the technology list into a single readable string.
  String formattedTechnologyList() {
    return technologies.join(' • ');
  }

  @override
  String toString() {
    return 'Project(name: $name, tech: ${technologies.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Project &&
      other.name == name &&
      other.githubUrl == githubUrl;
  }

  @override
  int get hashCode => name.hashCode ^ githubUrl.hashCode;
}
"""

contact_info_model = """/// Contact Info Model
///
/// Stores details required for contacting the student.
import 'package:flutter/foundation.dart';

@immutable
class ContactInfo {
  final String email;
  final String phone;
  final String location;
  final String github;
  final String linkedin;
  final String portfolio;

  const ContactInfo({
    required this.email,
    required this.phone,
    required this.location,
    required this.github,
    required this.linkedin,
    required this.portfolio,
  });

  ContactInfo copyWith({
    String? email,
    String? phone,
    String? location,
    String? github,
    String? linkedin,
    String? portfolio,
  }) {
    return ContactInfo(
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      github: github ?? this.github,
      linkedin: linkedin ?? this.linkedin,
      portfolio: portfolio ?? this.portfolio,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'phone': phone,
      'location': location,
      'github': github,
      'linkedin': linkedin,
      'portfolio': portfolio,
    };
  }

  factory ContactInfo.fromMap(Map<String, dynamic> map) {
    return ContactInfo(
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      location: map['location'] ?? '',
      github: map['github'] ?? '',
      linkedin: map['linkedin'] ?? '',
      portfolio: map['portfolio'] ?? '',
    );
  }

  bool validateEmail() {
    return email.contains('@') && email.contains('.');
  }

  bool validatePhone() {
    return phone.length >= 7;
  }

  bool hasGithub() => github.isNotEmpty && github.startsWith('http');
  bool hasLinkedIn() => linkedin.isNotEmpty && linkedin.startsWith('http');
  bool hasPortfolio() => portfolio.isNotEmpty && portfolio.startsWith('http');

  /// Returns a map of available social links for dynamic rendering.
  Map<String, String> availableLinks() {
    final map = <String, String>{};
    if (hasGithub()) map['GitHub'] = github;
    if (hasLinkedIn()) map['LinkedIn'] = linkedin;
    if (hasPortfolio()) map['Portfolio'] = portfolio;
    return map;
  }

  @override
  String toString() {
    return 'ContactInfo(email: $email, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ContactInfo && other.email == email;
  }

  @override
  int get hashCode => email.hashCode;
}
"""

navigation_item_model = """/// Navigation Item Model
///
/// Represents an entry in the Drawer or Bottom Navigation Bar.
import 'package:flutter/material.dart';

@immutable
class NavigationItem {
  final String title;
  final IconData icon;
  final String route;
  
  const NavigationItem({
    required this.title,
    required this.icon,
    required this.route,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NavigationItem && other.route == route;
  }

  @override
  int get hashCode => route.hashCode;
}
"""

write_file('lib/models/student_profile.dart', student_profile_model)
write_file('lib/models/skill.dart', skill_model)
write_file('lib/models/education.dart', education_model)
write_file('lib/models/project.dart', project_model)
write_file('lib/models/contact_info.dart', contact_info_model)
write_file('lib/models/navigation_item.dart', navigation_item_model)

print("Part 1 generated")
