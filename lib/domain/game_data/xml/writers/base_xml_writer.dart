import '../../game_data.dart';

abstract class BaseXmlWriter {
  const BaseXmlWriter({required this.t});

  final XmlTransformer t;
}
