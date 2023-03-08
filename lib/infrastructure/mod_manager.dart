import 'package:xml/xml.dart';

import '../domain/game_data/game_data.dart';

class ModManager {
  const ModManager();

  void save(SessionEntity session) {
    final xml = XmlBuilder();
    /*
    final t = XmlDataTransformer();

    void saveShip(ShipEntity ship) {
      xml.element('TemplateElement', nest: () {
        xml.element('ElementType',
            nest: () => xml.text(ElementType.shipPosition.id));
        xml.element('Element', nest: () {
          xml.element('Position',
              nest: () => xml.text(t.formatAnnoOffset(ship.position)));
        });
      });
    }

    void saveLand(LandEntity land) {
      xml.element('ElementType',
          nest: () => xml.text(land.specified
              ? ElementType.specifiedLand.id
              : ElementType.randomLand.id));
      xml.element('Element', nest: () {
        xml.element('Position',
            nest: () => xml.text(t.formatAnnoOffset(land.position)));

        if (land.mapFilePath != null) {
          xml.element('MapFilePath', nest: () => xml.text(land.mapFilePath!));
        }

        if (land.rotation90 != null) {
          xml.element('Rotation90', nest: () => xml.text(land.rotation90!.id));
        }

        if (land.landLabel != null) {
          xml.element('IslandLabel', nest: () => xml.text(land.landLabel!));
        }

        if (land.size != null) {
          xml.element('Size', nest: () => xml.text(land.size!.id));
        }
      });
    }

    void saveMapTemplate() {
      xml.element('Size',
          nest: () => xml.text(t.formatAnnoOffset(session.size)));
      xml.element('PlayableArea',
          nest: () => xml.text(t.formatAnnoRect(session.playable)));
      xml.element('RandomlyPlacedThirdParties');
      xml.element('ElementCount',
          nest: () => xml.text(session.lands.length + session.ships.length));

      for (final ship in session.ships) {
        xml.element('TemplateElement', nest: () => saveShip(ship));
      }

      for (final land in session.lands) {
        xml.element('TemplateElement', nest: () => saveLand(land));
      }
    }

    xml.element('Content', nest: () {
      xml.element('MapTemplate', nest: () {
        saveMapTemplate();
      });
    });

    final result = xml.buildDocument().toXmlString(pretty: true);

    print(xml.buildDocument().toXmlString(pretty: true));*/
  }
}
