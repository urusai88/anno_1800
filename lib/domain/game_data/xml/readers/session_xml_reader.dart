import 'package:flutter/foundation.dart';

import '../../game_data.dart';
import 'base_xml_reader.dart';

class SessionXmlReader extends BaseXmlReader<SessionTemplate> {
  const SessionXmlReader({required super.transformer});

  @override
  SessionTemplate readXmlDocument(XmlDocument doc) {
    return _readMapTemplate(
      doc.getElement('Content')!.getElement('MapTemplate')!,
    );
  }

  SessionTemplate _readMapTemplate(XmlElement element) {
    AnnoOffset? size; // required
    AnnoRect? playable; // required
    AnnoRect? initPlayable;
    bool? enlargedTemplate;
    bool? randomlyPlacedThirdParties;

    List<ElementTemplate> elements = [];

    for (final child in element.childElements) {
      if (child.name.local == 'Size') {
        size = transformer.parseAnnoOffset(child.text);
      } else if (child.name.local == 'PlayableArea') {
        playable = transformer.parseAnnoRect(child.text);
      } else if (child.name.local == 'InitialPlayableArea') {
        initPlayable = transformer.parseAnnoRect(child.text);
      } else if (child.name.local == 'IsEnlargedTemplate') {
        enlargedTemplate = true;
      } else if (child.name.local == 'RandomlyPlacedThirdParties') {
        randomlyPlacedThirdParties = true;
      } else if (child.name.local == 'ElementCount') {
        continue;
      } else if (child.name.local == 'TemplateElement') {
        elements.add(_readElementTemplate(child));
      } else {
        if (kDebugMode) {
          print('${child.name}');
        }
      }
    }

    return SessionTemplate(
      size: size!,
      playable: playable!,
      initPlayable: initPlayable,
      enlargedTemplate: enlargedTemplate,
      randomlyPlacedThirdParties: randomlyPlacedThirdParties,
      elements: elements,
    );
  }

  ElementTemplate _readElementTemplate(XmlElement element) {
    ElementType elementType = ElementType.specifiedLand; // required
    AnnoOffset? position; // required
    LandType type = LandType.normal; // required
    LandTypeArea area = LandTypeArea.randomConfig; // required
    List<int>? fertilityGuids;
    bool? randomizeFertilities;
    String? label;
    String? mapFilePath;
    LandDataFile? dataFile;
    List<int>? mineSlotMapping;
    LandRotation90? rotation90;
    LandSize? size;
    bool? locked;
    LandDifficulty? difficulty;

    for (final child in element.childElements) {
      final text = child.text.trim();

      if (child.name.local == 'ElementType') {
        elementType = ElementType.fromId(int.parse(text));
      } else if (child.name.local == 'Element') {
        for (final child2 in child.childElements) {
          final text2 = child2.text.trim();

          if (child2.name.local == 'Position') {
            position = transformer.parseAnnoOffset(text2);
          } else if (child2.name.local == 'MapFilePath') {
            mapFilePath = text2;
          } else if (child2.name.local == 'Size') {
            size = LandSize.fromValue(text2);
          } else if (child2.name.local == 'Rotation90') {
            rotation90 = LandRotation90.fromId(int.parse(text2));
          } else if (child2.name.local == 'IslandLabel') {
            label = text2;
          } else if (child2.name.local == 'FertilityGuids') {
            if (text2.isNotEmpty) {
              fertilityGuids = transformer.parseList(text2);
            }
          } else if (child2.name.local == 'RandomizeFertilities') {
            randomizeFertilities = int.parse(text2) == 1;
          } else if (child2.name.local == 'Difficulty') {
            if (text2.isNotEmpty) {
              difficulty = LandDifficulty.fromId(text2);
            }
          } else if (child2.name.local == 'Locked') {
            locked = true;
          } else if (child2.name.local == 'Config') {
            for (final child3 in child2.childElements) {
              final idText = child3.getElement('id')?.text.trim();
              if (child3.name.local == 'Type') {
                if (idText != null && idText.isNotEmpty) {
                  type = LandType.fromId(idText);
                  area = LandTypeArea.config;
                }
              } else if (child3.name.local == 'Difficulty') {
                if (idText != null && idText.isNotEmpty) {
                  difficulty = LandDifficulty.fromId(idText);
                }
              } else {
                if (kDebugMode) {
                  print('${child2.name}');
                }
              }
            }
          } else if (child2.name.local == 'MineSlotMapping') {
            for (final child3 in child2.childElements) {
              if (child3.name.local == 'None') {
                mineSlotMapping ??= [];
                mineSlotMapping.add(int.parse(child3.text.trim()));
              } else {
                if (kDebugMode) {
                  print('${child3.name}');
                }
              }
            }
          } else if (child2.name.local == 'RandomIslandConfig') {
            for (final child3 in child2.getElement('value')!.childElements) {
              final text = child3.text.trim();
              if (child3.name.local == 'Type') {
                if (text.isNotEmpty) {
                  type = LandType.fromId(text);
                  area = LandTypeArea.randomConfig;
                }
              } else if (child3.name.local == 'Difficulty') {
                difficulty = LandDifficulty.fromId(text);
              } else {
                if (kDebugMode) {
                  print('${child3.name}');
                }
              }
            }
          }
        }
      } else {
        if (kDebugMode) {
          print('${child.name}');
        }
      }
    }

    ElementTemplate result;
    if (elementType.isShipPosition) {
      result = ElementTemplate.ship(position: position!);
    } else {
      result = ElementTemplate.land(
        position: position!,
        type: type,
        area: area,
        difficulty: difficulty,
        fertilityGuids: fertilityGuids,
        label: label,
        locked: locked,
        mineSlotMapping: mineSlotMapping,
        mapFilePath: mapFilePath,
        randomizeFertilities: randomizeFertilities,
        rotation90: rotation90,
        size: size,
      );
    }

    return result;
  }
}
