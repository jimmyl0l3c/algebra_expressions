import 'package:collection/collection.dart';

import '../../exceptions.dart';
import '../../interfaces/expression.dart';
import '../../tex_flags.dart';
import '../structures/scalar.dart';
import '../structures/vector.dart';
import 'commutative_group.dart';
import 'expression_set.dart';

class Matrix implements Expression {
  final List<Expression> rows;
  final int rowCount;
  final int columnCount;

  Matrix({
    required this.rows,
    required this.rowCount,
    required this.columnCount,
  }) {
    if (rows.any((r) => r is Scalar || r is Matrix || r is ExpressionSet)) {
      throw UndefinedOperationException();
    }

    if (rows.every((r) => r is Vector)) {
      if (rows.any(
        (r) => (r as Vector).length != (rows.first as Vector).length,
      )) {
        throw MatrixRowSizeMismatchException();
      }
    }
  }

  Expression operator [](int i) => rows[i];

  factory Matrix.fromVectors(List<Vector> vectors, {bool vertical = false}) {
    if (vectors.isNotEmpty &&
        vectors.any((v) => v.length != vectors.first.length)) {
      throw VectorSizeMismatchException();
    }

    if (vertical) {
      List<Expression> matrixRows = [];
      for (var r = 0; r < vectors.first.length; r++) {
        List<Expression> matrixRow = [];
        for (var c = 0; c < vectors.length; c++) {
          matrixRow.add(vectors[c][r]);
        }
        matrixRows.add(Vector(items: matrixRow));
      }
      return Matrix(
        rows: matrixRows,
        rowCount: matrixRows.length,
        columnCount: vectors.length,
      );
    }

    return Matrix(
      rows: vectors,
      rowCount: vectors.length,
      columnCount: vectors.first.length,
    );
  }

  factory Matrix.toEquationMatrix(Matrix matrix, Vector vectorY) {
    List<Expression> matrixRows = matrix.rows.mapIndexed((i, r) {
      Expression row = Vector(
        items: List.from((r as Vector).items)..add(vectorY[i]),
      );
      return row;
    }).toList();

    return Matrix(
      rows: matrixRows,
      rowCount: matrix.rowCount,
      columnCount: matrix.columnCount + 1,
    );
  }

  @override
  Expression simplify() {
    for (var r = 0; r < rowCount; r++) {
      if (rows[r] is Scalar || rows[r] is Matrix || rows[r] is ExpressionSet) {
        throw UndefinedOperationException();
      }

      if (rows[r] is! Vector) {
        return Matrix(
          rows: List.from(rows)
            ..removeAt(r)
            ..insert(r, rows[r].simplify()),
          rowCount: rowCount,
          columnCount: columnCount,
        );
      }

      Vector row = rows[r] as Vector;

      for (var c = 0; c < columnCount; c++) {
        if (row[c] is Vector || row[c] is Matrix || row[c] is ExpressionSet) {
          throw UndefinedOperationException();
        }

        if (row[c] is! Scalar) {
          List<Vector> simplifiedMatrix =
              rows.map((r) => Vector.from(r as Vector)).toList();
          simplifiedMatrix[r][c] = (rows[r] as Vector)[c].simplify();

          return Matrix(
            rows: simplifiedMatrix,
            rowCount: rowCount,
            columnCount: columnCount,
          );
        }
      }
    }
    return this;
  }

  @override
  String toTeX({Set<TexFlags>? flags}) {
    if (rows.isEmpty) return '()';

    StringBuffer buffer = StringBuffer();

    if (flags != null && flags.contains(TexFlags.dontEnclose)) {
      buffer.write(r'\begin{matrix}');
    } else {
      buffer.write(r'\begin{pmatrix}');
    }

    buffer.write(
      rows
          .map((row) => row is Vector
              ? row.items
                  .map((c) => c.toTeX(flags: {
                        if (c is CommutativeGroup) TexFlags.dontEnclose,
                      }))
                  .join(' & ')
              : row.toTeX())
          .join(r' \\ '),
    );

    if (flags != null && flags.contains(TexFlags.dontEnclose)) {
      buffer.write(r'\end{matrix}');
    } else {
      buffer.write(r'\end{pmatrix}');
    }
    return buffer.toString();
  }

  @override
  String toString() => "[${rows.map((e) => e.toString()).join("; ")}]";

  @override
  bool operator ==(Object other) {
    if (other is! Matrix ||
        other.rowCount != rowCount ||
        other.columnCount != columnCount) {
      return false;
    }
    for (var r = 0; r < rowCount; r++) {
      if (rows[r] != other[r]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(rows);
}
