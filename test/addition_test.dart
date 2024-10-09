import 'package:algebra_lib/algebra_lib.dart';
import 'package:algebra_lib/src/utils/exp_utils.dart';
import 'package:test/test.dart';

import 'utils/scalar_provider.dart';

void main() {
  group('Addition', () {
    final testVectors = [
      Vector(items: [
        ScalarProvider.get(7),
        ScalarProvider.get(3),
        ScalarProvider.get(-2),
      ]),
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
      Vector(items: [
        ScalarProvider.get(2),
        ScalarProvider.get(-1),
        ScalarProvider.get(8),
        ScalarProvider.get(-2),
      ]),
    ];

    setUp(() {});

    final scalarWithScalarParams = [
      [ScalarProvider.get(2), ScalarProvider.get(3), ScalarProvider.get(5)],
      [ScalarProvider.get(-4), ScalarProvider.get(5), ScalarProvider.get(1)],
      [ScalarProvider.get(7), ScalarProvider.get(-1), ScalarProvider.get(6)],
      [ScalarProvider.get(-2), ScalarProvider.get(-9), ScalarProvider.get(-11)],
    ];
    for (var params in scalarWithScalarParams) {
      test('Scalars: ${params[0]} + (${params[1]})', () {
        Expression add = Addition(left: params[0], right: params[1]);

        var result = simplifyAsMuchAsPossible(add);

        expect(result, params[2]);
      }, tags: ['scalar', 'addition']);
    }

    final vectorWithVectorParams = [
      [
        testVectors[0],
        testVectors[1],
        Vector(items: [
          ScalarProvider.get(8),
          ScalarProvider.get(5),
          ScalarProvider.get(1),
        ])
      ],
      [
        testVectors[2],
        testVectors[3],
        Vector(items: [
          ScalarProvider.get(6),
          ScalarProvider.get(4),
          ScalarProvider.get(14),
          ScalarProvider.get(5),
        ])
      ],
    ];
    for (var params in vectorWithVectorParams) {
      test('Vectors: ${params[0]} + (${params[1]})', () {
        Expression add = Addition(left: params[0], right: params[1]);

        var result = simplifyAsMuchAsPossible(add);

        expect(result, params[2]);
      }, tags: ['vector', 'addition']);
    }

    final mismatchedVectorsParams = [
      [testVectors[0], testVectors[2]],
      [testVectors[3], testVectors[1]],
      [testVectors[2], testVectors[0]],
    ];
    for (var params in mismatchedVectorsParams) {
      test('MismatchedVectors: ${params[0]} + (${params[1]})', () {
        Expression add = Addition(left: params[0], right: params[1]);

        expect(
          () => add.simplify(),
          throwsA(TypeMatcher<VectorSizeMismatchException>()),
        );
      }, tags: ['vector', 'addition']);
    }

    final matrixWithMatrixParams = [
      [
        Matrix.fromVectors([testVectors[0], testVectors[1]]),
        Matrix.fromVectors([testVectors[0], testVectors[0]]),
        Matrix.fromVectors([
          Vector(items: [
            ScalarProvider.get(14),
            ScalarProvider.get(6),
            ScalarProvider.get(-4),
          ]),
          Vector(items: [
            ScalarProvider.get(8),
            ScalarProvider.get(5),
            ScalarProvider.get(1),
          ]),
        ])
      ],
      [
        Matrix.fromVectors([testVectors[2], testVectors[3]]),
        Matrix.fromVectors([testVectors[2], testVectors[2]]),
        Matrix.fromVectors([
          Vector(items: [
            ScalarProvider.get(8),
            ScalarProvider.get(10),
            ScalarProvider.get(12),
            ScalarProvider.get(14),
          ]),
          Vector(items: [
            ScalarProvider.get(6),
            ScalarProvider.get(4),
            ScalarProvider.get(14),
            ScalarProvider.get(5),
          ])
        ])
      ],
    ];
    for (var params in matrixWithMatrixParams) {
      test('Matrices: ${params[0]} + (${params[1]})', () {
        Expression add = Addition(left: params[0], right: params[1]);

        var result = simplifyAsMuchAsPossible(add);

        expect(result, params[2]);
      }, tags: ['matrix', 'addition']);
    }

    final matrixMismatchParams = [
      [
        Matrix.fromVectors([testVectors[0], testVectors[1]]),
        Matrix.fromVectors([testVectors[2], testVectors[3]]),
      ],
      [
        Matrix.fromVectors([testVectors[0], testVectors[1]]),
        Matrix.fromVectors([testVectors[1], testVectors[0]], vertical: true),
      ],
      [
        Matrix.fromVectors([testVectors[2], testVectors[3]]),
        Matrix.fromVectors([testVectors[3], testVectors[2]], vertical: true),
      ],
    ];
    for (var params in matrixMismatchParams) {
      test('MismatchedMatrices: ${params[0]} + (${params[1]})', () {
        Expression add = Addition(left: params[0], right: params[1]);

        expect(
          () => add.simplify(),
          throwsA(TypeMatcher<MatrixSizeMismatchException>()),
        );
      }, tags: ['matrix', 'addition']);
    }

    // TODO: test variables
    // TODO: test scalar and variable
    // TODO: test commutative group related addition in separate test file
  });
}
