import 'package:algebra_lib/algebra_lib.dart';
import 'package:big_fraction/big_fraction.dart';

import '../test/utils/scalar_provider.dart';

void main() {
  final testGroups = [
    CommutativeGroup.add([
      Variable(index: 0),
      Variable(index: 1),
      Variable(index: 2),
    ]),
    CommutativeGroup.multiply([
      Variable(index: 0),
      Variable(index: 2),
      ScalarProvider.get(3),
    ]),
  ];

  final paramScalarWithScalarParams = [
    [ScalarProvider.get(2), testGroups[0]],
    [ScalarProvider.get(-4), testGroups[0]],
    [testGroups[1], ScalarProvider.get(3)],
    [testGroups[1], ScalarProvider.get(-1)],
  ];
  for (var params in paramScalarWithScalarParams) {
    Expression addition = Addition(left: params[0], right: params[1]);
    printAllSimplifications(addition);
    print('');

    // Expression multiply = Multiply(left: params[0], right: params[1]);
    // printNSimplifications(multiply, 6);
    // print('');
  }

  print('\n');

  final paramScalarWithParamScalarsTest = [
    [testGroups[0], testGroups[0]],
    [testGroups[0], testGroups[1]],
    [testGroups[1], testGroups[0]],
    [testGroups[1], testGroups[1]],
  ];
  for (var params in paramScalarWithParamScalarsTest) {
    Expression addition = Addition(left: params[0], right: params[1]);
    printAllSimplifications(addition);
    // printNSimplifications(addition, 10);
    print('');
  }

  print('');
  final problematicExample = CommutativeGroup.add([
    Variable(index: 0),
    CommutativeGroup.multiply(
      [Scalar(BigFraction.minusOne()), Variable(index: 0)],
    ),
  ]);
  printAllSimplifications(problematicExample);

  print('');
  final problematicExample2 = CommutativeGroup.add([
    CommutativeGroup.multiply(
      [Scalar(BigFraction.minusOne()), Variable(index: 0)],
    ),
    Variable(index: 0),
  ]);
  printAllSimplifications(problematicExample2);
}

void printAllSimplifications(Expression expression, {bool addNewLine = false}) {
  Expression prevExp = expression;
  Expression lastExp = expression;
  print(expression.toTeX());
  if (addNewLine) {
    print('');
  }

  do {
    prevExp = lastExp;
    lastExp = lastExp.simplify();
    print(lastExp.toTeX());
    if (addNewLine) {
      print('');
    }
  } while (prevExp != lastExp);
}
