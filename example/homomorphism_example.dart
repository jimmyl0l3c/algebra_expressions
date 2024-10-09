import 'package:algebra_lib/algebra_lib.dart';

import 'alg_commutative_group.dart';

void main() {
  var m1 = Vector(items: [Variable(index: 0)]);
  var h1 = IsHomomorphism(inputVarCount: 1, mappingVector: m1);

  printAllSimplifications(h1);
}
