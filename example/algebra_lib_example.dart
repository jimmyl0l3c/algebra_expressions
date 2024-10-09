import 'package:algebra_lib/algebra_lib.dart';
import 'package:big_fraction/big_fraction.dart';

void main() {
  var s1 = Scalar(BigFraction.from(5));
  var s2 = Scalar(BigFraction.from(6));
  var s3 = Multiply(left: s1, right: s2);
  print(s3.toTeX());
  print(s3.simplify().toTeX());

  var v1 = Vector(
    items: [
      Multiply(
        left: Scalar(BigFraction.from(2)),
        right: Scalar(BigFraction.from(3)),
      ),
      Multiply(
        left: Scalar(BigFraction.from(7)),
        right: Scalar(BigFraction.from(4)),
      ),
    ],
  );
  var v2 = Vector(
    items: [
      Scalar(BigFraction.from(3)),
      Scalar(BigFraction.from(4)),
    ],
  );
  printNSimplifications(v1, 4);
  print('\n');

  var multiply1 = Multiply(left: s1, right: v1);
  printNSimplifications(multiply1, 6);
  print('\n');

  var m1 = Matrix(
    rows: [
      Vector(items: [
        Scalar(BigFraction.from(2)),
        Scalar(BigFraction.from(3)),
      ]),
      Vector(items: [
        Scalar(BigFraction.from(4)),
        Scalar(BigFraction.from(5)),
      ]),
    ],
    rowCount: 2,
    columnCount: 2,
  );
  print(m1.toTeX());
  var multiply2 = Multiply(left: s1, right: m1);
  printNSimplifications(multiply2, 6);
  print('\n');

  var m2 = Matrix(
    rows: [
      Vector(items: [
        Scalar(BigFraction.from(6)),
        Scalar(BigFraction.from(7)),
      ]),
      Vector(items: [
        Scalar(BigFraction.from(9)),
        Scalar(BigFraction.from(8)),
      ]),
    ],
    rowCount: 2,
    columnCount: 2,
  );
  var multiply3 = Multiply(left: m1, right: m2);
  printNSimplifications(multiply3, 8);

  var m3 = Matrix(
    rows: [
      Vector(items: [
        Scalar(BigFraction.from(6)),
        Scalar(BigFraction.from(7)),
      ]),
      Vector(items: [
        Scalar(BigFraction.from(9)),
        Scalar(BigFraction.from(8)),
      ]),
      Vector(items: [
        Scalar(BigFraction.one()),
        Scalar(BigFraction.from(2)),
      ]),
      Vector(items: [
        Scalar(BigFraction.from(3)),
        Scalar(BigFraction.from(5)),
      ]),
    ],
    rowCount: 4,
    columnCount: 2,
  );
  print(m3.toTeX());
  var exchange = ExchangeRows(matrix: m3, row1: 1, row2: 3);
  printNSimplifications(exchange, 2);

  var addRow2Row = AddRowToRowNTimes(
    matrix: m3,
    origin: 2,
    target: 0,
    n: Scalar(BigFraction.from(-2)),
  );
  printNSimplifications(addRow2Row, 4);

  var multiplyRow = MultiplyRowByN(
    matrix: m3,
    n: Scalar(BigFraction.from(-3)),
    row: 1,
  );
  printNSimplifications(multiplyRow, 3);

  var divide = Divide(
    numerator: Multiply(left: Scalar(BigFraction.minusOne()), right: s1),
    denominator: s2,
  );
  printNSimplifications(divide, 3);

  print('\n');
  var triangular = Triangular(matrix: m3);
  print(triangular.toTeX());
  printNSimplifications(triangular, 54);

  var m4 = Matrix(
    rows: [
      Vector(items: [
        Scalar(BigFraction.zero()),
        Scalar(BigFraction.from(7)),
        Scalar(BigFraction.from(3))
      ]),
      Vector(items: [
        Scalar(BigFraction.from(3)),
        Scalar(BigFraction.from(8)),
        Scalar(BigFraction.from(2))
      ]),
      Vector(items: [
        Scalar(BigFraction.one()),
        Scalar(BigFraction.from(8)),
        Scalar(BigFraction.from(13))
      ]),
    ],
    rowCount: 3,
    columnCount: 3,
  );

  print('\n');
  var triangularDet = TriangularDet(det: m4);
  print(triangularDet.toTeX());
  printNSimplifications(triangularDet, 40);

  print('\n');
  var det = Determinant(det: m4);
  printNSimplifications(det, 40);

  print('\n');
  var transpose = Transpose(matrix: m3);
  print(transpose.toTeX());
  print(transpose.simplify().toTeX());

  print('\n');
  var inverse = Inverse(exp: m4);
  printNSimplifications(inverse, 114, addNewLine: true);

  var reduced = Reduce(exp: m3);
  printNSimplifications(reduced, 60, addNewLine: true);

  var rank = Rank(matrix: m3);
  printNSimplifications(rank, 60);

  var eqM = Matrix(
    rows: [
      Vector(items: [
        Scalar(BigFraction.one()),
        Scalar(BigFraction.from(2)),
      ]),
      Vector(items: [
        Scalar(BigFraction.from(4)),
        Scalar(BigFraction.from(5)),
      ]),
    ],
    rowCount: 2,
    columnCount: 2,
  );
  var vY = Vector(items: [
    Scalar(BigFraction.from(3)),
    Scalar(BigFraction.from(6)),
  ]);
  var eqSolution = SolveWithInverse(matrix: eqM, vectorY: vY);
  print(eqSolution.toTeX());
  printNSimplifications(eqSolution, 50);

  var basis = FindBasis(
      matrix: Matrix.fromVectors([
    Vector(items: [
      Scalar(BigFraction.one()),
      Scalar(BigFraction.from(2)),
      Scalar(BigFraction.from(3)),
    ]),
    Vector(items: [
      Scalar(BigFraction.from(4)),
      Scalar(BigFraction.from(5)),
      Scalar(BigFraction.from(6)),
    ]),
    Vector(items: [
      Scalar(BigFraction.from(7)),
      Scalar(BigFraction.from(3)),
      Scalar(BigFraction.from(2)),
    ]),
  ]));
  printNSimplifications(basis, 85);

  print('\n');
  var generalEq = GaussianElimination(
    matrix: Matrix.fromVectors([
      Vector(items: [
        Scalar(BigFraction.one()),
        Scalar(BigFraction.from(2)),
        Scalar(BigFraction.from(3)),
        Scalar(BigFraction.from(4)),
      ]),
      Vector(items: [
        Scalar(BigFraction.zero()),
        Scalar(BigFraction.one()),
        Scalar(BigFraction.from(7)),
        Scalar(BigFraction.from(3)),
      ]),
    ]),
  );
  printNSimplifications(generalEq, 85);

  print('\n');
  var independent = AreVectorsLinearlyIndependent(vectors: [
    Vector(items: [
      Scalar(BigFraction.one()),
      Scalar(BigFraction.from(2)),
      Scalar(BigFraction.from(3)),
      Scalar(BigFraction.from(4)),
    ]),
    Vector(items: [
      Scalar(BigFraction.zero()),
      Scalar(BigFraction.one()),
      Scalar(BigFraction.from(7)),
      Scalar(BigFraction.from(3)),
    ]),
  ]);
  printNSimplifications(independent, 60);

  var cramer = SolveWithCramer(
    matrix: Matrix.fromVectors([
      Vector(items: [
        Scalar(BigFraction.one()),
        Scalar(BigFraction.from(2)),
      ]),
      Vector(items: [
        Scalar(BigFraction.from(4)),
        Scalar(BigFraction.from(5)),
      ]),
    ]),
    vectorY: Vector(items: [
      Scalar(BigFraction.from(3)),
      Scalar(BigFraction.from(6)),
    ]),
  );
  printNSimplifications(cramer, 20);

  var transformMatrix = TransformMatrix(
    basisA: ExpressionSet(items: {
      Vector(items: [
        Scalar(BigFraction.from(-5)),
        Scalar(BigFraction.from(9)),
        Scalar(BigFraction.from(2)),
      ]),
      Vector(items: [
        Scalar(BigFraction.from(6)),
        Scalar(BigFraction.from(-10)),
        Scalar(BigFraction.from(5)),
      ]),
      Vector(items: [
        Scalar(BigFraction.minusOne()),
        Scalar(BigFraction.from(2)),
        Scalar(BigFraction.from(9)),
      ]),
    }),
    basisB: ExpressionSet(items: {
      Vector(items: [
        Scalar(BigFraction.zero()),
        Scalar(BigFraction.zero()),
        Scalar(BigFraction.from(-5)),
      ]),
      Vector(items: [
        Scalar(BigFraction.one()),
        Scalar(BigFraction.zero()),
        Scalar(BigFraction.from(2)),
      ]),
      Vector(items: [
        Scalar(BigFraction.from(-4)),
        Scalar(BigFraction.from(2)),
        Scalar(BigFraction.from(7)),
      ]),
    }),
  );
  // printNSimplifications(transformMatrix, 350);

  var transform = TransformCoords(
      transformMatrix: transformMatrix,
      coords: Vector(items: [
        Scalar(BigFraction.one()),
        Scalar(BigFraction.from(2)),
        Scalar(BigFraction.from(3)),
      ]));
  // printNSimplifications(transform, 360);
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
