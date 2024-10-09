import 'package:algebra_lib/algebra_lib.dart';
import 'package:big_fraction/big_fraction.dart';

import 'alg_param_scalar.dart';

void main() {
  var generalEq = GaussianElimination(
    matrix: Matrix.fromVectors([
      Vector(items: [
        Scalar(BigFraction.one()),
        Scalar(BigFraction.from(2)),
        Scalar(BigFraction.from(3)),
        Scalar(BigFraction.from(4)),
      ]),
      Vector(items: [
        Scalar(BigFraction.zero()),
        Scalar(BigFraction.one()),
        Scalar(BigFraction.from(7)),
        Scalar(BigFraction.from(3)),
      ]),
    ]),
  );
  var a0 = simplifyNTimes(generalEq, 15);
  print(a0.toTeX());
  var a = a0.simplify();
  print(a.toTeX());
  var b = a.simplify();
  print(b.toTeX());
  var c = b.simplify();
  print(c.toTeX());
  var d = c.simplify();
  print(d.toTeX());
}
