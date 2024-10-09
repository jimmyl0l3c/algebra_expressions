import '../../exceptions.dart';
import '../../interfaces/expression.dart';
import '../../tex_flags.dart';
import '../structures/boolean.dart';

class And implements Expression {
  final Expression left;
  final Expression right;

  And({required this.left, required this.right});

  @override
  Expression simplify() {
    var simplifiedLeft = left.simplify();
    if (left != simplifiedLeft) {
      return And(left: simplifiedLeft, right: right);
    }

    if (left is! Boolean) {
      throw UndefinedOperationException();
    }

    if (!(left as Boolean).value) {
      return Boolean(false);
    }

    var simplifiedRight = right.simplify();
    if (right != simplifiedRight) {
      return And(left: left, right: simplifiedRight);
    }

    if (right is! Boolean) {
      throw UndefinedOperationException();
    }

    return Boolean((left as Boolean).value && (right as Boolean).value);
  }

  @override
  String toTeX({Set<TexFlags>? flags}) =>
      '(${left.toTeX()}) \\land (${right.toTeX()})';
}
