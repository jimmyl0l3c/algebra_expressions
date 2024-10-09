import '../../interfaces/expression.dart';
import '../../tex_flags.dart';

class Boolean implements Expression {
  final bool value;

  Boolean(this.value);

  @override
  Expression simplify() => this;

  @override
  String toTeX({Set<TexFlags>? flags}) => value ? 'Pravda' : 'Nepravda';

  @override
  String toString() => value.toString();

  @override
  bool operator ==(Object other) {
    if (other is! Boolean) return false;
    return other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
