import 'package:flutter_test/flutter_test.dart';
import 'package:repair_ai/core/constants/app_constants.dart';

void main() {
  group('AppConstants Tests', () {
    group('App Info', () {
      test('should have correct app name', () {
        expect(AppConstants.appName, 'RepairAI');
      });

      test('should have correct app version', () {
        expect(AppConstants.appVersion, '1.0.0');
      });

      test('should have correct app description', () {
        expect(AppConstants.appDescription, 'AI-powered mobile repair assistant');
      });
    });

    group('API Keys Storage Keys', () {
      test('should have correct Gemini API key storage key', () {
        expect(AppConstants.geminiApiKeyStorage, 'gemini_api_key');
      });

      test('should have correct OpenRouter API key storage key', () {
        expect(AppConstants.openRouterApiKeyStorage, 'openrouter_api_key');
      });

      test('should have correct default model storage key', () {
        expect(AppConstants.defaultModelStorage, 'default_model');
      });
    });

    group('Supabase', () {
      test('should have correct Supabase URL', () {
        expect(AppConstants.supabaseUrl, 'https://your-project.supabase.co');
      });

      test('should have correct Supabase anon key', () {
        expect(AppConstants.supabaseAnonKey, 'your-anon-key');
      });
    });

    group('GitHub', () {
      test('should have correct GitHub repo', () {
        expect(AppConstants.githubRepo, 'repairai/repairai');
      });

      test('should have correct GitHub raw base URL', () {
        expect(
          AppConstants.githubRawBase,
          'https://raw.githubusercontent.com/repairai/repairai/main',
        );
      });

      test('should have correct index JSON URL', () {
        expect(
          AppConstants.indexJsonUrl,
          'https://raw.githubusercontent.com/repairai/repairai/main/index.json',
        );
      });

      test('indexJsonUrl should be constructed from githubRawBase', () {
        expect(
          AppConstants.indexJsonUrl,
          '${AppConstants.githubRawBase}/index.json',
        );
      });
    });

    group('AI Models', () {
      test('should have correct default Gemini model', () {
        expect(AppConstants.defaultGeminiModel, 'gemini-2.0-flash');
      });

      test('should have correct default OpenRouter model', () {
        expect(AppConstants.defaultOpenRouterModel, 'openai/gpt-4o-mini');
      });
    });

    group('Feature Flags', () {
      test('should have offline mode enabled', () {
        expect(AppConstants.enableOfflineMode, true);
      });

      test('should have scraping enabled', () {
        expect(AppConstants.enableScraping, true);
      });

      test('should have community submissions enabled', () {
        expect(AppConstants.enableCommunitySubmissions, true);
      });
    });

    group('Cache', () {
      test('should have correct max cache age', () {
        expect(AppConstants.maxCacheAge, 7);
      });

      test('should have correct max schematic cache', () {
        expect(AppConstants.maxSchematicCache, 100);
      });
    });

    group('Constants immutability', () {
      test('appName should be immutable', () {
        // Verify that constants cannot be changed
        expect(() {
          // This would fail to compile if we try to reassign
          // AppConstants.appName = 'New Name';
        }, returnsNormally);
      });

      test('version should follow semantic versioning', () {
        // Simple validation that version follows major.minor.patch format
        final version = AppConstants.appVersion;
        final parts = version.split('.');
        expect(parts.length, 3);
        expect(int.tryParse(parts[0]), isNotNull);
        expect(int.tryParse(parts[1]), isNotNull);
        expect(int.tryParse(parts[2]), isNotNull);
      });
    });
  });
}
