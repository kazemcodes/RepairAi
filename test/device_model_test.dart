import 'package:flutter_test/flutter_test.dart';
import 'package:repair_ai/features/device_db/data/models/device_model.dart';

void main() {
  group('Device Model Tests', () {
    group('Device Creation', () {
      test('should create Device with required fields', () {
        final device = Device(
          id: '1',
          name: 'iPhone 14 Pro',
          brand: 'Apple',
          model: 'A2890',
          createdAt: DateTime(2024, 1, 1),
        );

        expect(device.id, '1');
        expect(device.name, 'iPhone 14 Pro');
        expect(device.brand, 'Apple');
        expect(device.model, 'A2890');
        expect(device.imageUrl, isNull);
        expect(device.schematics, isEmpty);
        expect(device.solutions, isEmpty);
        expect(device.specifications, isEmpty);
      });

      test('should create Device with all fields', () {
        final device = Device(
          id: '1',
          name: 'iPhone 14 Pro',
          brand: 'Apple',
          model: 'A2890',
          imageUrl: 'https://example.com/iphone14.png',
          schematics: ['schematic1.pdf', 'schematic2.pdf'],
          solutions: ['screen_repair.md', 'battery_repair.md'],
          specifications: {'screen': '6.1 inch', 'battery': '3200 mAh'},
          createdAt: DateTime(2024, 1, 1),
        );

        expect(device.id, '1');
        expect(device.name, 'iPhone 14 Pro');
        expect(device.brand, 'Apple');
        expect(device.model, 'A2890');
        expect(device.imageUrl, 'https://example.com/iphone14.png');
        expect(device.schematics.length, 2);
        expect(device.solutions.length, 2);
        expect(device.specifications['screen'], '6.1 inch');
      });

      test('should have default empty lists and maps', () {
        final device = Device(
          id: '1',
          name: 'Test Device',
          brand: 'Test',
          model: 'T1',
          createdAt: DateTime.now(),
        );

        expect(device.schematics, equals([]));
        expect(device.solutions, equals([]));
        expect(device.specifications, equals({}));
      });
    });

    group('Device.fromJson', () {
      test('should parse JSON with all fields', () {
        final json = {
          'id': '1',
          'name': 'iPhone 14 Pro',
          'brand': 'Apple',
          'model': 'A2890',
          'image_url': 'https://example.com/iphone14.png',
          'schematics': ['schematic1.pdf', 'schematic2.pdf'],
          'solutions': ['screen_repair.md'],
          'specifications': {'screen': '6.1 inch'},
          'created_at': '2024-01-01T00:00:00.000',
        };

        final device = Device.fromJson(json);

        expect(device.id, '1');
        expect(device.name, 'iPhone 14 Pro');
        expect(device.brand, 'Apple');
        expect(device.model, 'A2890');
        expect(device.imageUrl, 'https://example.com/iphone14.png');
        expect(device.schematics, ['schematic1.pdf', 'schematic2.pdf']);
        expect(device.solutions, ['screen_repair.md']);
        expect(device.specifications, {'screen': '6.1 inch'});
        expect(device.createdAt, DateTime(2024, 1, 1));
      });

      test('should handle missing optional fields', () {
        final json = {
          'id': '1',
          'name': 'iPhone 14 Pro',
          'brand': 'Apple',
          'model': 'A2890',
        };

        final device = Device.fromJson(json);

        expect(device.id, '1');
        expect(device.imageUrl, isNull);
        expect(device.schematics, isEmpty);
        expect(device.solutions, isEmpty);
        expect(device.specifications, isEmpty);
      });

      test('should handle null values in JSON', () {
        final json = <String, dynamic>{
          'id': null,
          'name': null,
          'brand': null,
          'model': null,
          'image_url': null,
          'schematics': null,
          'solutions': null,
          'specifications': null,
          'created_at': null,
        };

        final device = Device.fromJson(json);

        expect(device.id, '');
        expect(device.name, '');
        expect(device.brand, '');
        expect(device.model, '');
        expect(device.createdAt, isNotNull); // Falls back to DateTime.now()
      });
    });

    group('Device.toJson', () {
      test('should serialize Device to JSON', () {
        final device = Device(
          id: '1',
          name: 'iPhone 14 Pro',
          brand: 'Apple',
          model: 'A2890',
          imageUrl: 'https://example.com/iphone14.png',
          schematics: ['schematic1.pdf'],
          solutions: ['screen_repair.md'],
          specifications: {'screen': '6.1 inch'},
          createdAt: DateTime(2024, 1, 1),
        );

        final json = device.toJson();

        expect(json['id'], '1');
        expect(json['name'], 'iPhone 14 Pro');
        expect(json['brand'], 'Apple');
        expect(json['model'], 'A2890');
        expect(json['image_url'], 'https://example.com/iphone14.png');
        expect(json['schematics'], ['schematic1.pdf']);
        expect(json['solutions'], ['screen_repair.md']);
        expect(json['specifications'], {'screen': '6.1 inch'});
        expect(json['created_at'], '2024-01-01T00:00:00.000');
      });

      test('should handle null imageUrl', () {
        final device = Device(
          id: '1',
          name: 'Test',
          brand: 'Test',
          model: 'T1',
          createdAt: DateTime(2024, 1, 1),
        );

        final json = device.toJson();

        expect(json['image_url'], isNull);
        expect(json['schematics'], isEmpty);
        expect(json['solutions'], isEmpty);
        expect(json['specifications'], isEmpty);
      });
    });

    group('Round-trip JSON serialization', () {
      test('should preserve data through toJson and fromJson', () {
        final original = Device(
          id: '1',
          name: 'iPhone 14 Pro',
          brand: 'Apple',
          model: 'A2890',
          imageUrl: 'https://example.com/iphone14.png',
          schematics: ['schematic1.pdf', 'schematic2.pdf'],
          solutions: ['screen_repair.md', 'battery_repair.md'],
          specifications: {'screen': '6.1 inch', 'battery': '3200 mAh'},
          createdAt: DateTime(2024, 1, 1),
        );

        final json = original.toJson();
        final restored = Device.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.name, original.name);
        expect(restored.brand, original.brand);
        expect(restored.model, original.model);
        expect(restored.imageUrl, original.imageUrl);
        expect(restored.schematics, original.schematics);
        expect(restored.solutions, original.solutions);
        expect(restored.specifications, original.specifications);
      });
    });
  });

  group('Part Model Tests', () {
    group('Part Creation', () {
      test('should create Part with required fields', () {
        final part = Part(
          id: 'p1',
          deviceId: 'd1',
          name: 'Screen',
          partNumber: 'ABC123',
        );

        expect(part.id, 'p1');
        expect(part.deviceId, 'd1');
        expect(part.name, 'Screen');
        expect(part.partNumber, 'ABC123');
        expect(part.compatibleModels, isNull);
        expect(part.price, isNull);
        expect(part.supplier, isNull);
        expect(part.imageUrl, isNull);
        expect(part.isOriginal, false);
      });

      test('should create Part with all fields', () {
        final part = Part(
          id: 'p1',
          deviceId: 'd1',
          name: 'Screen',
          partNumber: 'ABC123',
          compatibleModels: 'iPhone 14, iPhone 14 Pro',
          price: 150.00,
          supplier: 'Apple',
          imageUrl: 'https://example.com/screen.png',
          isOriginal: true,
        );

        expect(part.id, 'p1');
        expect(part.compatibleModels, 'iPhone 14, iPhone 14 Pro');
        expect(part.price, 150.00);
        expect(part.supplier, 'Apple');
        expect(part.imageUrl, 'https://example.com/screen.png');
        expect(part.isOriginal, true);
      });
    });

    group('Part.fromJson', () {
      test('should parse JSON with all fields', () {
        final json = {
          'id': 'p1',
          'device_id': 'd1',
          'name': 'Screen',
          'part_number': 'ABC123',
          'compatible_models': 'iPhone 14, iPhone 14 Pro',
          'price': 150.00,
          'supplier': 'Apple',
          'image_url': 'https://example.com/screen.png',
          'is_original': true,
        };

        final part = Part.fromJson(json);

        expect(part.id, 'p1');
        expect(part.deviceId, 'd1');
        expect(part.name, 'Screen');
        expect(part.partNumber, 'ABC123');
        expect(part.compatibleModels, 'iPhone 14, iPhone 14 Pro');
        expect(part.price, 150.00);
        expect(part.supplier, 'Apple');
        expect(part.imageUrl, 'https://example.com/screen.png');
        expect(part.isOriginal, true);
      });

      test('should handle missing optional fields', () {
        final json = {
          'id': 'p1',
          'device_id': 'd1',
          'name': 'Screen',
          'part_number': 'ABC123',
        };

        final part = Part.fromJson(json);

        expect(part.compatibleModels, isNull);
        expect(part.price, isNull);
        expect(part.supplier, isNull);
        expect(part.imageUrl, isNull);
        expect(part.isOriginal, false);
      });

      test('should handle null price as double', () {
        final json = {
          'id': 'p1',
          'device_id': 'd1',
          'name': 'Screen',
          'part_number': 'ABC123',
          'price': null,
        };

        final part = Part.fromJson(json);

        expect(part.price, isNull);
      });
    });

    group('Part.toJson', () {
      test('should serialize Part to JSON', () {
        final part = Part(
          id: 'p1',
          deviceId: 'd1',
          name: 'Screen',
          partNumber: 'ABC123',
          compatibleModels: 'iPhone 14',
          price: 150.00,
          supplier: 'Apple',
          imageUrl: 'https://example.com/screen.png',
          isOriginal: true,
        );

        final json = part.toJson();

        expect(json['id'], 'p1');
        expect(json['device_id'], 'd1');
        expect(json['name'], 'Screen');
        expect(json['part_number'], 'ABC123');
        expect(json['compatible_models'], 'iPhone 14');
        expect(json['price'], 150.00);
        expect(json['supplier'], 'Apple');
        expect(json['image_url'], 'https://example.com/screen.png');
        expect(json['is_original'], true);
      });
    });

    group('Round-trip JSON serialization', () {
      test('should preserve data through toJson and fromJson', () {
        final original = Part(
          id: 'p1',
          deviceId: 'd1',
          name: 'Screen',
          partNumber: 'ABC123',
          compatibleModels: 'iPhone 14',
          price: 150.00,
          supplier: 'Apple',
          imageUrl: 'https://example.com/screen.png',
          isOriginal: true,
        );

        final json = original.toJson();
        final restored = Part.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.deviceId, original.deviceId);
        expect(restored.name, original.name);
        expect(restored.partNumber, original.partNumber);
        expect(restored.compatibleModels, original.compatibleModels);
        expect(restored.price, original.price);
        expect(restored.supplier, original.supplier);
        expect(restored.imageUrl, original.imageUrl);
        expect(restored.isOriginal, original.isOriginal);
      });
    });
  });
}
