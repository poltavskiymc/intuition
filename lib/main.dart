import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intuition/core/theme/app_theme.dart';
import 'package:intuition/core/navigation/app_router.dart';
import 'package:intuition/shared/services/mock_database_service.dart';
import 'package:intuition/shared/providers/splash_provider.dart';
import 'package:intuition/shared/widgets/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация mock базы данных (без CocoaPods)
  await MockDatabaseService.initialize();

  runApp(const ProviderScope(child: IntuitionApp()));
}

class IntuitionApp extends ConsumerWidget {
  const IntuitionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showSplash = ref.watch(splashProvider);

    if (showSplash) {
      return MaterialApp(
        title: 'Интуиция',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: SplashScreen(
          onAnimationComplete: () {
            ref.read(splashProvider.notifier).hideSplash();
          },
        ),
      );
    }

    return MaterialApp.router(
      title: 'Интуиция',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
