import '../interfaces/expression.dart';

Expression simplifyAsMuchAsPossible(Expression exp) {
  Expression prevExp = exp;
  Expression lastExp = exp.simplify();

  while (prevExp != lastExp) {
    prevExp = lastExp;
    lastExp = lastExp.simplify();
  }

  return lastExp;
}
