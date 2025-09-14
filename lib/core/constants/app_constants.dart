class AppConstants {
  static const String appName = 'Lumen';
  static const String appTagline = 'Your Personalized Growth Compass';

  // Supabase Configuration
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  // Stripe Configuration
  static const String stripePublishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue: '',
  );
  static const String premiumPriceId = String.fromEnvironment(
    'STRIPE_PRICE_ID',
    defaultValue: '',
  );

  // App Configuration
  static const double premiumPrice = 9.99;
  static const int maxFreeJournalEntries = 10;
  static const int maxFreeTarotDraws = 3;

  // Validation helpers
  static bool get isSupabaseConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
  static bool get isStripeConfigured =>
      stripePublishableKey.isNotEmpty && premiumPriceId.isNotEmpty;
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
