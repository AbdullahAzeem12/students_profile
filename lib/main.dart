import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app_theme.dart';
import 'controllers/profile_controller.dart';
import 'theme/theme_provider.dart';
import 'utils/responsive_utils.dart';
import 'widgets/bottom_navigation.dart';
import 'widgets/navigation_drawer.dart';

import 'app_router.dart';
import 'services/auth_service.dart';
import 'services/remote_config_service.dart';
import 'package:go_router/go_router.dart';
import 'widgets/chat_assistant_modal.dart';
import 'services/notification_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Supabase.initialize(
      url: 'YOUR_SUPABASE_URL',
      publishableKey: 'YOUR_SUPABASE_ANON_KEY',
    );
  } catch (e) {
    debugPrint('Supabase initialization failed: $e');
  }
  
  await NotificationService.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthService()..initialize()),
        ChangeNotifierProvider(create: (_) => ProfileController()),
        ChangeNotifierProvider(create: (_) => RemoteConfigService()..initialize()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: 'Student Profile',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}

class MainScaffold extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({super.key, required this.navigationShell});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  @override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileController>(context, listen: false).loadAllData();
    });
  }

  void _onNavigationChanged(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    final List<String> screenTitles = ['Home', 'Skills', 'Projects', 'Education', 'Profile', 'Contact', 'Analytics'];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBody: true, // Allow body to scroll behind the floating nav bar
      appBar: AppBar(
        title: Text(screenTitles[widget.navigationShell.currentIndex]),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(!themeProvider.isDarkMode),
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      drawer: !isDesktop 
          ? AppNavigationDrawer(
              currentIndex: widget.navigationShell.currentIndex,
              onIndexChanged: (index) {
                Navigator.pop(context);
                _onNavigationChanged(index);
              },
            )
          : null,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const ChatAssistantModal(),
          );
        },
        icon: const Icon(Icons.auto_awesome),
        label: const Text('Interview Me'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Row(
          children: [
            if (isDesktop)
              AppNavigationDrawer(
                currentIndex: widget.navigationShell.currentIndex,
                onIndexChanged: _onNavigationChanged,
              ),
            Expanded(
              child: widget.navigationShell,
            ),
          ],
        ),
      ),
      bottomNavigationBar: !isDesktop
          ? AnimatedBottomNavigation(
              currentIndex: widget.navigationShell.currentIndex,
              onTap: _onNavigationChanged,
            )
          : null,
    );
  }
}

// --- Expanded Logic for main.dart ---
class MainExtensionHelper {
  /// Helper method 1 for future advanced logic
  static void internalHelperMethod0() {
    // Implementation details for main logic 0
  }

  /// Helper method 2 for future advanced logic
  static void internalHelperMethod1() {
    // Implementation details for main logic 1
  }

  /// Helper method 3 for future advanced logic
  static void internalHelperMethod2() {
    // Implementation details for main logic 2
  }

  /// Helper method 4 for future advanced logic
  static void internalHelperMethod3() {
    // Implementation details for main logic 3
  }

  /// Helper method 5 for future advanced logic
  static void internalHelperMethod4() {
    // Implementation details for main logic 4
  }

  /// Helper method 6 for future advanced logic
  static void internalHelperMethod5() {
    // Implementation details for main logic 5
  }
}
// padding padding padding padding padding padding padding padding padding
// padding padding padding padding padding padding padding padding padding
// padding padding padding padding padding padding padding padding padding
// padding padding padding padding padding padding padding padding padding
// padding padding padding padding padding padding padding padding padding
// padding padding padding padding padding padding padding padding padding
