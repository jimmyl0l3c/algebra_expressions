import 'package:big_fraction/big_fraction.dart';

import '../../exceptions.dart';
import '../../interfaces/expression.dart';
import '../../tex_flags.dart';
import '../matrix_specific/reduce.dart';
import '../matrix_specific/triangular.dart';
import '../structures/commutative_group.dart';
import '../structures/matrix.dart';
import '../structures/scalar.dart';
import '../structures/variable.dart';
import '../structures/vector.dart';

class GaussianElimination implements Expression {
  final Expression matrix;

  GaussianElimination({required this.matrix}) {
    if (matrix is Scalar || matrix is Vector || matrix is Variable) {
      throw UndefinedOperationException();
    }
  }

  @override
  Expression simplify() {
    if (matrix is Scalar || matrix is Vector || matrix is Variable) {
      throw UndefinedOperationException();
    }

    if (matrix is Reduce) {
      Expression simplifiedMatrix = matrix.simplify();
      if (simplifiedMatrix is! Matrix) {
        return GaussianElimination(matrix: simplifiedMatrix);
      }

      // TODO: optimize this
      Scalar zero = Scalar.zero();
      List<Expression> numSolution = [];
      Map<int, Map<int, Expression>> solution = {};
      for (var i = 0; i < simplifiedMatrix.columnCount - 1; i++) {
        solution[i] = {i: Scalar.one()};
        numSolution.add(Scalar.zero());
      }

      for (var r = 0; r < simplifiedMatrix.rowCount; r++) {
        for (var c = 0; c < simplifiedMatrix.columnCount; c++) {
          if ((simplifiedMatrix[r] as Vector)[c] != zero) {
            if (c == simplifiedMatrix.columnCount - 1) {
              throw EquationsNotSolvableException();
            }

            for (var i = c + 1; i < simplifiedMatrix.columnCount; i++) {
              if (i == simplifiedMatrix.columnCount - 1) {
                // Right side
                numSolution[c] = (simplifiedMatrix[r] as Vector)[i];
              } else if ((simplifiedMatrix[r] as Vector)[i] != zero) {
                solution[c]?[i] = Scalar(
                  ((simplifiedMatrix[r] as Vector)[i] as Scalar).value *
                      BigFraction.minusOne(),
                );
              }
            }
            solution[c]?.remove(c);
            break;
          }
        }
      }

      List<Expression> solutionVector = [];
      for (var i = 0; i < simplifiedMatrix.columnCount - 1; i++) {
        if (solution[i] == null || solution[i]!.isEmpty) {
          solutionVector.add(numSolution[i]);
        } else {
          List<Expression> parametrizedScalar = [];
          if (numSolution[i] != zero) {
            parametrizedScalar.add(numSolution[i]);
          }
          solution[i]?.forEach(
            (key, value) => parametrizedScalar.add(
              CommutativeGroup.multiply([value, Variable(index: key)]),
            ),
          );

          solutionVector.add(CommutativeGroup.add(parametrizedScalar));
        }
      }
      return Vector(items: solutionVector);
    }

    return GaussianElimination(
      matrix: Reduce(exp: Triangular(matrix: matrix)),
    );
  }

  @override
  String toTeX({Set<TexFlags>? flags}) =>
      'gaussovaEliminace\\begin{pmatrix}${matrix.toTeX(
        flags: {TexFlags.dontEnclose},
      )}\\end{pmatrix}';
}
