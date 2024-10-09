import 'package:algebra_lib/algebra_lib.dart';
import 'package:big_fraction/big_fraction.dart';

import 'alg_commutative_group.dart';

void main() {
  var function = Vector(items: [
    CommutativeGroup.add([
      Scalar(BigFraction.from(2)),
      CommutativeGroup.multiply([
        Scalar(BigFraction.from(-3)),
        Variable(index: 1),
      ]),
    ]),
    Variable(index: 0),
    Scalar.one(),
    CommutativeGroup.multiply([
      Variable(index: 0),
      Scalar(BigFraction.from(4)),
    ]),
  ]);
  var mappingExample = Mapping(
    inVector: Vector(items: [
      Variable(index: 0, symbol: 'a'),
      Variable(index: 0, symbol: 'b'),
    ]),
    mappingVector: function,
  );

  printAllSimplifications(mappingExample);
  print('\n');

  var mappingExample2 = Mapping(
    inVector: Vector(items: [
      Scalar(BigFraction.from(2)),
      Scalar(BigFraction.from(-3)),
    ]),
    mappingVector: function,
  );

  printAllSimplifications(mappingExample2);
}
