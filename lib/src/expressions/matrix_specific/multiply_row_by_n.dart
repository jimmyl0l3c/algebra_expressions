import '../../exceptions.dart';
import '../../interfaces/expression.dart';
import '../../tex_flags.dart';
import '../../utils/tex_utils.dart';
import '../general/multiply.dart';
import '../structures/matrix.dart';
import '../structures/scalar.dart';
import '../structures/vector.dart';

class MultiplyRowByN implements Expression {
  final Expression matrix;
  final Expression n;
  final int row;

  MultiplyRowByN({required this.matrix, required this.n, required this.row}) {
    if (matrix is Vector || matrix is Scalar) {
      throw UndefinedOperationException();
    }

    if (matrix is Matrix) {
      Matrix m = matrix as Matrix;
      if (row < 0 || row >= m.rowCount) {
        throw IndexError.withLength(row, m.rowCount);
      }
    }

    if (n is Matrix || n is Vector) {
      throw UndefinedOperationException();
    }
  }

  @override
  Expression simplify() {
    // if (n is Matrix || n is Vector) {
    //   throw UndefinedOperationException();
    // }
    //
    // if (n is! Scalar) {
    //   return MultiplyRowByN(
    //     matrix: matrix,
    //     n: n.simplify(),
    //     row: row,
    //   );
    // }

    if (matrix is Vector || matrix is Scalar) {
      throw UndefinedOperationException();
    }

    if (matrix is! Matrix) {
      return MultiplyRowByN(
        matrix: matrix.simplify(),
        n: n,
        row: row,
      );
    }

    Matrix m = matrix as Matrix;

    if (row < 0 || row >= m.rowCount) {
      throw IndexError.withLength(row, m.rowCount);
    }

    var simplifiedMatrix =
        m.rows.map((row) => Vector.from(row as Vector)).toList();

    List<Expression> simplifiedRow = [];
    for (var i = 0; i < m.columnCount; i++) {
      simplifiedRow.add(Multiply(left: n, right: (m[row] as Vector)[i]));
    }

    simplifiedMatrix[row] = Vector(items: simplifiedRow);

    return Matrix(
      rows: simplifiedMatrix,
      rowCount: m.rowCount,
      columnCount: m.columnCount,
    );
  }

  @override
  String toTeX({Set<TexFlags>? flags}) {
    return TexUtils.rowTransformToTeX(
      matrix,
      'r_{${row + 1}} \\cdot ${n.toTeX()}',
    );
  }
}
