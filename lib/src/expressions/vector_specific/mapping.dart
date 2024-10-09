import '../../exceptions.dart';
import '../../interfaces/expression.dart';
import '../../tex_flags.dart';
import '../structures/commutative_group.dart';
import '../structures/scalar.dart';
import '../structures/variable.dart';
import '../structures/vector.dart';

class Mapping implements Expression {
  final Expression inVector;
  final Expression mappingVector;

  const Mapping({required this.inVector, required this.mappingVector});

  @override
  Expression simplify() {
    var simplifiedIn = inVector.simplify();
    if (simplifiedIn != inVector) {
      return Mapping(inVector: simplifiedIn, mappingVector: mappingVector);
    }

    var simplifiedOut = mappingVector.simplify();
    if (simplifiedOut != mappingVector) {
      return Mapping(inVector: inVector, mappingVector: simplifiedOut);
    }

    if (inVector is! Vector || mappingVector is! Vector) {
      throw UndefinedOperationException();
    }

    Vector input = inVector as Vector;
    List<Expression> output = [];
    for (var item in (mappingVector as Vector).items) {
      if (item is Scalar) {
        output.add(item);
      } else if (item is Variable) {
        output.add(input[item.index]);
      } else if (item is CommutativeGroup) {
        output.add(CommutativeGroup(
          values: item.values.map((e) {
            if (e is Variable) {
              return input[e.index];
            } else if (e is CommutativeGroup) {
              return CommutativeGroup(
                values: e.values.map((g) {
                  if (g is Variable) {
                    return input[g.index];
                  } else if (g is Scalar) {
                    return g;
                  }
                  throw UndefinedOperationException();
                }).toList(),
                operation: e.operation,
              );
            } else if (e is Scalar) {
              return e;
            }
            throw UndefinedOperationException();
          }).toList(),
          operation: item.operation,
        ));
      } else {
        throw UndefinedOperationException();
      }
    }

    return Vector(items: output);
  }

  @override
  String toTeX({Set<TexFlags>? flags}) =>
      '${inVector.toTeX()} \\to ${mappingVector.toTeX()}';
}
