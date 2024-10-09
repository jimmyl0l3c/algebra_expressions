import '../../exceptions.dart';
import '../../interfaces/expression.dart';
import '../../tex_flags.dart';
import '../structures/matrix.dart';
import '../structures/scalar.dart';
import '../structures/vector.dart';
import 'determinant.dart';

class Minor implements Expression {
  final Expression matrix;
  final int row;
  final int column;

  Minor({required this.matrix, required this.row, required this.column}) {
    if (matrix is Vector || matrix is Scalar) {
      throw UndefinedOperationException();
    }
  }

  @override
  Expression simplify() {
    if (matrix is Vector || matrix is Scalar) {
      throw UndefinedOperationException();
    }

    if (matrix is! Matrix) {
      return Minor(matrix: matrix.simplify(), row: row, column: column);
    }

    Matrix m = matrix as Matrix;
    if (m.rowCount != m.columnCount) {
      throw DeterminantNotSquareException();
    }

    List<Expression> minorRows = [];

    //  Skip row and column
    for (var r = 0; r < m.rowCount; r++) {
      if (r == row) continue;
      List<Expression> minorRow = [];
      for (var c = 0; c < m.rowCount; c++) {
        if (c == column) continue;
        minorRow.add((m[r] as Vector)[c]);
      }
      minorRows.add(Vector(items: minorRow));
    }

    return Determinant(
      det: Matrix(
        rows: minorRows,
        rowCount: m.rowCount - 1,
        columnCount: m.columnCount - 1,
      ),
    );
  }

  @override
  String toTeX({Set<TexFlags>? flags}) =>
      '\\mathcal{M}_{$row,$column}${matrix.toTeX()}';
}
