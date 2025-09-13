import 'package:go_router/go_router.dart';
import '../constants/app_constants.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/numerology/presentation/pages/numerology_page.dart';
import '../../features/tarot/presentation/pages/tarot_page.dart';
import '../../features/journal/presentation/pages/journal_page.dart';
import '../../features/community/presentation/pages/community_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: AppRoutes.numerology,
        builder: (context, state) => const NumerologyPage(),
      ),
      GoRoute(
        path: AppRoutes.tarot,
        builder: (context, state) => const TarotPage(),
      ),
      GoRoute(
        path: AppRoutes.journal,
        builder: (context, state) => const JournalPage(),
      ),
      GoRoute(
        path: AppRoutes.community,
        builder: (context, state) => const CommunityPage(),
      ),
    ],
  );
}
