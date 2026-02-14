import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

/// Settings service for managing app settings and API keys
class SettingsService {
  final SharedPreferences _prefs;

  SettingsService(this._prefs);

  // Theme settings
  Future<void> setThemeMode(String mode) async {
    await _prefs.setString('theme_mode', mode);
  }

  Future<String> getThemeMode() async {
    return _prefs.getString('theme_mode') ?? 'system';
  }

  // Language settings
  Future<void> setLanguage(String language) async {
    await _prefs.setString('language', language);
  }

  Future<String> getLanguage() async {
    return _prefs.getString('language') ?? 'en';
  }

  // API Keys
  Future<void> setGeminiApiKey(String key) async {
    await _prefs.setString(AppConstants.geminiApiKeyStorage, key);
  }

  Future<String?> getGeminiApiKey() async {
    return _prefs.getString(AppConstants.geminiApiKeyStorage);
  }

  Future<void> setOpenRouterApiKey(String key) async {
    await _prefs.setString(AppConstants.openRouterApiKeyStorage, key);
  }

  Future<String?> getOpenRouterApiKey() async {
    return _prefs.getString(AppConstants.openRouterApiKeyStorage);
  }

  Future<void> setDefaultModel(String model) async {
    await _prefs.setString(AppConstants.defaultModelStorage, model);
  }

  Future<String> getDefaultModel() async {
    return _prefs.getString(AppConstants.defaultModelStorage) ?? 
           AppConstants.defaultGeminiModel;
  }

  // Offline mode
  Future<void> setOfflineMode(bool enabled) async {
    await _prefs.setBool('offline_mode', enabled);
  }

  Future<bool> getOfflineMode() async {
    return _prefs.getBool('offline_mode') ?? false;
  }

  // Cache settings
  Future<void> clearCache() async {
    await _prefs.clear();
  }

  // Check if API is configured
  Future<bool> isAIConfigured() async {
    final geminiKey = await getGeminiApiKey();
    final openRouterKey = await getOpenRouterApiKey();
    return (geminiKey != null && geminiKey.isNotEmpty) ||
           (openRouterKey != null && openRouterKey.isNotEmpty);
  }

  // Get available models based on API keys
  Future<List<String>> getAvailableModels() async {
    final List<String> models = [];
    final geminiKey = await getGeminiApiKey();
    final openRouterKey = await getOpenRouterApiKey();

    if (geminiKey != null && geminiKey.isNotEmpty) {
      models.addAll([
        'gemini-2.0-flash',
        'gemini-1.5-pro',
        'gemini-1.5-flash',
      ]);
    }

    if (openRouterKey != null && openRouterKey.isNotEmpty) {
      models.addAll([
        'openai/gpt-4o-mini',
        'openai/gpt-4o',
        'anthropic/claude-3-haiku',
        'google/gemma-2-27b',
      ]);
    }

    return models;
  }
}

/// Settings service provider
final settingsServiceProvider = Provider<SettingsService>((ref) {
  throw UnimplementedError('SettingsService must be initialized with SharedPreferences');
});

/// Initialize settings service with SharedPreferences
Future<SettingsService> initializeSettingsService() async {
  final prefs = await SharedPreferences.getInstance();
  return SettingsService(prefs);
}

/// Theme mode state provider
final themeModeProvider = StateProvider<String>((ref) => 'system');

/// Language state provider
final languageProvider = StateProvider<String>((ref) => 'en');

/// Selected AI engine provider
final selectedEngineProvider = StateProvider<String>((ref) => 'gemini');

/// Selected AI model provider
final selectedModelProvider = StateProvider<String>((ref) => 'gemini-2.0-flash');
