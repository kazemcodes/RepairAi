import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'settings_service.dart';

/// AI Model types
enum AIModel {
  gemini('gemini', 'Google Gemini'),
  openRouter('openrouter', 'OpenRouter');

  final String id;
  final String displayName;

  const AIModel(this.id, this.displayName);
}

/// AI service for handling AI API calls
class AIService {
  final SettingsService _settingsService;
  final http.Client _httpClient;

  AIService(this._settingsService, this._httpClient);

  /// Send a message to AI and get response
  Future<String> sendMessage(String message, {List<Map<String, String>>? history}) async {
    final model = await _settingsService.getDefaultModel();
    
    if (model.startsWith('gemini')) {
      return _sendToGemini(message, history: history);
    } else {
      return _sendToOpenRouter(message, history: history);
    }
  }

  /// Send message to Google Gemini
  Future<String> _sendToGemini(String message, {List<Map<String, String>>? history}) async {
    final apiKey = await _settingsService.getGeminiApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Gemini API key not configured');
    }

    final model = await _settingsService.getDefaultModel();
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey'
    );

    // Build conversation history
    final List<Map<String, dynamic>> contents = [];
    
    if (history != null) {
      for (final msg in history) {
        contents.add({
          'role': msg['role'] == 'user' ? 'user' : 'model',
          'parts': [{'text': msg['content']}],
        });
      }
    }
    
    contents.add({
      'role': 'user',
      'parts': [{'text': message}],
    });

    final response = await _httpClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'contents': contents}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? 'No response';
    } else {
      throw Exception('Gemini API error: ${response.statusCode} - ${response.body}');
    }
  }

  /// Send message to OpenRouter
  Future<String> _sendToOpenRouter(String message, {List<Map<String, String>>? history}) async {
    final apiKey = await _settingsService.getOpenRouterApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('OpenRouter API key not configured');
    }

    final model = await _settingsService.getDefaultModel();
    final url = Uri.parse('https://openrouter.ai/api/v1/chat/completions');

    // Build messages
    final List<Map<String, dynamic>> messages = [
      {
        'role': 'system',
        'content': 'You are RepairAI, an AI assistant for mobile repair technicians. You help with device repair problems, solutions, and technical questions. Be helpful, technical, and concise.'
      }
    ];

    if (history != null) {
      messages.addAll(history.map((msg) => {
        'role': msg['role'],
        'content': msg['content'],
      }));
    }

    messages.add({'role': 'user', 'content': message});

    final response = await _httpClient.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
        'HTTP-Referer': 'https://repairai.app',
        'X-Title': 'RepairAI',
      },
      body: jsonEncode({
        'model': model,
        'messages': messages,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices']?[0]?['message']?['content'] ?? 'No response';
    } else {
      throw Exception('OpenRouter API error: ${response.statusCode} - ${response.body}');
    }
  }

  /// Stream messages from AI (for real-time response)
  Stream<String> sendMessageStream(String message, {List<Map<String, String>>? history}) async* {
    // For now, just yield the complete response
    // Can be extended for proper streaming
    final response = await sendMessage(message, history: history);
    yield response;
  }

  /// Generate AI index for solution images
  Future<String> generateImageIndex(String imageUrl, String context) async {
    final prompt = '''
Analyze this repair solution image and provide:
1. A brief description of what's shown
2. Key components visible
3. Technical details that can be indexed

Context: $context

Provide a detailed index description.
''';

    return sendMessage(prompt);
  }
}

/// AI service provider
final aiServiceProvider = Provider<AIService>((ref) {
  final settingsService = ref.watch(settingsServiceProvider);
  return AIService(settingsService, http.Client());
});
