import 'package:big_fraction/big_fraction.dart';

import '../../interfaces/expression.dart';
import '../../tex_flags.dart';

class Scalar implements Expression {
  final BigFraction value;

  Scalar(this.value);

  Scalar.zero() : value = BigFraction.zero();
  Scalar.one() : value = BigFraction.one();

  @override
  Expression simplify() => this;

  // TODO: add toTeX() extension to Fraction
  @override
  String toTeX({Set<TexFlags>? flags}) => value.reduce().toString();

  @override
  String toString() => value.reduce().toString();

  @override
  bool operator ==(Object other) {
    if (other is! Scalar) return false;
    return value == other.value;
  }

  @override
  int get hashCode {
    if (value == BigFraction.one()) {
      return BigFraction.one().hashCode;
    }

    return value.hashCode;
  }
}
