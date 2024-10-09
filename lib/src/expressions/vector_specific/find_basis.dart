import '../../exceptions.dart';
import '../../interfaces/expression.dart';
import '../../tex_flags.dart';
import '../matrix_specific/reduce.dart';
import '../matrix_specific/triangular.dart';
import '../structures/expression_set.dart';
import '../structures/matrix.dart';
import '../structures/scalar.dart';
import '../structures/vector.dart';

class FindBasis implements Expression {
  final Expression matrix;

  FindBasis({required this.matrix}) {
    if (matrix is Vector || matrix is Scalar) {
      throw UndefinedOperationException();
    }
  }

  FindBasis.fromVectors({required List<Vector> vectors})
      : matrix = FindBasis(matrix: Matrix.fromVectors(vectors));

  @override
  Expression simplify() {
    if (matrix is Vector || matrix is Scalar) {
      throw UndefinedOperationException();
    }

    if (matrix is Reduce) {
      Expression simplifiedMatrix = matrix.simplify();
      if (simplifiedMatrix is! Matrix) {
        return FindBasis(matrix: simplifiedMatrix);
      }

      List<Expression> basis = [];
      Scalar zero = Scalar.zero();
      for (var row in simplifiedMatrix.rows) {
        if ((row as Vector).items.any((c) => c != zero)) {
          basis.add(row);
        }
      }

      return ExpressionSet(items: basis.map((v) => v).toSet());
    }

    if (matrix is! Matrix) {
      return FindBasis(matrix: matrix.simplify());
    }

    Matrix m = matrix.simplify() as Matrix;

    // If the matrix contains non-computed expressions, return simplified
    if (m != matrix) {
      return FindBasis(matrix: m);
    }

    return FindBasis(matrix: Reduce(exp: Triangular(matrix: m)));
  }

  @override
  String toTeX({Set<TexFlags>? flags}) =>
      'najdiBázi\\left(${matrix.toTeX(flags: {TexFlags.dontEnclose})}\\right)';
}
