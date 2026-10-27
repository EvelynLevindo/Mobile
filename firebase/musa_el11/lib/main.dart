import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
import 'screens/library_screen.dart';
import 'screens/login_screen.dart';
import 'screens/search_screen.dart';
import 'services/auth_service.dart';
import 'widgets/custom_widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MusaApp());
}

class MusaApp extends StatelessWidget {
  const MusaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Musa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: MusaColors.background,
        primaryColor: MusaColors.primaryCyan,
        colorScheme: const ColorScheme.dark(
          primary: MusaColors.primaryCyan,
          secondary: MusaColors.secondaryPink,
          surface: MusaColors.surfaceContainer,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: MusaColors.background,
          elevation: 0,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: MusaColors.surfaceElevated,
          contentTextStyle: const TextStyle(color: MusaColors.textPrimary),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: StreamBuilder(
        stream: AuthService().userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: MusaColors.background,
              body: Center(
                child: CircularProgressIndicator(color: MusaColors.primaryCyan),
              ),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            return const MainNavigator();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _idx = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    LibraryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MusaColors.background,
      body: IndexedStack(
        index: _idx,
        children: _screens,
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Docked MiniPlayer
          const MiniPlayer(),

          // Bottom Navigation Bar
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: MusaColors.borderSubtle, width: 0.5),
              ),
            ),
            child: BottomNavigationBar(
              backgroundColor: MusaColors.surfaceContainer.withValues(alpha: 0.95),
              elevation: 0,
              selectedItemColor: MusaColors.primaryCyan,
              unselectedItemColor: MusaColors.textMuted,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              unselectedLabelStyle: const TextStyle(fontSize: 12),
              currentIndex: _idx,
              onTap: (i) => setState(() => _idx = i),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.auto_awesome),
                  activeIcon: Icon(Icons.auto_awesome, color: MusaColors.primaryCyan),
                  label: 'Início',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  activeIcon: Icon(Icons.search, color: MusaColors.primaryCyan),
                  label: 'Buscar',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.queue_music),
                  activeIcon: Icon(Icons.queue_music, color: MusaColors.primaryCyan),
                  label: 'Biblioteca',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}