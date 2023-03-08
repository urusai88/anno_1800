import 'package:anno_flutter/domain/game_data/xml/xml_transformer.dart';
import 'package:xml/xml.dart';

export 'package:anno_flutter/domain/game_data/xml/xml_transformer.dart';
export 'package:xml/xml.dart';

abstract class BaseXmlReader<T> {
  const BaseXmlReader({required this.transformer});

  final XmlTransformer transformer;

  T readXmlString(String str) => readXmlDocument(XmlDocument.parse(str));

  T readXmlDocument(XmlDocument doc);
}
