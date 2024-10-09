import '../../exceptions.dart';
import '../../interfaces/expression.dart';
import '../../tex_flags.dart';
import '../structures/matrix.dart';
import '../structures/scalar.dart';
import '../structures/vector.dart';

class Divide implements Expression {
  Expression numerator;
  Expression denominator;

  Divide({required this.numerator, required this.denominator}) {
    if (numerator is Matrix || numerator is Vector) {
      throw UndefinedOperationException();
    }

    if (denominator is Matrix || denominator is Vector) {
      throw UndefinedOperationException();
    }
  }

  @override
  Expression simplify() {
    if (numerator is Matrix || numerator is Vector) {
      throw UndefinedOperationException();
    }

    if (denominator is Matrix || denominator is Vector) {
      throw UndefinedOperationException();
    }

    if (denominator is Scalar && denominator == Scalar.one()) {
      return numerator;
    }

    if (denominator is Scalar && denominator == Scalar.zero()) {
      throw DivisionByZeroException();
    }

    if (numerator is! Scalar) {
      return Divide(numerator: numerator.simplify(), denominator: denominator);
    }

    if (denominator is! Scalar) {
      return Divide(numerator: numerator, denominator: denominator.simplify());
    }

    return Scalar(
      (numerator as Scalar).value / (denominator as Scalar).value,
    );
  }

  @override
  String toTeX({Set<TexFlags>? flags}) =>
      '\\frac{${numerator.toTeX()}}{${denominator.toTeX()}}';
}
