import 'package:blogify/core/utils/calculate_reading_time.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('calculateReadingTime', () {
    test('should return 1 minute for short content (less than 225 words)', () {
      const content = 'This is a short blog post with just a few words.';
      final result = calculateReadingTime(content);
      expect(result, 1);
    });

    test('should return 1 minute for exactly 225 words', () {
      final content = List.generate(225, (i) => 'word').join(' ');
      final result = calculateReadingTime(content);
      expect(result, 1);
    });

    test('should return 2 minutes for 226-450 words', () {
      final content = List.generate(300, (i) => 'word').join(' ');
      final result = calculateReadingTime(content);
      expect(result, 2);
    });

    test('should return 5 minutes for ~1000 words', () {
      final content = List.generate(1000, (i) => 'word').join(' ');
      final result = calculateReadingTime(content);
      expect(result, 5);
    });

    test('should handle empty content', () {
      const content = '';
      final result = calculateReadingTime(content);
      expect(result, 1);
    });

    test('should handle content with multiple spaces', () {
      const content = 'word1    word2     word3';
      final result = calculateReadingTime(content);
      expect(result, 1);
    });

    test('should handle content with newlines', () {
      const content = 'word1\nword2\nword3\nword4';
      final result = calculateReadingTime(content);
      expect(result, 1);
    });
  });
}
