import '../../exceptions.dart';
import '../../interfaces/expression.dart';
import '../../tex_flags.dart';
import '../bool_operations/and.dart';
import '../bool_operations/are_equal.dart';
import '../general/addition.dart';
import '../general/multiply.dart';
import '../structures/variable.dart';
import '../structures/vector.dart';
import 'mapping.dart';

class IsHomomorphism implements Expression {
  final int inputVarCount;
  final Expression mappingVector;

  late final Vector _inputVectorX;

  IsHomomorphism({required this.inputVarCount, required this.mappingVector}) {
    _inputVectorX = Vector(items: [
      for (var i = 0; i < inputVarCount; i++) Variable(index: i),
    ]);
  }

  @override
  Expression simplify() {
    var simplifiedMapping = mappingVector.simplify();
    if (simplifiedMapping != mappingVector) {
      return IsHomomorphism(
        inputVarCount: inputVarCount,
        mappingVector: simplifiedMapping,
      );
    }

    if (mappingVector is! Vector) {
      throw UndefinedOperationException();
    }

    var inputVectorY = Vector(items: [
      for (var i = 0; i < inputVarCount; i++) Variable(index: i, symbol: 'y'),
    ]);

    var addCondition = AreEqual(
      left: Mapping(
        inVector: Addition(left: _inputVectorX, right: inputVectorY),
        mappingVector: mappingVector,
      ),
      right: Addition(
        left: Mapping(inVector: _inputVectorX, mappingVector: mappingVector),
        right: Mapping(inVector: inputVectorY, mappingVector: mappingVector),
      ),
    );

    var variableA = Variable(index: 0, symbol: 'a');
    var multiplyCondition = AreEqual(
      left: Mapping(
        inVector: Multiply(left: variableA, right: _inputVectorX),
        mappingVector: mappingVector,
      ),
      right: Multiply(
        left: variableA,
        right: Mapping(inVector: _inputVectorX, mappingVector: mappingVector),
      ),
    );

    return And(left: addCondition, right: multiplyCondition);
  }

  @override
  String toTeX({Set<TexFlags>? flags}) =>
      'jeHomomorfismus\\left(${_inputVectorX.toTeX()} \\to ${mappingVector.toTeX()}\\right)';
}
