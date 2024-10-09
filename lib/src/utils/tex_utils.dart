import '../expressions/matrix_specific/add_row_to_row_n_times.dart';
import '../expressions/matrix_specific/exchange_rows.dart';
import '../expressions/matrix_specific/multiply_row_by_n.dart';
import '../interfaces/expression.dart';

class TexUtils {
  static String rowTransformToTeX(Expression exp, String transformation) {
    StringBuffer buffer = StringBuffer();

    if (exp is AddRowToRowNTimes ||
        exp is ExchangeRows ||
        exp is MultiplyRowByN) {
      String childStr = exp.toTeX();
      int arrEnd = childStr.lastIndexOf(r'\end{array}');

      buffer.write(childStr.substring(0, arrEnd));
      buffer.write(r' \\ ');
      buffer.write(transformation);
      buffer.write(r'\end{array}');
    } else {
      buffer.write(exp.toTeX());
      buffer.write(r'\begin{array}{c}');
      buffer.write(transformation);
      buffer.write(r'\end{array}');
    }

    return buffer.toString();
  }
}
