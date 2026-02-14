/// Repair guide entity
class RepairGuide {
  final String id;
  final String title;
  final String deviceModel;
  final String brand;
  final String problem;
  final String difficulty;
  final int estimatedTime; // in minutes
  final List<String> tools;
  final List<String> parts;
  final List<GuideStep> steps;
  final List<String> warnings;
  final int successRate;
  final int viewCount;
  final String createdBy;
  final DateTime createdAt;

  RepairGuide({
    required this.id,
    required this.title,
    required this.deviceModel,
    required this.brand,
    required this.problem,
    required this.difficulty,
    required this.estimatedTime,
    this.tools = const [],
    this.parts = const [],
    this.steps = const [],
    this.warnings = const [],
    this.successRate = 0,
    this.viewCount = 0,
    required this.createdBy,
    required this.createdAt,
  });

  factory RepairGuide.fromJson(Map<String, dynamic> json) {
    return RepairGuide(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      deviceModel: json['device_model'] ?? '',
      brand: json['brand'] ?? '',
      problem: json['problem'] ?? '',
      difficulty: json['difficulty'] ?? 'medium',
      estimatedTime: json['estimated_time'] ?? 0,
      tools: json['tools'] != null ? List<String>.from(json['tools']) : [],
      parts: json['parts'] != null ? List<String>.from(json['parts']) : [],
      steps: json['steps'] != null 
          ? (json['steps'] as List).map((s) => GuideStep.fromJson(s)).toList() 
          : [],
      warnings: json['warnings'] != null ? List<String>.from(json['warnings']) : [],
      successRate: json['success_rate'] ?? 0,
      viewCount: json['view_count'] ?? 0,
      createdBy: json['created_by'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'device_model': deviceModel,
      'brand': brand,
      'problem': problem,
      'difficulty': difficulty,
      'estimated_time': estimatedTime,
      'tools': tools,
      'parts': parts,
      'steps': steps.map((s) => s.toJson()).toList(),
      'warnings': warnings,
      'success_rate': successRate,
      'view_count': viewCount,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Individual step in a repair guide
class GuideStep {
  final int stepNumber;
  final String title;
  final String description;
  final String? imageUrl;
  final String? tip;
  final int? timeEstimate;

  GuideStep({
    required this.stepNumber,
    required this.title,
    required this.description,
    this.imageUrl,
    this.tip,
    this.timeEstimate,
  });

  factory GuideStep.fromJson(Map<String, dynamic> json) {
    return GuideStep(
      stepNumber: json['step_number'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'],
      tip: json['tip'],
      timeEstimate: json['time_estimate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'step_number': stepNumber,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'tip': tip,
      'time_estimate': timeEstimate,
    };
  }
}
