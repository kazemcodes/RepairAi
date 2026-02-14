/// App-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'RepairAI';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'AI-powered mobile repair assistant';

  // API Keys Storage Keys
  static const String geminiApiKeyStorage = 'gemini_api_key';
  static const String openRouterApiKeyStorage = 'openrouter_api_key';
  static const String defaultModelStorage = 'default_model';

  // Supabase
  static const String supabaseUrl = 'https://your-project.supabase.co';
  static const String supabaseAnonKey = 'your-anon-key';

  // GitHub
  static const String githubRepo = 'kazemcodes/RepairAi-files';
  static const String githubRawBase = 'https://raw.githubusercontent.com/kazemcodes/RepairAi-files/main';
  static const String indexJsonUrl = '$githubRawBase/index.json';

  // AI Models
  static const String defaultGeminiModel = 'gemini-2.0-flash';
  static const String defaultOpenRouterModel = 'openai/gpt-4o-mini';

  // Feature Flags
  static const bool enableOfflineMode = true;
  static const bool enableScraping = true;
  static const bool enableCommunitySubmissions = true;

  // Cache
  static const int maxCacheAge = 7; // days
  static const int maxSchematicCache = 100;
}
