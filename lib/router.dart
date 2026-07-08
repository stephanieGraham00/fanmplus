import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'providers/auth_provider.dart';
import 'providers/user_data_provider.dart';
import 'widgets/bottom_nav.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/calendar/calendar_screen.dart';
import 'screens/self_care/self_care_screen.dart';
import 'screens/analysis/analysis_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/ai/ai_chat_screen.dart';
import 'screens/community/community_screen.dart';
import 'screens/premium/premium_screen.dart';
import 'screens/health/medical_questionnaire_screen.dart';
import 'screens/health/pregnancy_screen.dart';
import 'screens/health/hiv_screen.dart';
import 'screens/health/abuse_screen.dart';
import 'screens/health/medical_profile_screen.dart';
import 'screens/health/contraception_screen.dart';
import 'screens/analysis/reports_screen.dart';
import 'screens/self_care/timeline_screen.dart';
import 'screens/health/medication_screen.dart';
import 'screens/health/hygiene_education_screen.dart';
import 'screens/calendar/cycle_history_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final userData = ref.watch(currentUserDataProvider).valueOrNull;

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isAuthRoute = state.matchedLocation == '/login' || state.matchedLocation == '/register';
      final isQuestionnaire = state.matchedLocation == '/questionnaire';

      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn && isAuthRoute) return '/home';

      final needsQuestionnaire = isLoggedIn && userData != null && !userData.hasCompletedQuestionnaire;
      if (needsQuestionnaire && !isQuestionnaire) return '/questionnaire';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RegisterScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: '/questionnaire',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MedicalQuestionnaireScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                )),
                child: child,
              ),
        ),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => _ShellWrapper(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/calendar',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const CalendarScreen(),
            ),
          ),
          GoRoute(
            path: '/self-care',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const SelfCareScreen(),
            ),
          ),
          GoRoute(
            path: '/analysis',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const AnalysisScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ProfileScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/ai-chat',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AIChatScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
        ),
      ),
      GoRoute(
        path: '/community',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const CommunityScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
        ),
      ),
      GoRoute(
        path: '/premium',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const PremiumScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              ScaleTransition(scale: animation, child: child),
        ),
      ),
      GoRoute(
        path: '/pregnancy',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const PregnancyScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
        ),
      ),
      GoRoute(
        path: '/hiv',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const HivScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
        ),
      ),
      GoRoute(
        path: '/abuse',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AbuseScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
        ),
      ),
      GoRoute(
        path: '/medical-profile',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MedicalProfileScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
        ),
      ),
      GoRoute(
        path: '/contraception',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ContraceptionScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
        ),
      ),
      GoRoute(
        path: '/reports',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ReportsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
        ),
      ),
      GoRoute(
        path: '/timeline',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const TimelineScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
        ),
      ),
      GoRoute(
        path: '/medication',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MedicationScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
        ),
      ),
      GoRoute(
        path: '/hygiene-education',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const HygieneEducationScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
        ),
      ),
      GoRoute(
        path: '/cycle-history',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const CycleHistoryScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
        ),
      ),
    ],
  );
});

class _ShellWrapper extends ConsumerWidget {
  final Widget child;
  const _ShellWrapper({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(routerProvider);
    final location = router.location;

    int currentIndex = 0;
    if (location.startsWith('/calendar')) currentIndex = 1;
    else if (location.startsWith('/self-care')) currentIndex = 2;
    else if (location.startsWith('/analysis')) currentIndex = 3;
    else if (location.startsWith('/profile')) currentIndex = 4;

    return Scaffold(
      body: child,
      bottomNavigationBar: FanmBottomNav(
        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0: context.go('/home');
            case 1: context.go('/calendar');
            case 2: context.go('/self-care');
            case 3: context.go('/analysis');
            case 4: context.go('/profile');
          }
        },
      ),
    );
  }
}
