import '../../exceptions.dart';
import '../../interfaces/expression.dart';
import '../../tex_flags.dart';
import '../bool_operations/are_equal.dart';
import '../equation_specific/gaussian_elimination.dart';
import '../structures/matrix.dart';
import '../structures/scalar.dart';
import '../structures/vector.dart';

class AreVectorsLinearlyIndependent implements Expression {
  final List<Expression> vectors;

  AreVectorsLinearlyIndependent({required this.vectors});

  @override
  Expression simplify() {
    for (var i = 0; i < vectors.length; i++) {
      if (vectors[i] is Matrix || vectors[i] is Scalar) {
        throw UndefinedOperationException();
      }

      if (vectors[i] is! Vector) {
        return AreVectorsLinearlyIndependent(
          vectors: List.from(vectors)
            ..removeAt(i)
            ..insert(i, vectors[i].simplify()),
        );
      }
    }

    List<Vector> equationMatrix = vectors.map((e) => e as Vector).toList();
    equationMatrix.add(
      Vector(
        items: equationMatrix.first.items.map((e) => Scalar.zero()).toList(),
      ),
    );

    List<Expression> zeroVector = [];
    for (var i = 0; i < vectors.length; i++) {
      zeroVector.add(Scalar.zero());
    }

    return AreEqual(
      left: GaussianElimination(
        matrix: Matrix.fromVectors(equationMatrix, vertical: true),
      ),
      right: Vector(items: zeroVector),
    );
  }

  @override
  String toTeX({Set<TexFlags>? flags}) {
    StringBuffer buffer = StringBuffer(r'linNezávislé \begin{Bmatrix}');
    for (var i = 0; i < vectors.length; i++) {
      buffer.write(vectors[i].toTeX());
      if (i != vectors.length - 1) {
        buffer.write(r', \\');
      }
    }
    buffer.write(r'\end{Bmatrix}');
    return buffer.toString();
  }
}
