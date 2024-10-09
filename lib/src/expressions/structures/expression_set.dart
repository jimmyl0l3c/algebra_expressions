import '../../interfaces/expression.dart';
import '../../tex_flags.dart';

class ExpressionSet implements Expression {
  final Set<Expression> items;

  ExpressionSet({required this.items});

  int length() => items.length;

  @override
  Expression simplify() {
    for (var item in items) {
      Expression simplified = item.simplify();
      if (simplified != item) {
        return ExpressionSet(
          items: Set.from(items)
            ..remove(item)
            ..add(simplified),
        );
      }
    }

    return this;
  }

  @override
  String toTeX({Set<TexFlags>? flags}) {
    StringBuffer buffer = StringBuffer(r'\{');

    buffer.write(items.map((e) => e.toTeX()).join(', '));

    buffer.write(r'\}');
    return buffer.toString();
  }

  @override
  bool operator ==(Object other) {
    if (other is! ExpressionSet || other.length() != length()) return false;

    for (var item in items) {
      if (!other.items.contains(item)) return false;
    }

    return true;
  }

  @override
  int get hashCode => Object.hashAllUnordered(items);
}
