import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/discharge_mycosis_screen.dart';
import 'screens/cycle_history_screen.dart';
import 'screens/hiv_screen.dart';

class FanmPlusApp extends StatelessWidget {
  const FanmPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fanm+',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case '/login':
        page = const LoginScreen();
        break;
      case '/home':
        page = const HomeScreen();
        break;
      case '/discharge-mycosis':
        page = const DischargeMycosisScreen();
        break;
      case '/cycle-history':
        page = const CycleHistoryScreen();
        break;
      case '/hiv':
        page = const HivScreen();
        break;
      default:
        page = const SplashScreen();
    }
    return _FadeRoute(page: page, settings: settings);
  }
}

class _FadeRoute extends PageRouteBuilder {
  final Widget page;
  _FadeRoute({required this.page, RouteSettings? settings})
      : super(
          settings: settings,
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: Tween<double>(begin: 0.3, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                ),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 350),
        );
}
