import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:students_profile/controllers/profile_controller.dart';
import 'package:students_profile/theme/theme_provider.dart';
import 'package:students_profile/models/student_profile.dart';
import 'package:students_profile/screens/education_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('EducationScreen renders academic info with required badges', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    final controller = ProfileController();
    controller.updateProfile(
      const StudentProfile(
        fullName: 'Abdullah Azeem',
        title: 'Flutter Developer',
        introduction: 'Building responsive apps',
        university: 'Devixo University of Technology',
        degreeProgram: 'B.Sc. Software Engineering',
        semester: 6,
        shortBio: 'Dedicated student',
        location: 'Islamabad',
        profileImage: '',
        email: 'abdullah@example.com',
        phone: '+92 300 1234567',
        github: 'https://github.com/abdullah',
        linkedin: 'https://linkedin.com/in/abdullah',
        portfolio: 'https://abdullah.dev',
        profileStatus: 'Student',
      ),
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ProfileController>.value(value: controller),
          ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ],
        child: const MaterialApp(
          home: EducationScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify key fields required by assignment PDF
    expect(find.text('University / Institute'), findsAtLeastNWidgets(1));
    expect(find.text('Start Year'), findsAtLeastNWidgets(1));
    expect(find.text('Expected Graduation'), findsAtLeastNWidgets(1));
    expect(find.text('Current Semester'), findsAtLeastNWidgets(1));
  });
}
