import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Basic test to verify test environment', () {
    expect(1 + 1, equals(2));
  });

  test('String test', () {
    expect('hello', equals('hello'));
  });

  test('List test', () {
    final list = [1, 2, 3];
    expect(list.length, equals(3));
    expect(list.first, equals(1));
  });
}
