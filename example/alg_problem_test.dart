import 'package:algebra_lib/algebra_lib.dart';
import 'package:big_fraction/big_fraction.dart';

void main() {
  var m = Matrix(
    rows: [
      Vector(items: [
        Scalar(BigFraction.from(-13)),
        Scalar(BigFraction.from(-2)),
        Scalar(BigFraction.from(9)),
      ]),
      Vector(items: [
        Scalar(BigFraction.from(4)),
        Scalar(BigFraction.from(9)),
        Scalar(BigFraction.from(-13)),
      ]),
      Vector(items: [
        Scalar(BigFraction.from(9)),
        Scalar(BigFraction.from(8)),
        Scalar(BigFraction.from(-8)),
      ]),
      Vector(items: [
        Scalar(BigFraction.from(8)),
        Scalar(BigFraction.from(-1)),
        Scalar(BigFraction.from(-13)),
      ]),
    ],
    rowCount: 4,
    columnCount: 3,
  );

  var v = Vector(
    items: [
      Scalar(BigFraction.from(13)),
      Scalar(BigFraction.from(-8)),
      Scalar(BigFraction.from(-2)),
      Scalar(BigFraction.from(2)),
    ],
  );

  var solvable = IsSolvable(matrix: m, vectorY: v);

  var gauss = GaussianElimination(matrix: Matrix.toEquationMatrix(m, v));

  // printNSimplifications(solvable, 302, addNewLine: true);
  // var t0 = simplifyNTimes(solvable, 300);
  // print(t0.toTeX());
  // var t1 = simplifyNTimes(solvable, 301);
  // print(t1.toTeX());
  // var t2 = simplifyNTimes(solvable, 302);
  // print(t2.toTeX());
  // var t3 = simplifyNTimes(solvable, 303);
  // print(t3.toTeX());
  //
  // print((t1 as Boolean).value);

  var exp = gauss;
  try {
    List<Expression> output = [exp];

    Expression prevExp = exp;
    Expression lastExp = exp.simplify();

    while (prevExp != lastExp) {
      output.add(lastExp);
      prevExp = lastExp;
      lastExp = lastExp.simplify();
      print(prevExp.toTeX());
    }
    print(output.last.toTeX());
  } on ExpressionException {
    print('Not solvable');
  }
}

void printNSimplifications(Expression expression, int n,
    {bool addNewLine = false}) {
  for (var i = 0; i < n; i++) {
    print(simplifyNTimes(expression, i).toTeX());
    if (addNewLine) {
      print('');
    }
  }
}

Expression simplifyNTimes(Expression expression, int n) {
  Expression exp = expression;
  for (var i = 0; i < n; i++) {
    exp = exp.simplify();
  }
  return exp;
}
