import '../../exceptions.dart';
import '../../interfaces/expression.dart';
import '../../tex_flags.dart';
import '../../utils/tex_utils.dart';
import '../structures/matrix.dart';
import '../structures/scalar.dart';
import '../structures/vector.dart';

class ExchangeRows implements Expression {
  final Expression matrix;
  final int row1;
  final int row2;

  ExchangeRows({
    required this.matrix,
    required this.row1,
    required this.row2,
  }) {
    if (matrix is Vector || matrix is Scalar) {
      throw UndefinedOperationException();
    }

    if (matrix is Matrix) {
      Matrix m = matrix as Matrix;
      if (row1 < 0 || row1 >= m.rowCount) {
        throw IndexError.withLength(row1, m.rowCount);
      }

      if (row2 < 0 || row2 >= m.rowCount) {
        throw IndexError.withLength(row2, m.rowCount);
      }
    }
  }

  @override
  Expression simplify() {
    if (matrix is Vector || matrix is Scalar) {
      throw UndefinedOperationException();
    }

    if (matrix is! Matrix) {
      return ExchangeRows(
        matrix: matrix.simplify(),
        row1: row1,
        row2: row2,
      );
    }

    var simplifiedMatrix = (matrix as Matrix)
        .rows
        .map((row) => Vector.from(row as Vector))
        .toList();

    var tmp = simplifiedMatrix[row1];
    simplifiedMatrix[row1] = simplifiedMatrix[row2];
    simplifiedMatrix[row2] = tmp;

    return Matrix(
      rows: simplifiedMatrix,
      rowCount: (matrix as Matrix).rowCount,
      columnCount: (matrix as Matrix).columnCount,
    );
  }

  @override
  String toTeX({Set<TexFlags>? flags}) {
    return TexUtils.rowTransformToTeX(
      matrix,
      'r_{${row1 + 1}} \\leftrightarrow r_{${row2 + 1}}',
    );
  }
}
