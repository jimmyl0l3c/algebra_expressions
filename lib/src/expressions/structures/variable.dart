import '../../interfaces/expression.dart';
import '../../tex_flags.dart';

class Variable implements Expression {
  final int index;
  final String symbol;

  Variable({required this.index, this.symbol = 'x'});

  @override
  Expression simplify() => this;

  @override
  String toTeX({Set<TexFlags>? flags}) => '${symbol}_{$index}';

  @override
  bool operator ==(Object other) {
    if (other is! Variable) return false;
    return other.index == index && other.symbol == symbol;
  }

  @override
  String toString() => '$symbol$index';

  @override
  int get hashCode => Object.hash(symbol, index);
}
