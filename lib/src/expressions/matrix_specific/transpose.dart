import '../../exceptions.dart';
import '../../interfaces/expression.dart';
import '../../tex_flags.dart';
import '../structures/matrix.dart';
import '../structures/scalar.dart';
import '../structures/vector.dart';

class Transpose implements Expression {
  final Expression matrix;

  Transpose({required this.matrix}) {
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
      return Transpose(matrix: matrix.simplify());
    }

    Matrix m = matrix as Matrix;
    List<Expression> transposedMatrix = [];

    for (var r = 0; r < m.columnCount; r++) {
      List<Expression> row = [];
      for (var c = 0; c < m.rowCount; c++) {
        row.add((m[c] as Vector)[r]);
      }
      transposedMatrix.add(Vector(items: row));
    }

    return Matrix(
      rows: transposedMatrix,
      rowCount: m.columnCount,
      columnCount: m.rowCount,
    );
  }

  @override
  String toTeX({Set<TexFlags>? flags}) =>
      '\\begin{pmatrix}${matrix.toTeX(flags: {
            TexFlags.dontEnclose,
          })}\\end{pmatrix}^{T}';
}
