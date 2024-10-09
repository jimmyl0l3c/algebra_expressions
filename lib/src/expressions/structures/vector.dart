import '../../interfaces/expression.dart';
import '../../tex_flags.dart';
import 'commutative_group.dart';

class Vector implements Expression {
  final List<Expression> items;

  Vector({required this.items});

  Vector.from(Vector other) : items = List.from(other.items);

  int get length => items.length;

  Expression operator [](int i) => items[i];

  void operator []=(int i, Expression e) => items[i] = e;

  @override
  Expression simplify() {
    for (var i = 0; i < items.length; i++) {
      var item = items[i];
      var simplifiedItem = item.simplify();

      if (item != simplifiedItem) {
        return Vector(
          items: List.from(items)
            ..removeAt(i)
            ..insert(i, simplifiedItem),
        );
      }
    }
    return this;
  }

  @override
  String toTeX({Set<TexFlags>? flags}) {
    StringBuffer buffer = StringBuffer(r'\begin{pmatrix} ');

    buffer.write(items
        .map((e) => e.toTeX(flags: {
              if (e is CommutativeGroup) TexFlags.dontEnclose,
            }))
        .join(' & '));

    buffer.write(r' \end{pmatrix}');
    return buffer.toString();
  }

  @override
  String toString() => "(${items.map((e) => e.toString()).join(" ")})";

  @override
  bool operator ==(Object other) {
    if (other is! Vector || other.length != length) return false;

    for (var i = 0; i < length; i++) {
      if (this[i] != other[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(items);
}
