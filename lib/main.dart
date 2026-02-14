import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/generated/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/router.dart';
import 'shared/services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final settingsService = SettingsService(prefs);
  
  runApp(
    ProviderScope(
      overrides: [
        settingsServiceProvider.overrideWithValue(settingsService),
      ],
      child: const RepairAIApp(),
    ),
  );
}

/// Main application widget
class RepairAIApp extends ConsumerWidget {
  const RepairAIApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final language = ref.watch(languageProvider);
    
    return MaterialApp.router(
      title: 'RepairAI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _getThemeMode(themeMode),
      routerConfig: appRouter,
      locale: _getLocale(language),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }

  ThemeMode _getThemeMode(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Locale _getLocale(String language) {
    switch (language) {
      case 'fa':
        return const Locale('fa');
      default:
        return const Locale('en');
    }
  }
}
