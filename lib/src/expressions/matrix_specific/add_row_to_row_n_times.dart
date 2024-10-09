import '../../exceptions.dart';
import '../../interfaces/expression.dart';
import '../../tex_flags.dart';
import '../../utils/tex_utils.dart';
import '../general/addition.dart';
import '../general/multiply.dart';
import '../structures/matrix.dart';
import '../structures/scalar.dart';
import '../structures/vector.dart';

class AddRowToRowNTimes implements Expression {
  final Expression matrix;
  final int origin;
  final int target;
  final Expression n;

  AddRowToRowNTimes({
    required this.matrix,
    required this.origin,
    required this.target,
    required this.n,
  }) {
    if (matrix is Vector || matrix is Scalar) {
      throw UndefinedOperationException();
    }

    if (matrix is Matrix) {
      Matrix m = matrix as Matrix;
      if (origin < 0 || origin >= m.rowCount) {
        throw IndexError.withLength(origin, m.rowCount);
      }

      if (target < 0 || target >= m.rowCount) {
        throw IndexError.withLength(target, m.rowCount);
      }
    }

    if (n is Matrix || n is Vector) {
      throw UndefinedOperationException();
    }
  }

  @override
  Expression simplify() {
    // Commented, because n does not have to be simplified here
    // if (n is Matrix || n is Vector) {
    //   throw UndefinedOperationException();
    // }
    //
    // if (n is! Scalar) {
    //   return AddRowToRowNTimes(
    //     matrix: matrix,
    //     origin: origin,
    //     target: target,
    //     n: n.simplify(),
    //   );
    // }

    if (matrix is Vector || matrix is Scalar) {
      throw UndefinedOperationException();
    }

    if (matrix is! Matrix) {
      return AddRowToRowNTimes(
        matrix: matrix.simplify(),
        origin: origin,
        target: target,
        n: n,
      );
    }

    Matrix m = matrix as Matrix;

    if (origin < 0 || origin >= m.rowCount) {
      throw IndexError.withLength(origin, m.rowCount);
    }

    if (target < 0 || target >= m.rowCount) {
      throw IndexError.withLength(target, m.rowCount);
    }

    var simplifiedMatrix =
        m.rows.map((row) => Vector.from(row as Vector)).toList();

    List<Expression> simplifiedRow = [];
    for (var i = 0; i < m.columnCount; i++) {
      simplifiedRow.add(Addition(
        left: (m[target] as Vector)[i],
        right: Multiply(
          left: n,
          right: (m[origin] as Vector)[i],
        ),
      ));
    }

    simplifiedMatrix[target] = Vector(items: simplifiedRow);

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
      'r_{${target + 1}}+${n.toTeX()} \\cdot r_{${origin + 1}}',
    );
  }
}
