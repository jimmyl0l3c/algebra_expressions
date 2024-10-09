class ExpressionException implements Exception {}

class UndefinedOperationException implements ExpressionException {}

class MatrixMultiplySizeException implements ExpressionException {}

class VectorSizeMismatchException implements ExpressionException {}

class MatrixSizeMismatchException implements ExpressionException {}

class MatrixRowSizeMismatchException implements ExpressionException {}

class DeterminantNotSquareException implements ExpressionException {}

class DivisionByZeroException implements ExpressionException {}

class BasisSizeMismatchException implements ExpressionException {}

class VectorsNotIndependentException implements ExpressionException {}

class EquationsNotSolvableException implements ExpressionException {}
