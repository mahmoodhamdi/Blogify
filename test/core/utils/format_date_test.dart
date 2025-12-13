import 'package:blogify/core/utils/format_date.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatDateBydMMMYYYY', () {
    test('should format date correctly', () {
      final date = DateTime(2024, 1, 15);
      final result = formatDateBydMMMYYYY(date);
      expect(result, '15 Jan, 2024');
    });

    test('should format single digit day correctly', () {
      final date = DateTime(2024, 3, 5);
      final result = formatDateBydMMMYYYY(date);
      expect(result, '5 Mar, 2024');
    });

    test('should format December correctly', () {
      final date = DateTime(2023, 12, 25);
      final result = formatDateBydMMMYYYY(date);
      expect(result, '25 Dec, 2023');
    });

    test('should format February correctly', () {
      final date = DateTime(2024, 2, 29);
      final result = formatDateBydMMMYYYY(date);
      expect(result, '29 Feb, 2024');
    });

    test('should format last day of year correctly', () {
      final date = DateTime(2024, 12, 31);
      final result = formatDateBydMMMYYYY(date);
      expect(result, '31 Dec, 2024');
    });

    test('should format first day of year correctly', () {
      final date = DateTime(2024, 1, 1);
      final result = formatDateBydMMMYYYY(date);
      expect(result, '1 Jan, 2024');
    });
  });
}
