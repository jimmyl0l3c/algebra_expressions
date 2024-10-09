import 'package:algebra_lib/algebra_lib.dart';
import 'package:algebra_lib/src/utils/exp_utils.dart';
import 'package:test/test.dart';

import 'utils/scalar_provider.dart';

void main() {
  // TODO: test error states
  group('Multiply', () {
    final testVectors = [
      Vector(items: [
        ScalarProvider.get(1),
        ScalarProvider.get(2),
        ScalarProvider.get(3),
      ]),
      Vector(items: [
        ScalarProvider.get(4),
        ScalarProvider.get(5),
        ScalarProvider.get(6),
        ScalarProvider.get(7),
      ]),
    ];

    setUp(() {});

    final scalarByScalarParams = [
      [ScalarProvider.get(2), ScalarProvider.get(3), ScalarProvider.get(6)],
      [ScalarProvider.get(-4), ScalarProvider.get(5), ScalarProvider.get(-20)],
      [ScalarProvider.get(7), ScalarProvider.get(-1), ScalarProvider.get(-7)],
      [ScalarProvider.get(-2), ScalarProvider.get(-9), ScalarProvider.get(18)],
    ];
    for (var params in scalarByScalarParams) {
      test('Scalars: ${params[0]} * (${params[1]})', () {
        Expression multiply = Multiply(left: params[0], right: params[1]);

        var result = simplifyAsMuchAsPossible(multiply);

        expect(result, params[2]);
      }, tags: ['scalar', 'multiply']);
    }

    final vectorByScalarParams = [
      [
        ScalarProvider.get(2),
        testVectors[0],
        Vector(items: [
          ScalarProvider.get(2),
          ScalarProvider.get(4),
          ScalarProvider.get(6),
        ]),
      ],
      [
        ScalarProvider.get(-4),
        testVectors[0],
        Vector(items: [
          ScalarProvider.get(-4),
          ScalarProvider.get(-8),
          ScalarProvider.get(-12),
        ]),
      ],
      [
        testVectors[0],
        ScalarProvider.get(3),
        Vector(items: [
          ScalarProvider.get(3),
          ScalarProvider.get(6),
          ScalarProvider.get(9),
        ]),
      ],
      [
        testVectors[0],
        ScalarProvider.get(-1),
        Vector(items: [
          ScalarProvider.get(-1),
          ScalarProvider.get(-2),
          ScalarProvider.get(-3),
        ]),
      ],
    ];
    for (var params in vectorByScalarParams) {
      test('Vector by scalar: ${params[0]} * (${params[1]})', () {
        Expression multiply = Multiply(left: params[0], right: params[1]);

        var result = simplifyAsMuchAsPossible(multiply);

        expect(result, params[2]);
      }, tags: ['scalar', 'vector', 'multiply']);
    }
  });
}
