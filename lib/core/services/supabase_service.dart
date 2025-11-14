import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_constants.dart';

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    final url = AppConstants.supabaseUrl;
    final key = AppConstants.supabaseAnonKey;
    
    if (url.isEmpty || key.isEmpty) {
      print('WARNING: Supabase credentials missing. Skipping initialization.');
      print('URL empty: ${url.isEmpty}, Key empty: ${key.isEmpty}');
      return;
    }
    
    try {
      await Supabase.initialize(
        url: url,
        anonKey: key,
      );
      print('Supabase initialized successfully');
    } catch (e, stackTrace) {
      print('ERROR: Supabase initialization failed: $e');
      print('Stack trace: $stackTrace');
      // Don't rethrow - allow app to continue without Supabase
    }
  }

  static User? get currentUser => client.auth.currentUser;
  static bool get isAuthenticated => currentUser != null;

  static Stream<AuthState> get authStateChanges =>
      client.auth.onAuthStateChange;
}
