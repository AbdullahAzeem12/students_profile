import os

def write_file(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content.strip() + '\n')

def main():
    # 1. Page Transitions
    write_file('lib/utils/custom_page_transition.dart', """
import 'package:flutter/material.dart';

class CustomPageTransition extends PageRouteBuilder {
  final Widget child;

  CustomPageTransition({required this.child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.easeOutCubic;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: curve),
            );

            return SlideTransition(
              position: offsetAnimation,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: child,
              ),
            );
          },
        );
}
""")

    # 2. Update Main Dart to use a smooth theme builder and standard lengths
    write_file('lib/main.dart', """
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/app_theme.dart';
import 'controllers/profile_controller.dart';
import 'theme/theme_provider.dart';
import 'utils/responsive_utils.dart';
import 'widgets/bottom_navigation.dart';
import 'widgets/navigation_drawer.dart';

import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/skills_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/contact_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProfileController()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Student Profile',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: const MainScaffold(),
          );
        },
      ),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _fadeController;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ProfileScreen(),
    const SkillsScreen(),
    const ProjectsScreen(),
    const ContactScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeController.forward();
    
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileController>(context, listen: false).loadAllData();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onNavigationChanged(int index) {
    if (_currentIndex == index) return;
    
    _fadeController.reverse().then((_) {
      setState(() {
        _currentIndex = index;
      });
      _fadeController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Row(
          children: [
            if (isDesktop)
              AppNavigationDrawer(
                currentIndex: _currentIndex,
                onIndexChanged: _onNavigationChanged,
              ),
            Expanded(
              child: FadeTransition(
                opacity: _fadeController,
                child: _screens[_currentIndex],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: !isDesktop
          ? AnimatedBottomNavigation(
              currentIndex: _currentIndex,
              onTap: _onNavigationChanged,
            )
          : null,
    );
  }
}
""")

if __name__ == '__main__':
    main()
    print("Upgrade Part 5 complete.")
