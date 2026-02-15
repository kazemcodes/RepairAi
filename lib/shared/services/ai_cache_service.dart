import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// AI Response Cache Service
/// Caches AI responses for common questions to improve performance
class AICacheService {
  static const String _cacheKey = 'ai_response_cache';
  static const String _cacheStatsKey = 'ai_cache_stats';
  static const int _maxCacheSize = 100; // Maximum cached responses
  static const Duration _cacheExpiry = Duration(days: 7); // Cache expiry time
  
  /// Get cached AI response
  Future<String?> getCachedResponse({
    required String deviceModel,
    required String query,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheData = prefs.getString(_cacheKey);
      
      if (cacheData == null) return null;
      
      final Map<String, dynamic> cache = jsonDecode(cacheData);
      final cacheKey = _generateCacheKey(deviceModel, query);
      
      if (!cache.containsKey(cacheKey)) return null;
      
      final cachedItem = AICacheItem.fromJson(cache[cacheKey]);
      
      // Check if cache is expired
      if (DateTime.now().difference(cachedItem.timestamp) > _cacheExpiry) {
        // Remove expired cache
        cache.remove(cacheKey);
        await prefs.setString(_cacheKey, jsonEncode(cache));
        return null;
      }
      
      // Update hit count
      await _recordCacheHit();
      
      return cachedItem.response;
    } catch (e) {
      debugPrint('Error getting cached AI response: $e');
      return null;
    }
  }
  
  /// Cache an AI response
  Future<void> cacheResponse({
    required String deviceModel,
    required String query,
    required String response,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheData = prefs.getString(_cacheKey);
      
      Map<String, dynamic> cache = cacheData != null 
          ? jsonDecode(cacheData) 
          : {};
      
      final cacheKey = _generateCacheKey(deviceModel, query);
      
      // Add new item
      cache[cacheKey] = AICacheItem(
        deviceModel: deviceModel,
        query: query,
        response: response,
        timestamp: DateTime.now(),
      ).toJson();
      
      // Check cache size and remove oldest if needed
      if (cache.length > _maxCacheSize) {
        await _pruneCache(cache);
      }
      
      await prefs.setString(_cacheKey, jsonEncode(cache));
    } catch (e) {
      debugPrint('Error caching AI response: $e');
    }
  }
  
  /// Generate a cache key
  String _generateCacheKey(String deviceModel, String query) {
    // Normalize the query for better cache hits
    final normalizedQuery = query.toLowerCase().trim();
    return '${deviceModel.toLowerCase()}_${normalizedQuery.hashCode}';
  }
  
  /// Prune old cache entries
  Future<void> _pruneCache(Map<String, dynamic> cache) async {
    // Sort by timestamp and remove oldest
    final entries = cache.entries.toList();
    entries.sort((a, b) {
      final aTime = DateTime.parse(a.value['timestamp']);
      final bTime = DateTime.parse(b.value['timestamp']);
      return aTime.compareTo(bTime);
    });
    
    // Remove oldest 20% of entries
    final removeCount = (_maxCacheSize * 0.2).floor();
    for (var i = 0; i < removeCount && i < entries.length; i++) {
      cache.remove(entries[i].key);
    }
  }
  
  /// Record cache hit for statistics
  Future<void> _recordCacheHit() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final statsData = prefs.getString(_cacheStatsKey);
      
      final stats = statsData != null 
          ? AICacheStats.fromJson(jsonDecode(statsData))
          : AICacheStats();
      
      stats.recordHit();
      
      await prefs.setString(_cacheStatsKey, jsonEncode(stats.toJson()));
    } catch (e) {
      debugPrint('Error recording cache hit: $e');
    }
  }
  
  /// Get cache statistics
  Future<AICacheStats> getCacheStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final statsData = prefs.getString(_cacheStatsKey);
      
      if (statsData == null) return AICacheStats();
      
      return AICacheStats.fromJson(jsonDecode(statsData));
    } catch (e) {
      debugPrint('Error getting cache stats: $e');
      return AICacheStats();
    }
  }
  
  /// Clear all cached responses
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
      await prefs.remove(_cacheStatsKey);
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }
  }
  
  /// Get cache size
  Future<int> getCacheSize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheData = prefs.getString(_cacheKey);
      
      if (cacheData == null) return 0;
      
      final Map<String, dynamic> cache = jsonDecode(cacheData);
      return cache.length;
    } catch (e) {
      return 0;
    }
  }
  
  /// Pre-populate cache with common queries
  Future<void> prePopulateCache(String deviceModel) async {
    final commonQueries = [
      'won\'t turn on troubleshooting',
      'not charging solution',
      'no display repair',
      'no sound fix',
      'wifi not working',
      'overheating issue',
      'battery drain fast',
      'touch not responding',
      'camera not working',
      'boot loop fix',
    ];
    
    // These will be populated on first use
    // The cache will be filled as users ask these questions
    debugPrint('Pre-population ready for $deviceModel with ${commonQueries.length} common queries');
  }
}

/// Cached AI response item
class AICacheItem {
  final String deviceModel;
  final String query;
  final String response;
  final DateTime timestamp;
  
  AICacheItem({
    required this.deviceModel,
    required this.query,
    required this.response,
    required this.timestamp,
  });
  
  factory AICacheItem.fromJson(Map<String, dynamic> json) {
    return AICacheItem(
      deviceModel: json['deviceModel'] ?? '',
      query: json['query'] ?? '',
      response: json['response'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'deviceModel': deviceModel,
      'query': query,
      'response': response,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// Cache statistics
class AICacheStats {
  int totalHits;
  int totalMisses;
  DateTime? lastReset;
  
  AICacheStats({
    this.totalHits = 0,
    this.totalMisses = 0,
    this.lastReset,
  });
  
  void recordHit() => totalHits++;
  void recordMiss() => totalMisses++;
  
  double get hitRate => (totalHits + totalMisses) > 0 
      ? totalHits / (totalHits + totalMisses) 
      : 0.0;
  
  factory AICacheStats.fromJson(Map<String, dynamic> json) {
    return AICacheStats(
      totalHits: json['totalHits'] ?? 0,
      totalMisses: json['totalMisses'] ?? 0,
      lastReset: json['lastReset'] != null 
          ? DateTime.parse(json['lastReset']) 
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'totalHits': totalHits,
      'totalMisses': totalMisses,
      'lastReset': lastReset?.toIso8601String(),
    };
  }
}

/// Pre-load service for performance optimization
class PreloadService {
  static const String _preloadStatusKey = 'preload_status';
  
  /// Pre-load data for a device model
  Future<void> preloadDeviceData(String manufacturer, String model) async {
    try {
      // This would typically:
      // 1. Pre-download schematics
      // 2. Pre-cache AI responses for common queries
      // 3. Pre-load component data
      
      debugPrint('Pre-loading data for $manufacturer $model');
      
      // Save preload status
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _preloadStatusKey,
        jsonEncode({
          'manufacturer': manufacturer,
          'model': model,
          'preloadedAt': DateTime.now().toIso8601String(),
        }),
      );
    } catch (e) {
      debugPrint('Error pre-loading device data: $e');
    }
  }
  
  /// Get pre-load status
  Future<Map<String, dynamic>?> getPreloadStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final status = prefs.getString(_preloadStatusKey);
      
      if (status == null) return null;
      
      return jsonDecode(status);
    } catch (e) {
      return null;
    }
  }
  
  /// Pre-load popular models based on usage statistics
  Future<void> preloadPopularModels(List<String> models) async {
    for (final model in models) {
      await preloadDeviceData('', model);
    }
  }
}
