import 'package:algebra_expressions/algebra_expressions.dart';
import 'package:big_fraction/big_fraction.dart';

class ScalarProvider {
  static final Map<int, Scalar> _scalars = {};

  static Scalar get(int scalar) {
    if (!_scalars.containsKey(scalar)) {
      _scalars[scalar] = Scalar(BigFraction.from(scalar));
    }

    return _scalars[scalar]!;
  }
}
