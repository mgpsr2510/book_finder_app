import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Minimal Tests', () {
    test('should pass basic assertion', () {
      expect(true, isTrue);
    });

    test('should handle numbers', () {
      expect(2 + 2, equals(4));
    });

    test('should handle strings', () {
      expect('test', contains('es'));
    });
  });
}
