import 'package:big_fraction/big_fraction.dart';

import '../../exceptions.dart';
import '../../interfaces/expression.dart';
import '../../tex_flags.dart';
import '../structures/commutative_group.dart';
import '../structures/matrix.dart';
import '../structures/scalar.dart';
import '../structures/variable.dart';
import '../structures/vector.dart';
import 'addition.dart';

class Multiply implements Expression {
  final Expression left;
  final Expression right;

  Multiply({required this.left, required this.right});

  @override
  Expression simplify() {
    // If left or right is zero, return zero
    Scalar zero = Scalar.zero();
    if (left is Scalar && left == zero) {
      return zero;
    }
    if (right is Scalar && right == zero) {
      return zero;
    }

    // If left can be simplified, do it
    var simplifiedLeft = left.simplify();
    if (left != simplifiedLeft) {
      if (simplifiedLeft is CommutativeGroup) {
        return _simplifyExpWithCommutativeGroup(simplifiedLeft, right) ??
            Multiply(left: simplifiedLeft, right: right);
      }

      return Multiply(left: simplifiedLeft, right: right);
    }

    // If right can be simplified, do it
    var simplifiedRight = right.simplify();
    if (right != simplifiedRight) {
      if (simplifiedRight is CommutativeGroup) {
        return _simplifyExpWithCommutativeGroup(left, simplifiedRight) ??
            Multiply(left: left, right: simplifiedRight);
      }

      return Multiply(left: left, right: simplifiedRight);
    }

    if (left is Scalar && right is Scalar) {
      return Scalar((left as Scalar).value * (right as Scalar).value);
    }

    if ((left is Scalar || left is Variable || left is CommutativeGroup) &&
        right is Vector) {
      List<Expression> multipliedVector = [];

      for (var item in (right as Vector).items) {
        multipliedVector.add(Multiply(left: left, right: item));
      }

      return Vector(items: multipliedVector);
    }

    if (left is Vector &&
        (right is Scalar || right is Variable || right is CommutativeGroup)) {
      List<Expression> multipliedVector = [];

      for (var item in (left as Vector).items) {
        multipliedVector.add(Multiply(left: item, right: right));
      }

      return Vector(items: multipliedVector);
    }

    if (left is Scalar && right is Matrix) {
      List<Expression> multipliedMatrix = [];

      for (var row in (right as Matrix).rows) {
        multipliedMatrix.add(Multiply(left: left, right: row).simplify());
      }

      return Matrix(
        rows: multipliedMatrix,
        rowCount: (right as Matrix).rowCount,
        columnCount: (right as Matrix).columnCount,
      );
    }

    if (left is Matrix && right is Scalar) {
      List<Expression> multipliedMatrix = [];

      for (var row in (left as Matrix).rows) {
        multipliedMatrix.add(Multiply(left: row, right: right).simplify());
      }

      return Matrix(
        rows: multipliedMatrix,
        rowCount: (left as Matrix).rowCount,
        columnCount: (left as Matrix).columnCount,
      );
    }

    if (left is Matrix && right is Matrix) {
      Matrix leftMatrix = left as Matrix;
      Matrix rightMatrix = right as Matrix;

      int leftCols = leftMatrix.columnCount;
      int rightRows = rightMatrix.rowCount;

      if (leftCols != rightRows) throw MatrixMultiplySizeException();

      int leftRows = leftMatrix.rowCount;
      int rightCols = rightMatrix.columnCount;

      if (leftRows == 1 && rightCols == 1) {
        Expression item = Multiply(
          left: (leftMatrix[0] as Vector)[0],
          right: (rightMatrix[0] as Vector)[0],
        );

        for (var i = 1; i < leftCols; i++) {
          item = Addition(
            left: item,
            right: Multiply(
              left: (leftMatrix[0] as Vector)[i],
              right: (rightMatrix[i] as Vector)[0],
            ),
          );
        }

        return item;
      } else {
        List<Expression> multipliedMatrices = [];

        for (var ra = 0; ra < leftRows; ra++) {
          List<Expression> outputRow = [];
          for (var cb = 0; cb < rightCols; cb++) {
            outputRow.add(
              Multiply(
                left: Matrix(
                  rows: [leftMatrix[ra]],
                  rowCount: 1,
                  columnCount: (leftMatrix[ra] as Vector).length,
                ),
                right: Matrix(
                  rows: rightMatrix.rows
                      .map((row) => Vector(items: [(row as Vector)[cb]]))
                      .toList(),
                  rowCount: rightMatrix.rowCount,
                  columnCount: 1,
                ),
              ),
            );
          }
          multipliedMatrices.add(Vector(items: outputRow));
        }

        return Matrix(
          rows: multipliedMatrices,
          rowCount: leftRows,
          columnCount: rightCols,
        );
      }
    }

    // if (left is Scalar && right is ParametrizedScalar) {
    //   return ParametrizedScalar(
    //     values: (right as ParametrizedScalar)
    //         .values
    //         .map((e) => Multiply(
    //               left: left,
    //               right: e,
    //             ))
    //         .toList(),
    //   );
    // }
    //
    // if (left is ParametrizedScalar && right is Scalar) {
    //   return ParametrizedScalar(
    //     values: (left as ParametrizedScalar)
    //         .values
    //         .map((e) => Multiply(
    //               left: e,
    //               right: right,
    //             ))
    //         .toList(),
    //   );
    // }

    if ((left is Scalar && right is Variable) ||
        (left is Variable && right is Scalar) ||
        (left is Variable && right is Variable)) {
      return CommutativeGroup.multiply([left, right]);
    }

    var simplifiedGroup = _simplifyExpWithCommutativeGroup(left, right);
    if (simplifiedGroup != null) {
      return simplifiedGroup;
    }

    throw UndefinedOperationException();
  }

