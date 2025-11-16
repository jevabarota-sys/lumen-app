import 'package:go_router/go_router.dart';
import '../constants/app_constants.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/numerology/presentation/pages/numerology_page.dart';
import '../../features/tarot/presentation/pages/tarot_page.dart';
import '../../features/journal/presentation/pages/journal_page.dart';
import '../../features/community/presentation/pages/community_page.dart';
import '../../features/relationships/presentation/pages/relationships_page.dart';
import '../../features/notifications/presentation/pages/notification_settings_page.dart';
import '../../features/manifestation/presentation/pages/manifestation_369_page.dart';
import '../../features/support/presentation/pages/support_page.dart';
import '../../features/menu/presentation/pages/app_menu_page.dart';
import '../../features/angel_cards/presentation/pages/angel_cards_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/ai_assistant/presentation/pages/ask_lumen_page.dart';

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
      GoRoute(
        path: AppRoutes.relationships,
        builder: (context, state) => const RelationshipsPage(),
      ),
      GoRoute(
        path: AppRoutes.notificationSettings,
        builder: (context, state) => const NotificationSettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.manifestation369,
        builder: (context, state) => const Manifestation369Page(),
      ),
      GoRoute(
        path: AppRoutes.support,
        builder: (context, state) => const SupportPage(),
      ),
      GoRoute(
        path: AppRoutes.menu,
        builder: (context, state) => const AppMenuPage(),
      ),
      GoRoute(
        path: AppRoutes.angelCards,
        builder: (context, state) => const AngelCardsPage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.askLumen,
        builder: (context, state) => const AskLumenPage(),
      ),
    ],
  );
}
