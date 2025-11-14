import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/services/supabase_service.dart';
import 'core/services/notification_service.dart';
import 'core/navigation/app_router.dart';
import 'features/premium/providers/iap_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Hive.initFlutter();
  } catch (e, stackTrace) {
    print('ERROR: Hive initialization failed: $e');
    print('Stack trace: $stackTrace');
  }

  try {
    await SupabaseService.initialize();
  } catch (e, stackTrace) {
    print('ERROR: Supabase initialization failed: $e');
    print('Stack trace: $stackTrace');
  }

  try {
    await NotificationService().initialize();
  } catch (e, stackTrace) {
    print('ERROR: Notification service initialization failed: $e');
    print('Stack trace: $stackTrace');
  }

  runApp(
    const ProviderScope(
      child: IapInitializer(
        child: LumenApp(),
      ),
    ),
  );
}

class IapInitializer extends ConsumerWidget {
  final Widget child;
  
  const IapInitializer({super.key, required this.child});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iapInit = ref.watch(iapInitializationProvider);
    
    return iapInit.when(
      data: (_) => child,
      loading: () => const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (error, stack) {
        debugPrint('IAP initialization error: $error');
        return child;
      },
    );
  }
}

class LumenApp extends StatelessWidget {
  const LumenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
