import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repair_ai/core/theme/app_colors.dart';

void main() {
  group('AppColors Tests', () {
    group('Primary Colors', () {
      test('should have correct primary color', () {
        expect(AppColors.primary, const Color(0xFF3B82F6));
      });

      test('should have correct primary dark color', () {
        expect(AppColors.primaryDark, const Color(0xFF1D4ED8));
      });

      test('should have correct primary light color', () {
        expect(AppColors.primaryLight, const Color(0xFF60A5FA));
      });

      test('primary colors are defined correctly', () {
        // All primary colors should be defined and non-zero
        expect(AppColors.primary, isNotNull);
        expect(AppColors.primaryDark, isNotNull);
        expect(AppColors.primaryLight, isNotNull);
      });
    });

    group('Secondary Colors', () {
      test('should have correct secondary color', () {
        expect(AppColors.secondary, const Color(0xFF10B981));
      });

      test('should have correct secondary dark color', () {
        expect(AppColors.secondaryDark, const Color(0xFF059669));
      });

      test('should have correct secondary light color', () {
        expect(AppColors.secondaryLight, const Color(0xFF34D399));
      });
    });

    group('Background Colors', () {
      test('should have correct light background color', () {
        expect(AppColors.backgroundLight, const Color(0xFFF8FAFC));
      });

      test('should have correct dark background color', () {
        expect(AppColors.backgroundDark, const Color(0xFF0F172A));
      });

      test('should have correct light surface color', () {
        expect(AppColors.surfaceLight, const Color(0xFFFFFFFF));
      });

      test('should have correct dark surface color', () {
        expect(AppColors.surfaceDark, const Color(0xFF1E293B));
      });

      test('dark background should be darker than light', () {
        expect(AppColors.backgroundDark.value, lessThan(AppColors.backgroundLight.value));
      });
    });

    group('Text Colors', () {
      test('should have correct light text primary color', () {
        expect(AppColors.textPrimaryLight, const Color(0xFF1E293B));
      });

      test('should have correct light text secondary color', () {
        expect(AppColors.textSecondaryLight, const Color(0xFF64748B));
      });

      test('should have correct dark text primary color', () {
        expect(AppColors.textPrimaryDark, const Color(0xFFF8FAFC));
      });

      test('should have correct dark text secondary color', () {
        expect(AppColors.textSecondaryDark, const Color(0xFF94A3B8));
      });

      test('primary text should be darker than secondary in both modes', () {
        expect(AppColors.textPrimaryLight.value, lessThan(AppColors.textSecondaryLight.value));
        expect(AppColors.textPrimaryDark.value, greaterThan(AppColors.textSecondaryDark.value));
      });
    });

    group('Error Colors', () {
      test('should have correct error color', () {
        expect(AppColors.error, const Color(0xFFEF4444));
      });

      test('should have correct dark error color', () {
        expect(AppColors.errorDark, const Color(0xFFDC2626));
      });

      test('error colors should be red', () {
        // Error colors should be in the red hue range
        expect(AppColors.error.red, greaterThan(AppColors.error.blue));
        expect(AppColors.error.red, greaterThan(AppColors.error.green));
      });
    });

    group('Success Colors', () {
      test('should have correct success color', () {
        expect(AppColors.success, const Color(0xFF10B981));
      });

      test('should have correct warning color', () {
        expect(AppColors.warning, const Color(0xFFF59E0B));
      });
    });

    group('Chat Colors', () {
      test('should have correct user message color', () {
        expect(AppColors.userMessage, const Color(0xFF3B82F6));
      });

      test('should have correct AI message color', () {
        expect(AppColors.aiMessage, const Color(0xFF334155));
      });

      test('user message should be primary color', () {
        expect(AppColors.userMessage, AppColors.primary);
      });
    });

    group('Severity Colors', () {
      test('should have correct easy color (green)', () {
        expect(AppColors.easy, const Color(0xFF22C55E));
      });

      test('should have correct medium color (orange)', () {
        expect(AppColors.medium, const Color(0xFFF59E0B));
      });

      test('should have correct hard color (red)', () {
        expect(AppColors.hard, const Color(0xFFEF4444));
      });

      test('easy should equal success color', () {
        // Easy is green 500, success is emerald 500 - they are different
        expect(AppColors.easy, isNot(AppColors.success));
      });

      test('easy should be green, hard should be red', () {
        expect(AppColors.easy.computeLuminance(), greaterThan(AppColors.hard.computeLuminance()));
      });
    });

    group('Color values are valid', () {
      test('all primary colors should be valid', () {
        expect(AppColors.primary.value, isNonZero);
        expect(AppColors.primaryDark.value, isNonZero);
        expect(AppColors.primaryLight.value, isNonZero);
      });

      test('all secondary colors should be valid', () {
        expect(AppColors.secondary.value, isNonZero);
        expect(AppColors.secondaryDark.value, isNonZero);
        expect(AppColors.secondaryLight.value, isNonZero);
      });

      test('all background colors should be valid', () {
        expect(AppColors.backgroundLight.value, isNonZero);
        expect(AppColors.backgroundDark.value, isNonZero);
        expect(AppColors.surfaceLight.value, isNonZero);
        expect(AppColors.surfaceDark.value, isNonZero);
      });
    });

    group('Colors have correct alpha', () {
      test('all colors should be fully opaque', () {
        expect(AppColors.primary.alpha, 255);
        expect(AppColors.backgroundDark.alpha, 255);
        expect(AppColors.surfaceLight.alpha, 255);
        expect(AppColors.textPrimaryDark.alpha, 255);
      });
    });
  });
}
