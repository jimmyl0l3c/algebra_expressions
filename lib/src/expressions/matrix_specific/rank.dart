import 'package:big_fraction/big_fraction.dart';

import '../../exceptions.dart';
import '../../interfaces/expression.dart';
import '../../tex_flags.dart';
import '../structures/matrix.dart';
import '../structures/scalar.dart';
import '../structures/vector.dart';
import 'reduce.dart';

class Rank implements Expression {
  final Expression matrix;

  Rank({required this.matrix}) {
    if (matrix is Vector || matrix is Scalar) {
      throw UndefinedOperationException();
    }
  }

  @override
  Expression simplify() {
    if (matrix is Vector || matrix is Scalar) {
      throw UndefinedOperationException();
    }

    if (matrix is Reduce) {
      Expression simplifiedReduce = matrix.simplify();
      if (simplifiedReduce is! Matrix) {
        return Rank(matrix: simplifiedReduce);
      }

      Scalar zero = Scalar.zero();
      int rank = 0;
      for (var r = 0; r < simplifiedReduce.rowCount; r++) {
        for (var c = 0; c < simplifiedReduce.columnCount; c++) {
          if ((simplifiedReduce[r] as Vector)[c] != zero) {
            rank++;
            break;
          }
        }
      }

      return Scalar(BigFraction.from(rank));
    }

    if (matrix is! Matrix) {
      return Rank(matrix: matrix.simplify());
    }

    Matrix m = matrix.simplify() as Matrix;
    // If the matrix contains non-computed expressions, return simplified
    if (m != matrix) {
      return Rank(matrix: m);
    }

    return Rank(matrix: Reduce(exp: m));
  }

  @override
  String toTeX({Set<TexFlags>? flags}) =>
      'h\\begin{pmatrix}${matrix.toTeX(flags: {
            TexFlags.dontEnclose,
          })}\\end{pmatrix}';
}
