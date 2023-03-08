import '../../game_data.dart';
import 'base_xml_reader.dart';

class LandXmlReader extends BaseXmlReader<LandTemplate> {
  const LandXmlReader({required super.transformer});

  @override
  LandTemplate readXmlDocument(XmlDocument doc) {
    final text = doc.getElement('Content')!.getElement('MapSize')!.text;
    final size = transformer.parseAnnoOffset(text);
    return LandTemplate(mapSize: size);
  }
}
