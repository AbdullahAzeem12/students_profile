import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:students_profile/controllers/profile_controller.dart';
import 'package:students_profile/models/student_profile.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProfileController State Management Tests', () {
    late ProfileController controller;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      controller = ProfileController();
    });

    test('Initial controller state has empty lists and no errors', () {
      expect(controller.profile, isNull);
      expect(controller.skills, isEmpty);
      expect(controller.education, isEmpty);
      expect(controller.projects, isEmpty);
      expect(controller.isLoading, isFalse);
      expect(controller.errorMessage, isNull);
    });

    test('loadAllData populates complete student information', () async {
      await controller.loadAllData();

      expect(controller.profile, isNotNull);
      expect(controller.skills, isNotEmpty);
      expect(controller.education, isNotEmpty);
      expect(controller.projects, isNotEmpty);
      expect(controller.contactInfo, isNotNull);
      expect(controller.isLoading, isFalse);

      // Verify that at least 3 projects are present (PDF requirement)
      expect(controller.totalProjects, greaterThanOrEqualTo(3));

      // Verify skills mastery is calculated
      expect(controller.averageSkillMastery, greaterThan(0));

      // Verify Education has semester
      expect(controller.education.first.currentSemester, isNotNull);
    });

    test('updateProfile updates state and notifies listeners', () {
      bool notified = false;
      controller.addListener(() {
        notified = true;
      });

      const updated = StudentProfile(
        fullName: 'Jane Doe Updated',
        title: 'Lead Flutter Developer',
        introduction: 'Updated introduction text',
        university: 'Devixo Institute',
        degreeProgram: 'Software Engineering',
        semester: 8,
        shortBio: 'Updated bio text',
        location: 'London, UK',
        profileImage: '',
        email: 'jane@example.com',
        phone: '+44 1234 567890',
        github: 'https://github.com/janedoe',
        linkedin: 'https://linkedin.com/in/janedoe',
        portfolio: 'https://janedoe.dev',
        profileStatus: 'Working on Flutter',
      );

      controller.updateProfile(updated);

      expect(notified, isTrue);
      expect(controller.profile?.fullName, equals('Jane Doe Updated'));
      expect(controller.profile?.semester, equals(8));
      expect(controller.profile?.location, equals('London, UK'));
    });
  });
}