  Expression? _simplifyExpWithCommutativeGroup(
    Expression left,
    Expression right,
  ) {
    if (left is Scalar && right is CommutativeGroup) {
      if (right.operation == CommutativeOperation.multiplication) {
        int i = right.values.indexWhere((e) => e is Scalar);
        if (i < 0) {
          return CommutativeGroup.multiply(List.from(right.values)..add(left));
        } else {
          BigFraction value = (right.values[i] as Scalar).value;
          return CommutativeGroup.multiply(
            List.from(right.values)
              ..removeAt(i)
              ..add(Scalar(value * left.value)),
          );
        }
      } else if (right.operation == CommutativeOperation.addition) {
        return CommutativeGroup.add(
          right.values.map((e) => Multiply(left: left, right: e)).toList(),
        );
      }
    }

    if (left is CommutativeGroup && right is Scalar) {
      if (left.operation == CommutativeOperation.multiplication) {
        int i = left.values.indexWhere((e) => e is Scalar);
        if (i < 0) {
          return CommutativeGroup.multiply(List.from(left.values)..add(right));
        } else {
          BigFraction value = (left.values[i] as Scalar).value;
          return CommutativeGroup.multiply(
            List.from(left.values)
              ..removeAt(i)
              ..add(Scalar(value * right.value)),
          );
        }
      } else if (left.operation == CommutativeOperation.addition) {
        return CommutativeGroup.add(
          left.values.map((e) => Multiply(left: e, right: right)).toList(),
        );
      }
    }

    if (left is CommutativeGroup && right is Variable) {
      if (left.operation == CommutativeOperation.multiplication) {
        return CommutativeGroup.multiply(List.from(left.values)..add(right));
      } else if (left.operation == CommutativeOperation.addition) {
        return CommutativeGroup.add(
          left.values.map((e) => Multiply(left: e, right: right)).toList(),
        );
      }
    }

    if (left is Variable && right is CommutativeGroup) {
      if (right.operation == CommutativeOperation.multiplication) {
        return CommutativeGroup.multiply(List.from(right.values)..add(left));
      } else if (right.operation == CommutativeOperation.addition) {
        return CommutativeGroup.add(
          right.values.map((e) => Multiply(left: left, right: e)).toList(),
        );
      }
    }

    if (left is CommutativeGroup && right is CommutativeGroup) {
      if (left.operation == right.operation &&
          left.operation == CommutativeOperation.multiplication) {
        return CommutativeGroup.multiply([...left.values, ...right.values]);
      } else if (left.operation == right.operation &&
          left.operation == CommutativeOperation.addition) {
        List<Expression> group = [];
        for (var leftElement in left.values) {
          for (var rightElement in right.values) {
            group.add(Multiply(left: leftElement, right: rightElement));
          }
        }
        return CommutativeGroup.add(group);
      } else if (left.operation != right.operation &&
          left.operation == CommutativeOperation.addition) {
        return CommutativeGroup.add(
          left.values.map((e) => Multiply(left: e, right: right)).toList(),
        );
      } else if (left.operation != right.operation &&
          right.operation == CommutativeOperation.addition) {
        return CommutativeGroup.add(
          right.values.map((e) => Multiply(left: left, right: e)).toList(),
        );
      }
    }

    return null;
  }

  @override
  String toTeX({Set<TexFlags>? flags}) {
    StringBuffer buffer = StringBuffer();
    bool encloseLeft = (left is Scalar && (left as Scalar).value.isNegative) ||
        (left is Variable);

    if (encloseLeft) {
      buffer.write('(');
    }
    buffer.write(left.toTeX());
    if (encloseLeft) {
      buffer.write(')');
    }

    buffer.write(r'\cdot ');

    bool encloseRight =
        (right is Scalar && (right as Scalar).value.isNegative) ||
            (right is Variable);

    if (encloseRight) {
      buffer.write('(');
    }
    buffer.write(right.toTeX());
    if (encloseRight) {
      buffer.write(')');
    }

    return buffer.toString();
  }
}
