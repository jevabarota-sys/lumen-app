class AppConstants {
  static const String appName = 'Lumen';
  static const String appTagline = 'Your Personalized Growth Compass';

  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY');
  static const String stripePublishableKey =
      String.fromEnvironment('STRIPE_PUBLISHABLE_KEY');

  static const double premiumPrice = 9.99;
  static const String premiumPriceId =
      String.fromEnvironment('STRIPE_PRICE_ID');

  static const int maxFreeJournalEntries = 10;
  static const int maxFreeTarotDraws = 3;
}

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';
  static const String dashboard = '/dashboard';
  static const String numerology = '/numerology';
  static const String tarot = '/tarot';
  static const String journal = '/journal';
  static const String community = '/community';
  static const String premium = '/premium';
  static const String profile = '/profile';
}
