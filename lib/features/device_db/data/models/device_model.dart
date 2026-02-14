/// Device model entity
class Device {
  final String id;
  final String name;
  final String brand;
  final String model;
  final String? imageUrl;
  final List<String> schematics;
  final List<String> solutions;
  final Map<String, String> specifications;
  final DateTime createdAt;

  Device({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    this.imageUrl,
    this.schematics = const [],
    this.solutions = const [],
    this.specifications = const {},
    required this.createdAt,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      imageUrl: json['image_url'],
      schematics: json['schematics'] != null 
          ? List<String>.from(json['schematics']) 
          : [],
      solutions: json['solutions'] != null 
          ? List<String>.from(json['solutions']) 
          : [],
      specifications: json['specifications'] != null 
          ? Map<String, String>.from(json['specifications']) 
          : {},
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'model': model,
      'image_url': imageUrl,
      'schematics': schematics,
      'solutions': solutions,
      'specifications': specifications,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Parts model
class Part {
  final String id;
  final String deviceId;
  final String name;
  final String partNumber;
  final String? compatibleModels;
  final double? price;
  final String? supplier;
  final String? imageUrl;
  final bool isOriginal;

  Part({
    required this.id,
    required this.deviceId,
    required this.name,
    required this.partNumber,
    this.compatibleModels,
    this.price,
    this.supplier,
    this.imageUrl,
    this.isOriginal = false,
  });

  factory Part.fromJson(Map<String, dynamic> json) {
    return Part(
      id: json['id'] ?? '',
      deviceId: json['device_id'] ?? '',
      name: json['name'] ?? '',
      partNumber: json['part_number'] ?? '',
      compatibleModels: json['compatible_models'],
      price: json['price']?.toDouble(),
      supplier: json['supplier'],
      imageUrl: json['image_url'],
      isOriginal: json['is_original'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_id': deviceId,
      'name': name,
      'part_number': partNumber,
      'compatible_models': compatibleModels,
      'price': price,
      'supplier': supplier,
      'image_url': imageUrl,
      'is_original': isOriginal,
    };
  }
}
