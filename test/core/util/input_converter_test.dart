import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_and_tdd/core/presentation/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  final converter = InputConverter();
  test(
      'should return an integer when the string represents an unsigned integer',
      () async {
    final str = '123';
    final result = converter.stringToUnsignedInteger(str);
    expect(result, Right(123));
  });
  test('should return a failure when the string is not an integer', () async {
    final str = 'abc';
    final result = converter.stringToUnsignedInteger(str);
    expect(result, Left(InvalidInputFailure()));
  });
  test('should return a failure when the string is a negative integer',
      () async {
    final str = '-123';
    final result = converter.stringToUnsignedInteger(str);
    expect(result, Left(InvalidInputFailure()));
  });
}
