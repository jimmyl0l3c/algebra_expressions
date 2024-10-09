import 'dart:math';

import 'package:big_fraction/big_fraction.dart';

import '../../exceptions.dart';
import '../../interfaces/expression.dart';
import '../../tex_flags.dart';
import '../general/divide.dart';
import '../general/multiply.dart';
import '../structures/matrix.dart';
import '../structures/scalar.dart';
import '../structures/vector.dart';
import 'add_row_to_row_n_times.dart';
import 'exchange_rows.dart';
import 'multiply_row_by_n.dart';

class TriangularDet implements Expression {
  final Expression det;

  TriangularDet({required this.det}) {
    if (det is Vector || det is Scalar) {
      throw UndefinedOperationException();
    }
  }

  @override
  Expression simplify() {
    if (det is Vector || det is Scalar) {
      throw UndefinedOperationException();
    }

    if (det is! Matrix) {
      return TriangularDet(det: det.simplify());
    }

    Matrix m = det.simplify() as Matrix;

    if (m.rowCount != m.columnCount) {
      throw DeterminantNotSquareException();
    }

    // If the matrix contains non-computed expressions, return simplified
    if (m != det) {
      return TriangularDet(det: m);
    }

    int rows = m.rowCount;
    int columns = m.columnCount;
    int diagonal = min(rows, columns);

    Scalar zero = Scalar.zero();
    Scalar one = Scalar.one();
    Scalar nOne = Scalar(BigFraction.minusOne());

    for (var i = 0; i < diagonal; i++) {
      int? nonZero;
      // Find row with non-zero value
      for (var j = 0; j < (rows - i); j++) {
        if ((m[j + i] as Vector)[i] != zero) {
          nonZero ??= j + i;
          // Prefer 1 over other non-zero values
          if ((m[j + i] as Vector)[i] == one) {
            nonZero = j + i;
            break;
          }
        }
      }
      if (nonZero == null) continue;

      // Exchange rows if necessary
      if (nonZero != i) {
        return TriangularDet(
          det: ExchangeRows(
            matrix: MultiplyRowByN(matrix: m, n: nOne, row: i),
            row1: i,
            row2: nonZero,
          ),
        );
      }

      // Clear remaining rows
      for (var j = 0; j < (rows - i - 1); j++) {
        int row = i + 1 + j;
        if ((m[row] as Vector)[i] == zero) continue;

        return TriangularDet(
          det: AddRowToRowNTimes(
            matrix: m,
            origin: i,
            target: row,
            n: Divide(
              numerator: Multiply(left: nOne, right: (m[row] as Vector)[i]),
              denominator: (m[i] as Vector)[i],
            ),
          ),
        );
      }
    }

    return m;
  }

  @override
  String toTeX({Set<TexFlags>? flags}) =>
      'triang\\begin{vmatrix}${det.toTeX(flags: {
            TexFlags.dontEnclose,
          })}\\end{vmatrix}';
}
