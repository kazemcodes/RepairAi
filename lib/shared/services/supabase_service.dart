import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/app_constants.dart';

/// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return SupabaseClient(
    AppConstants.supabaseUrl,
    AppConstants.supabaseAnonKey,
  );
});

/// Supabase service for database operations
class SupabaseService {
  final SupabaseClient _client;

  SupabaseService(this._client);

  // User operations
  Future<dynamic> getCurrentUser() async {
    return _client.auth.getUser();
  }

  Future<dynamic> signInWithEmail(String email, String password) async {
    return _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<dynamic> signUp(String email, String password) async {
    return _client.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // Schematics operations
  Future<List<Map<String, dynamic>>> getSchematics({
    String? deviceModel,
    String? manufacturer,
  }) async {
    var query = _client.from('schematics').select();
    
    if (deviceModel != null) {
      query = query.eq('device_model', deviceModel);
    }
    if (manufacturer != null) {
      query = query.eq('manufacturer', manufacturer);
    }
    
    return query;
  }

  Future<Map<String, dynamic>?> getSchematic(String id) async {
    return _client
        .from('schematics')
        .select()
        .eq('id', id)
        .maybeSingle();
  }

  // Solutions operations
  Future<List<Map<String, dynamic>>> searchSolutions(String query) async {
    return _client
        .from('solutions')
        .select()
        .textSearch('problem', query)
        .limit(20);
  }

  Future<List<Map<String, dynamic>>> getSolutions({
    String? deviceModel,
    String? difficulty,
  }) async {
    var query = _client.from('solutions').select();
    
    if (deviceModel != null) {
      query = query.eq('device_model', deviceModel);
    }
    if (difficulty != null) {
      query = query.eq('difficulty', difficulty);
    }
    
    return query;
  }

  Future<Map<String, dynamic>?> getSolution(String id) async {
    return _client
        .from('solutions')
        .select()
        .eq('id', id)
        .maybeSingle();
  }

  // Chat operations
  Future<List<Map<String, dynamic>>> getChatSessions(String userId) async {
    return _client
        .from('chat_sessions')
        .select()
        .eq('user_id', userId)
        .order('updated_at', ascending: false);
  }

  Future<List<Map<String, dynamic>>> getChatMessages(String sessionId) async {
    return _client
        .from('chat_messages')
        .select()
        .eq('session_id', sessionId)
        .order('created_at', ascending: true);
  }

  Future<Map<String, dynamic>> createChatSession({
    required String userId,
    required String title,
  }) async {
    return _client.from('chat_sessions').insert({
      'user_id': userId,
      'title': title,
    }).select().single();
  }

  Future<Map<String, dynamic>> createChatMessage({
    required String sessionId,
    required String role,
    required String content,
    String? model,
  }) async {
    return _client.from('chat_messages').insert({
      'session_id': sessionId,
      'role': role,
      'content': content,
      'model': model,
    }).select().single();
  }

  // Community submissions
  Future<List<Map<String, dynamic>>> getPendingSubmissions() async {
    return _client
        .from('submissions')
        .select()
        .eq('status', 'pending')
        .order('created_at', ascending: true);
  }

  Future<Map<String, dynamic>> createSubmission({
    required String type,
    required Map<String, dynamic> content,
    required String submittedBy,
  }) async {
    return _client.from('submissions').insert({
      'type': type,
      'content': content,
      'submitted_by': submittedBy,
      'status': 'pending',
    }).select().single();
  }

  Future<void> updateSubmissionStatus(String id, String status) async {
    await _client.from('submissions').update({'status': status}).eq('id', id);
  }

  // Storage operations
  // Note: File upload/download will be implemented with actual Supabase client
  Future<String> uploadFile(String bucket, String path, Uint8List bytes) async {
    // TODO: Implement with actual Supabase storage
    throw UnimplementedError('Storage upload not implemented yet');
  }

  Future<Uint8List?> downloadFile(String bucket, String path) async {
    // TODO: Implement with actual Supabase storage
    throw UnimplementedError('Storage download not implemented yet');
  }
}

/// Supabase service provider
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseService(client);
});
