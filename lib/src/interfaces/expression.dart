import '../tex_flags.dart';
import 'tex_parseable.dart';

class Expression implements TexParseable {
  Expression simplify() {
    throw UnimplementedError();
  }

  @override
  String toTeX({Set<TexFlags>? flags}) {
    throw UnimplementedError();
  }
}
