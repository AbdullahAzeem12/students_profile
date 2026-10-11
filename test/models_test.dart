import 'package:flutter_test/flutter_test.dart';
import 'package:students_profile/models/student_profile.dart';
import 'package:students_profile/models/education.dart';
import 'package:students_profile/models/skill.dart';
import 'package:students_profile/models/project.dart';
import 'package:students_profile/models/contact_info.dart';

void main() {
  group('Student Profile Models Tests', () {
    test('StudentProfile model holds personal and academic info correctly', () {
      const profile = StudentProfile(
        fullName: 'Abdullah Azeem',
        title: 'App Development Intern',
        introduction: 'Building responsive mobile applications with Flutter.',
        university: 'Devixo University of Technology',
        degreeProgram: 'B.Sc. Software Engineering',
        semester: 6,
        shortBio: 'Dedicated software engineering student focusing on Flutter.',
        location: 'Islamabad, Pakistan',
        profileImage: 'assets/images/app_logo.jpg',
        email: 'abdullah.azeem@example.com',
        phone: '+92 300 1234567',
        github: 'https://github.com/abdullahazeem',
        linkedin: 'https://linkedin.com/in/abdullahazeem',
        portfolio: 'https://abdullahazeem.dev',
        profileStatus: 'Actively building Flutter apps',
      );

      expect(profile.fullName, equals('Abdullah Azeem'));
      expect(profile.university, equals('Devixo University of Technology'));
      expect(profile.degreeProgram, equals('B.Sc. Software Engineering'));
      expect(profile.semester, equals(6));
      expect(profile.location, equals('Islamabad, Pakistan'));
      expect(profile.email, equals('abdullah.azeem@example.com'));
      expect(profile.phone, equals('+92 300 1234567'));
    });

    test('Education model calculates startYear, graduationYear, and semester', () {
      final education = Education(
        institutionName: 'Devixo University of Technology',
        degree: 'Bachelor of Science',
        fieldOfStudy: 'Software Engineering',
        startDate: DateTime(2021, 9, 1),
        endDate: DateTime(2025, 6, 1),
        currentSemester: 6,
        gpa: 3.85,
        description: 'Comprehensive study of mobile application engineering.',
      );

      expect(education.institutionName, equals('Devixo University of Technology'));
      expect(education.degree, equals('Bachelor of Science'));
      expect(education.startYear, equals(2021));
      expect(education.expectedGraduationYear, equals(2025));
      expect(education.currentSemester, equals(6));
      expect(education.gpa, equals(3.85));
    });

    test('Skill model holds technical skill properties', () {
      const skill = Skill(
        id: 'sk_flutter',
        name: 'Flutter',
        masteryPercentage: 90.0,
        category: SkillCategory.mobileDevelopment,
        description: 'Cross-platform mobile UI framework',
      );

      expect(skill.name, equals('Flutter'));
      expect(skill.masteryPercentage, equals(90.0));
      expect(skill.category, equals(SkillCategory.mobileDevelopment));
    });

    test('Project model holds repository and details', () {
      final project = Project(
        id: 'p_1',
        title: 'Students Profile Mobile App',
        shortDescription: 'Professional Flutter portfolio application',
        fullDescription: 'Comprehensive student profile application with 6 sections.',
        imageUrl: 'https://example.com/project.png',
        technologies: ['Flutter', 'Dart', 'GoRouter', 'Provider'],
        githubUrl: 'https://github.com/example/student-profile',
        projectUrl: 'https://example.com',
        category: 'Mobile',
      );

      expect(project.title, equals('Students Profile Mobile App'));
      expect(project.technologies.length, equals(4));
      expect(project.githubUrl, isNotEmpty);
      expect(project.category, equals('Mobile'));
    });

    test('ContactInfo holds complete social channels', () {
      const contact = ContactInfo(
        email: 'intern@devixo.com',
        phone: '+1 555 123 4567',
        address: 'Tech District',
        linkedInUrl: 'https://linkedin.com/in/intern',
        githubUrl: 'https://github.com/intern',
      );

      expect(contact.email, equals('intern@devixo.com'));
      expect(contact.phone, equals('+1 555 123 4567'));
      expect(contact.githubUrl, equals('https://github.com/intern'));
    });
  });
}
