import 'package:big_fraction/big_fraction.dart';

import '../../exceptions.dart';
import '../../interfaces/expression.dart';
import '../../tex_flags.dart';
import '../general/inverse.dart';
import '../general/multiply.dart';
import '../structures/matrix.dart';
import '../structures/scalar.dart';
import '../structures/vector.dart';
import 'add_row_to_row_n_times.dart';
import 'multiply_row_by_n.dart';

class Reduce implements Expression {
  final Expression exp;

  Reduce({required this.exp}) {
    if (exp is Vector) {
      throw UndefinedOperationException();
    }
  }

  @override
  Expression simplify() {
    if (exp is Vector) {
      throw UndefinedOperationException();
    }

    if (exp is! Scalar && exp is! Matrix) {
      return Reduce(exp: exp.simplify());
    }

    if (exp is Scalar) {
      return Scalar((exp as Scalar).value.reduce());
    }

    Matrix m = exp.simplify() as Matrix;

    // If the matrix contains non-computed expressions, return simplified
    if (m != exp) {
      return Reduce(exp: m);
    }

    Scalar zero = Scalar.zero();
    Scalar one = Scalar.one();
    Scalar nOne = Scalar(BigFraction.minusOne());

    for (var i = 0; i < m.rowCount; i++) {
      for (var j = 0; j < m.columnCount; j++) {
        if ((m[i] as Vector)[j] != zero) {
          if ((m[i] as Vector)[j] != one) {
            return Reduce(
              exp: MultiplyRowByN(
                matrix: m,
                n: Inverse(exp: (m[i] as Vector)[j]),
                row: i,
              ),
            );
          }

          for (var k = 0; k < m.rowCount; k++) {
            if (k == i) continue;

            if ((m[k] as Vector)[j] != zero) {
              return Reduce(
                exp: AddRowToRowNTimes(
                  matrix: m,
                  origin: i,
                  target: k,
                  n: Multiply(left: nOne, right: (m[k] as Vector)[j]),
                ),
              );
            }
          }

          break;
        }
      }
    }

    return m;
  }

  @override
  String toTeX({Set<TexFlags>? flags}) =>
      'redukce\\begin{pmatrix}${exp.toTeX(flags: {
            TexFlags.dontEnclose,
          })}\\end{pmatrix}';
}
