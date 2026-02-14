import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants/app_constants.dart';

/// Settings service for managing app settings and API keys
class SettingsService {
  final FlutterSecureStorage _secureStorage;

  SettingsService(this._secureStorage);

  // Theme settings
  Future<void> setThemeMode(String mode) async {
    await _secureStorage.write(key: 'theme_mode', value: mode);
  }

  Future<String> getThemeMode() async {
    return await _secureStorage.read(key: 'theme_mode') ?? 'system';
  }

  // Language settings
  Future<void> setLanguage(String language) async {
    await _secureStorage.write(key: 'language', value: language);
  }

  Future<String> getLanguage() async {
    return await _secureStorage.read(key: 'language') ?? 'en';
  }

  // API Keys
  Future<void> setGeminiApiKey(String key) async {
    await _secureStorage.write(key: AppConstants.geminiApiKeyStorage, value: key);
  }

  Future<String?> getGeminiApiKey() async {
    return await _secureStorage.read(key: AppConstants.geminiApiKeyStorage);
  }

  Future<void> setOpenRouterApiKey(String key) async {
    await _secureStorage.write(key: AppConstants.openRouterApiKeyStorage, value: key);
  }

  Future<String?> getOpenRouterApiKey() async {
    return await _secureStorage.read(key: AppConstants.openRouterApiKeyStorage);
  }

  Future<void> setDefaultModel(String model) async {
    await _secureStorage.write(key: AppConstants.defaultModelStorage, value: model);
  }

  Future<String> getDefaultModel() async {
    return await _secureStorage.read(key: AppConstants.defaultModelStorage) ?? 
           AppConstants.defaultGeminiModel;
  }

  // Offline mode
  Future<void> setOfflineMode(bool enabled) async {
    await _secureStorage.write(key: 'offline_mode', value: enabled.toString());
  }

  Future<bool> getOfflineMode() async {
    final value = await _secureStorage.read(key: 'offline_mode');
    return value == 'true';
  }

  // Cache settings
  Future<void> clearCache() async {
    await _secureStorage.deleteAll();
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
  return SettingsService(const FlutterSecureStorage());
});

/// Theme mode state provider
final themeModeProvider = StateProvider<String>((ref) => 'system');

/// Language state provider
final languageProvider = StateProvider<String>((ref) => 'en');
