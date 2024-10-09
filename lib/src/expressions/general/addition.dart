import 'package:big_fraction/big_fraction.dart';

import '../../exceptions.dart';
import '../../interfaces/expression.dart';
import '../../tex_flags.dart';
import '../structures/commutative_group.dart';
import '../structures/matrix.dart';
import '../structures/scalar.dart';
import '../structures/variable.dart';
import '../structures/vector.dart';

class Addition implements Expression {
  final Expression left;
  final Expression right;

  Addition({required this.left, required this.right});

  @override
  Expression simplify() {
    // If left can be simplified, do it
    var simplifiedLeft = left.simplify();
    if (left != simplifiedLeft) {
      // if (simplifiedLeft is CommutativeGroup) {
      //   return _simplifyExpWithCommutativeGroup(simplifiedLeft, right) ??
      //       Addition(left: simplifiedLeft, right: right);
      // }

      return Addition(left: simplifiedLeft, right: right);
    }

    // If right can be simplified, do it
    var simplifiedRight = right.simplify();
    if (right != simplifiedRight) {
      // if (simplifiedRight is CommutativeGroup) {
      //   return _simplifyExpWithCommutativeGroup(left, simplifiedRight) ??
      //       Addition(left: left, right: simplifiedRight);
      // }

      return Addition(left: left, right: simplifiedRight);
    }

    if (left is Scalar && right is Scalar) {
      return Scalar((left as Scalar).value + (right as Scalar).value);
    }

    if (left is Vector && right is Vector) {
      List<Expression> addedVector = [];
      Vector leftVector = left as Vector;
      Vector rightVector = right as Vector;

      if (leftVector.length != rightVector.length) {
        throw VectorSizeMismatchException();
      }

      for (var i = 0; i < leftVector.length; i++) {
        addedVector.add(Addition(
          left: leftVector[i],
          right: rightVector[i],
        ));
      }

      return Vector(items: addedVector);
    }

    if (left is Matrix && right is Matrix) {
      List<Expression> addedMatrix = [];
      Matrix leftMatrix = left as Matrix;
      Matrix rightMatrix = right as Matrix;

      if (leftMatrix.rowCount != rightMatrix.rowCount ||
          leftMatrix.columnCount != rightMatrix.columnCount) {
        throw MatrixSizeMismatchException();
      }

      for (var r = 0; r < leftMatrix.rowCount; r++) {
        List<Expression> matrixRow = [];

        for (var c = 0; c < leftMatrix.columnCount; c++) {
          matrixRow.add(Addition(
            left: (leftMatrix[r] as Vector)[c],
            right: (rightMatrix[r] as Vector)[c],
          ));
        }
        addedMatrix.add(Vector(items: matrixRow));
      }

      return Matrix(
        rows: addedMatrix,
        rowCount: leftMatrix.rowCount,
        columnCount: leftMatrix.columnCount,
      );
    }

    if ((left is Scalar && right is Variable) ||
        (left is Variable && right is Scalar)) {
      return CommutativeGroup.add([left, right]);
    }

    if (left is Variable && right is Variable) {
      if (left == right) {
        return CommutativeGroup.multiply([Scalar(BigFraction.from(2)), left]);
      } else {
        return CommutativeGroup.add([left, right]);
      }
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
    // Scalar and CommutativeGroup.Multiply
    if ((left is Scalar &&
            (right is CommutativeGroup &&
                right.operation == CommutativeOperation.multiplication)) ||
        ((left is CommutativeGroup &&
                left.operation == CommutativeOperation.multiplication) &&
            right is Scalar)) {
      return CommutativeGroup.add([left, right]);
    }

    // Scalar and CommutativeGroup.Add
    if (left is Scalar &&
        right is CommutativeGroup &&
        right.operation == CommutativeOperation.addition) {
      int i = right.values.indexWhere((e) => e is Scalar);
      if (i < 0) {
        return CommutativeGroup.add(List.from(right.values)..add(left));
      } else {
        BigFraction value = (right.values[i] as Scalar).value;
        return CommutativeGroup.add(
          List.from(right.values)
            ..removeAt(i)
            ..add(Scalar(left.value + value)),
        );
      }
    }

    // CommutativeGroup.Add and Scalar
    if (left is CommutativeGroup &&
        left.operation == CommutativeOperation.addition &&
        right is Scalar) {
      int i = left.values.indexWhere((e) => e is Scalar);
      if (i < 0) {
        return CommutativeGroup.add(List.from(left.values)..add(right));
      } else {
        BigFraction value = (left.values[i] as Scalar).value;
        return CommutativeGroup.add(
          List.from(left.values)
            ..removeAt(i)
            ..add(Scalar(right.value + value)),
        );
      }
    }

    // Variable and CommutativeGroup.Multiply
    if ((left is Variable &&
            right is CommutativeGroup &&
            right.operation == CommutativeOperation.multiplication) ||
        (left is CommutativeGroup &&
            left.operation == CommutativeOperation.multiplication &&
            right is Variable)) {
      return CommutativeGroup.add([left, right]);
    }

    // Variable and CommutativeGroup.Add
    if (left is Variable &&
        right is CommutativeGroup &&
        right.operation == CommutativeOperation.addition) {
      int i = right.values
          .indexWhere((e) => e is Variable && e.index == (left).index);
      if (i < 0) {
        return CommutativeGroup.add(List.from(right.values)..add(left));
      } else {
        return CommutativeGroup.add(
          List.from(right.values)
            ..removeAt(i)
            ..add(
              CommutativeGroup.multiply([Scalar(BigFraction.from(2)), left]),
            ),
        );
      }
    }

    // CommutativeGroup.Add and Variable
    if (right is Variable &&
        left is CommutativeGroup &&
        left.operation == CommutativeOperation.addition) {
      int i = left.values
          .indexWhere((e) => e is Variable && e.index == (right).index);
      if (i < 0) {
        return CommutativeGroup.add(List.from(left.values)..add(right));
      } else {
        return CommutativeGroup.add(
          List.from(left.values)
            ..removeAt(i)
            ..add(
              CommutativeGroup.multiply([Scalar(BigFraction.from(2)), right]),
            ),
        );
      }
    }

    if (left is CommutativeGroup && right is CommutativeGroup) {
      if (left.operation == right.operation &&
          left.operation == CommutativeOperation.multiplication) {
        return CommutativeGroup.add([left, right]);
      } else if (left.operation == right.operation &&
          left.operation == CommutativeOperation.addition) {
        return CommutativeGroup.add(
          [...left.values, ...right.values],
        );
      } else if (left.operation != right.operation &&
          left.operation == CommutativeOperation.addition) {
        return CommutativeGroup.add(List.from(left.values)..add(right));
      } else if (left.operation != right.operation &&
          right.operation == CommutativeOperation.addition) {
        return CommutativeGroup.add(List.from(right.values)..add(left));
      }
    }

    return null;
  }

  @override
  String toTeX({Set<TexFlags>? flags}) {
    StringBuffer buffer = StringBuffer();

    if (flags == null || !flags.contains(TexFlags.dontEnclose)) {
      buffer.write(r'\left(');
    }
    buffer.write('${left.toTeX()} ');
    if (right is! Scalar || !(right as Scalar).value.isNegative) {
      buffer.write('+');
    }
    buffer.write(' ${right.toTeX()}');
    if (flags == null || !flags.contains(TexFlags.dontEnclose)) {
      buffer.write(r'\right)');
    }

    return buffer.toString();
  }
}
