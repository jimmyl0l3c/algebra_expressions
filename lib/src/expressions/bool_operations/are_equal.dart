import '../../interfaces/expression.dart';
import '../../tex_flags.dart';
import '../structures/boolean.dart';

class AreEqual implements Expression {
  final Expression left;
  final Expression right;

  AreEqual({required this.left, required this.right});

  @override
  Expression simplify() {
    var simplifiedLeft = left.simplify();
    if (left != simplifiedLeft) {
      return AreEqual(left: simplifiedLeft, right: right);
    }

    var simplifiedRight = right.simplify();
    if (right != simplifiedRight) {
      return AreEqual(left: left, right: simplifiedRight);
    }

    return Boolean(left == right);
  }

  @override
  String toTeX({Set<TexFlags>? flags}) =>
      '${left.toTeX()} \\overset{?}{=} ${right.toTeX()}';
}
