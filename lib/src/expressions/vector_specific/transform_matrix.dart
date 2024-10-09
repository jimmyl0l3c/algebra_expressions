import '../../exceptions.dart';
import '../../interfaces/expression.dart';
import '../../tex_flags.dart';
import '../../utils/exp_utils.dart';
import '../equation_specific/gaussian_elimination.dart';
import '../structures/boolean.dart';
import '../structures/expression_set.dart';
import '../structures/matrix.dart';
import '../structures/vector.dart';
import 'are_vectors_independent.dart';

class TransformMatrix implements Expression {
  final Expression basisA;
  final Expression basisB;

  TransformMatrix({required this.basisA, required this.basisB}) {
    if (basisA is! ExpressionSet || basisB is! ExpressionSet) {
      throw UndefinedOperationException();
    }

    ExpressionSet bA = basisA as ExpressionSet;
    ExpressionSet bB = basisB as ExpressionSet;

    int? length;
    for (var vector in bA.items) {
      if (vector is! Vector) {
        throw UndefinedOperationException();
      }

      length ??= vector.length;
      if (length != vector.length) {
        throw VectorSizeMismatchException();
      }
    }

    for (var vector in bB.items) {
      if (vector is! Vector) {
        throw UndefinedOperationException();
      }

      length ??= vector.length;
      if (length != vector.length) {
        throw VectorSizeMismatchException();
      }
    }

    if (bA.length() != bB.length()) {
      throw BasisSizeMismatchException();
    }

    var independenceBasisA = simplifyAsMuchAsPossible(
      AreVectorsLinearlyIndependent(
        vectors: bA.items.toList(),
      ),
    );
    if (independenceBasisA is Boolean && !independenceBasisA.value) {
      throw VectorsNotIndependentException();
    }

    var independenceBasisB = simplifyAsMuchAsPossible(
      AreVectorsLinearlyIndependent(
        vectors: bB.items.toList(),
      ),
    );
    if (independenceBasisB is Boolean && !independenceBasisB.value) {
      throw VectorsNotIndependentException();
    }
  }

  @override
  Expression simplify() {
    List<Expression> solutionVectors = [];
    for (var v2 in (basisB as ExpressionSet).items) {
      solutionVectors.add(
        GaussianElimination(
          matrix: Matrix.fromVectors(
            ((basisA as ExpressionSet).items.map((e) => e as Vector).toList()
              ..add(v2 as Vector)),
            vertical: true,
          ),
        ),
      );
    }

    return Matrix(
      rows: solutionVectors,
      rowCount: solutionVectors.length,
      columnCount: solutionVectors.length,
    );
  }

  @override
  String toTeX({Set<TexFlags>? flags}) =>
      'maticePřechodu(${basisA.toTeX()}, ${basisB.toTeX()})';
}
