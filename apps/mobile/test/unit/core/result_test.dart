import 'package:flutter_test/flutter_test.dart';
import 'package:aura_mobile/core/errors/failures.dart';
import 'package:aura_mobile/core/utils/result.dart';

void main() {
  group('Result Monad', () {
    test('Result.ok creates an Ok instance with correct data', () {
      const result = Result.ok('success_data');

      expect(result.isOk, isTrue);
      expect(result.isErr, isFalse);
      expect(result.valueOrNull, equals('success_data'));
      expect(result.failureOrNull, isNull);
    });

    test('Result.err creates an Err instance with correct failure', () {
      const failure = CameraFailure(message: 'Camera permission denied');
      const result = Result<String>.err(failure);

      expect(result.isOk, isFalse);
      expect(result.isErr, isTrue);
      expect(result.valueOrNull, isNull);
      expect(result.failureOrNull, equals(failure));
    });

    test('fold applies onOk on Ok instance and onErr on Err instance', () {
      const okResult = Result.ok(42);
      final foldedOk = okResult.fold((data) => 'Value: $data', (err) => 'Error');
      expect(foldedOk, equals('Value: 42'));

      const errResult = Result<int>.err(StorageFailure(message: 'Disk full'));
      final foldedErr = errResult.fold((data) => 'Value: $data', (err) => err.message);
      expect(foldedErr, equals('Disk full'));
    });

    test('map transforms value of Ok and preserves Err', () {
      const okResult = Result.ok(10);
      final mapped = okResult.map((v) => v * 2);
      expect(mapped.valueOrNull, equals(20));

      const errResult = Result<int>.err(ARSessionFailure(message: 'Session lost'));
      final mappedErr = errResult.map((v) => v * 2);
      expect(mappedErr.isErr, isTrue);
      expect(mappedErr.failureOrNull?.message, equals('Session lost'));
    });
  });
}
