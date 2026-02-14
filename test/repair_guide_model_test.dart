import 'package:flutter_test/flutter_test.dart';
import 'package:repair_ai/features/repair_guides/data/models/repair_guide.dart';

void main() {
  group('RepairGuide Model Tests', () {
    group('RepairGuide Creation', () {
      test('should create RepairGuide with required fields', () {
        final guide = RepairGuide(
          id: 'g1',
          title: 'iPhone 14 Screen Repair',
          deviceModel: 'iPhone 14',
          brand: 'Apple',
          problem: 'Cracked screen',
          difficulty: 'medium',
          estimatedTime: 45,
          createdBy: 'user1',
          createdAt: DateTime(2024, 1, 1),
        );

        expect(guide.id, 'g1');
        expect(guide.title, 'iPhone 14 Screen Repair');
        expect(guide.deviceModel, 'iPhone 14');
        expect(guide.brand, 'Apple');
        expect(guide.problem, 'Cracked screen');
        expect(guide.difficulty, 'medium');
        expect(guide.estimatedTime, 45);
        expect(guide.tools, isEmpty);
        expect(guide.parts, isEmpty);
        expect(guide.steps, isEmpty);
        expect(guide.warnings, isEmpty);
        expect(guide.successRate, 0);
        expect(guide.viewCount, 0);
      });

      test('should create RepairGuide with all fields', () {
        final steps = [
          GuideStep(
            stepNumber: 1,
            title: 'Power off device',
            description: 'Turn off the iPhone',
            tip: 'Hold power button for 3 seconds',
            timeEstimate: 30,
          ),
        ];

        final guide = RepairGuide(
          id: 'g1',
          title: 'iPhone 14 Screen Repair',
          deviceModel: 'iPhone 14',
          brand: 'Apple',
          problem: 'Cracked screen',
          difficulty: 'medium',
          estimatedTime: 45,
          tools: ['Screwdriver', 'Pry tool', 'Suction cup'],
          parts: ['iPhone 14 screen', 'New screws'],
          steps: steps,
          warnings: ['Static electricity can damage components'],
          successRate: 95,
          viewCount: 1234,
          createdBy: 'expert_user',
          createdAt: DateTime(2024, 1, 1),
        );

        expect(guide.id, 'g1');
        expect(guide.tools.length, 3);
        expect(guide.parts.length, 2);
        expect(guide.steps.length, 1);
        expect(guide.warnings.length, 1);
        expect(guide.successRate, 95);
        expect(guide.viewCount, 1234);
        expect(guide.createdBy, 'expert_user');
      });

      test('should have default values for optional fields', () {
        final guide = RepairGuide(
          id: 'g1',
          title: 'Test',
          deviceModel: 'Test',
          brand: 'Test',
          problem: 'Test',
          difficulty: 'medium',
          estimatedTime: 30,
          createdBy: 'user1',
          createdAt: DateTime.now(),
        );

        expect(guide.tools, equals([]));
        expect(guide.parts, equals([]));
        expect(guide.steps, equals([]));
        expect(guide.warnings, equals([]));
        expect(guide.successRate, 0);
        expect(guide.viewCount, 0);
      });
    });

    group('RepairGuide.fromJson', () {
      test('should parse JSON with all fields', () {
        final json = {
          'id': 'g1',
          'title': 'iPhone 14 Screen Repair',
          'device_model': 'iPhone 14',
          'brand': 'Apple',
          'problem': 'Cracked screen',
          'difficulty': 'hard',
          'estimated_time': 60,
          'tools': ['Screwdriver', 'Pry tool'],
          'parts': ['New screen'],
          'steps': [
            {
              'step_number': 1,
              'title': 'Power off',
              'description': 'Turn off device',
              'image_url': 'https://example.com/step1.png',
              'tip': 'Be careful',
              'time_estimate': 30,
            }
          ],
          'warnings': ['Warning 1'],
          'success_rate': 90,
          'view_count': 500,
          'created_by': 'user1',
          'created_at': '2024-01-01T00:00:00.000',
        };

        final guide = RepairGuide.fromJson(json);

        expect(guide.id, 'g1');
        expect(guide.title, 'iPhone 14 Screen Repair');
        expect(guide.deviceModel, 'iPhone 14');
        expect(guide.brand, 'Apple');
        expect(guide.problem, 'Cracked screen');
        expect(guide.difficulty, 'hard');
        expect(guide.estimatedTime, 60);
        expect(guide.tools, ['Screwdriver', 'Pry tool']);
        expect(guide.parts, ['New screen']);
        expect(guide.steps.length, 1);
        expect(guide.warnings, ['Warning 1']);
        expect(guide.successRate, 90);
        expect(guide.viewCount, 500);
        expect(guide.createdBy, 'user1');
        expect(guide.createdAt, DateTime(2024, 1, 1));
      });

      test('should handle missing optional fields', () {
        final json = {
          'id': 'g1',
          'title': 'iPhone 14 Screen Repair',
          'device_model': 'iPhone 14',
          'brand': 'Apple',
          'problem': 'Cracked screen',
          'created_by': 'user1',
        };

        final guide = RepairGuide.fromJson(json);

        expect(guide.difficulty, 'medium');
        expect(guide.estimatedTime, 0);
        expect(guide.tools, isEmpty);
        expect(guide.parts, isEmpty);
        expect(guide.steps, isEmpty);
        expect(guide.warnings, isEmpty);
        expect(guide.successRate, 0);
        expect(guide.viewCount, 0);
      });

      test('should handle null values', () {
        final json = <String, dynamic>{
          'id': null,
          'title': null,
          'device_model': null,
          'brand': null,
          'problem': null,
          'difficulty': null,
          'estimated_time': null,
          'tools': null,
          'parts': null,
          'steps': null,
          'warnings': null,
          'success_rate': null,
          'view_count': null,
          'created_by': null,
          'created_at': null,
        };

        final guide = RepairGuide.fromJson(json);

        expect(guide.id, '');
        expect(guide.title, '');
        expect(guide.difficulty, 'medium');
        expect(guide.createdAt, isNotNull);
      });
    });

    group('RepairGuide.toJson', () {
      test('should serialize RepairGuide to JSON', () {
        final guide = RepairGuide(
          id: 'g1',
          title: 'iPhone 14 Screen Repair',
          deviceModel: 'iPhone 14',
          brand: 'Apple',
          problem: 'Cracked screen',
          difficulty: 'easy',
          estimatedTime: 30,
          tools: ['Screwdriver'],
          parts: ['Screen'],
          steps: [
            GuideStep(
              stepNumber: 1,
              title: 'Test',
              description: 'Test step',
            ),
          ],
          warnings: ['Warning'],
          successRate: 85,
          viewCount: 100,
          createdBy: 'user1',
          createdAt: DateTime(2024, 1, 1),
        );

        final json = guide.toJson();

        expect(json['id'], 'g1');
        expect(json['title'], 'iPhone 14 Screen Repair');
        expect(json['device_model'], 'iPhone 14');
        expect(json['brand'], 'Apple');
        expect(json['problem'], 'Cracked screen');
        expect(json['difficulty'], 'easy');
        expect(json['estimated_time'], 30);
        expect(json['tools'], ['Screwdriver']);
        expect(json['parts'], ['Screen']);
        expect(json['steps'], isA<List>());
        expect(json['warnings'], ['Warning']);
        expect(json['success_rate'], 85);
        expect(json['view_count'], 100);
        expect(json['created_by'], 'user1');
        expect(json['created_at'], '2024-01-01T00:00:00.000');
      });
    });

    group('Round-trip JSON serialization', () {
      test('should preserve data through toJson and fromJson', () {
        final original = RepairGuide(
          id: 'g1',
          title: 'iPhone 14 Screen Repair',
          deviceModel: 'iPhone 14',
          brand: 'Apple',
          problem: 'Cracked screen',
          difficulty: 'medium',
          estimatedTime: 45,
          tools: ['Screwdriver', 'Pry tool'],
          parts: ['New screen'],
          steps: [
            GuideStep(
              stepNumber: 1,
              title: 'Power off',
              description: 'Turn off the device',
              tip: 'Hold power button',
              timeEstimate: 30,
            ),
            GuideStep(
              stepNumber: 2,
              title: 'Remove screws',
              description: 'Use pentalobe screwdriver',
              imageUrl: 'https://example.com/screws.png',
            ),
          ],
          warnings: ['Static electricity', 'Fragile connectors'],
          successRate: 95,
          viewCount: 1234,
          createdBy: 'expert_user',
          createdAt: DateTime(2024, 1, 1),
        );

        final json = original.toJson();
        final restored = RepairGuide.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.title, original.title);
        expect(restored.deviceModel, original.deviceModel);
        expect(restored.brand, original.brand);
        expect(restored.problem, original.problem);
        expect(restored.difficulty, original.difficulty);
        expect(restored.estimatedTime, original.estimatedTime);
        expect(restored.tools, original.tools);
        expect(restored.parts, original.parts);
        expect(restored.steps.length, original.steps.length);
        expect(restored.warnings, original.warnings);
        expect(restored.successRate, original.successRate);
        expect(restored.viewCount, original.viewCount);
        expect(restored.createdBy, original.createdBy);
      });
    });
  });

  group('GuideStep Model Tests', () {
    group('GuideStep Creation', () {
      test('should create GuideStep with required fields', () {
        final step = GuideStep(
          stepNumber: 1,
          title: 'Power off',
          description: 'Turn off the device',
        );

        expect(step.stepNumber, 1);
        expect(step.title, 'Power off');
        expect(step.description, 'Turn off the device');
        expect(step.imageUrl, isNull);
        expect(step.tip, isNull);
        expect(step.timeEstimate, isNull);
      });

      test('should create GuideStep with all fields', () {
        final step = GuideStep(
          stepNumber: 1,
          title: 'Power off',
          description: 'Turn off the device',
          imageUrl: 'https://example.com/step1.png',
          tip: 'Hold for 3 seconds',
          timeEstimate: 30,
        );

        expect(step.stepNumber, 1);
        expect(step.title, 'Power off');
        expect(step.description, 'Turn off the device');
        expect(step.imageUrl, 'https://example.com/step1.png');
        expect(step.tip, 'Hold for 3 seconds');
        expect(step.timeEstimate, 30);
      });
    });

    group('GuideStep.fromJson', () {
      test('should parse JSON with all fields', () {
        final json = {
          'step_number': 1,
          'title': 'Power off',
          'description': 'Turn off the device',
          'image_url': 'https://example.com/step1.png',
          'tip': 'Hold for 3 seconds',
          'time_estimate': 30,
        };

        final step = GuideStep.fromJson(json);

        expect(step.stepNumber, 1);
        expect(step.title, 'Power off');
        expect(step.description, 'Turn off the device');
        expect(step.imageUrl, 'https://example.com/step1.png');
        expect(step.tip, 'Hold for 3 seconds');
        expect(step.timeEstimate, 30);
      });

      test('should handle missing optional fields', () {
        final json = {
          'step_number': 1,
          'title': 'Power off',
          'description': 'Turn off the device',
        };

        final step = GuideStep.fromJson(json);

        expect(step.stepNumber, 1);
        expect(step.imageUrl, isNull);
        expect(step.tip, isNull);
        expect(step.timeEstimate, isNull);
      });

      test('should handle null values', () {
        final json = <String, dynamic>{
          'step_number': null,
          'title': null,
          'description': null,
          'image_url': null,
          'tip': null,
          'time_estimate': null,
        };

        final step = GuideStep.fromJson(json);

        expect(step.stepNumber, 0);
        expect(step.title, '');
        expect(step.description, '');
      });
    });

    group('GuideStep.toJson', () {
      test('should serialize GuideStep to JSON', () {
        final step = GuideStep(
          stepNumber: 1,
          title: 'Power off',
          description: 'Turn off the device',
          imageUrl: 'https://example.com/step1.png',
          tip: 'Hold for 3 seconds',
          timeEstimate: 30,
        );

        final json = step.toJson();

        expect(json['step_number'], 1);
        expect(json['title'], 'Power off');
        expect(json['description'], 'Turn off the device');
        expect(json['image_url'], 'https://example.com/step1.png');
        expect(json['tip'], 'Hold for 3 seconds');
        expect(json['time_estimate'], 30);
      });

      test('should handle null optional fields', () {
        final step = GuideStep(
          stepNumber: 1,
          title: 'Power off',
          description: 'Turn off the device',
        );

        final json = step.toJson();

        expect(json['image_url'], isNull);
        expect(json['tip'], isNull);
        expect(json['time_estimate'], isNull);
      });
    });

    group('Round-trip JSON serialization', () {
      test('should preserve data through toJson and fromJson', () {
        final original = GuideStep(
          stepNumber: 1,
          title: 'Power off',
          description: 'Turn off the device',
          imageUrl: 'https://example.com/step1.png',
          tip: 'Hold for 3 seconds',
          timeEstimate: 30,
        );

        final json = original.toJson();
        final restored = GuideStep.fromJson(json);

        expect(restored.stepNumber, original.stepNumber);
        expect(restored.title, original.title);
        expect(restored.description, original.description);
        expect(restored.imageUrl, original.imageUrl);
        expect(restored.tip, original.tip);
        expect(restored.timeEstimate, original.timeEstimate);
      });
    });
  });
}
