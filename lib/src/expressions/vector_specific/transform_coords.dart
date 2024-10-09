import '../../exceptions.dart';
import '../../interfaces/expression.dart';
import '../../tex_flags.dart';
import '../general/multiply.dart';
import '../structures/matrix.dart';
import '../structures/scalar.dart';
import '../structures/vector.dart';

class TransformCoords implements Expression {
  final Expression transformMatrix;
  final Expression coords;

  TransformCoords({required this.transformMatrix, required this.coords}) {
    if (transformMatrix is Scalar || transformMatrix is Vector) {
      throw UndefinedOperationException();
    }

    if (coords is Scalar || coords is Matrix) {
      throw UndefinedOperationException();
    }
  }

  @override
  Expression simplify() {
    if (coords is Matrix || coords is Scalar) {
      throw UndefinedOperationException();
    }

    if (transformMatrix is Scalar || transformMatrix is Vector) {
      throw UndefinedOperationException();
    }

    if (coords is! Vector) {
      return TransformCoords(
        transformMatrix: transformMatrix,
        coords: coords.simplify(),
      );
    }

    if (transformMatrix is! Matrix) {
      return TransformCoords(
        transformMatrix: transformMatrix.simplify(),
        coords: coords,
      );
    }

    Matrix m = transformMatrix.simplify() as Matrix;
    // If the matrix contains non-computed expressions, return simplified
    if (m != transformMatrix) {
      return TransformCoords(transformMatrix: m, coords: coords);
    }

    Vector vectorCoords = coords as Vector;
    return Multiply(
      left: Matrix(
        rows: [vectorCoords],
        rowCount: 1,
        columnCount: vectorCoords.length,
      ),
      right: transformMatrix,
    );
  }

  @override
  String toTeX({Set<TexFlags>? flags}) =>
      'transformujSouřadnice(${transformMatrix.toTeX()}, ${coords.toTeX()})';
}
