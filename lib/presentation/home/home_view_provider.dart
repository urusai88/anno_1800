import 'dart:math';

import 'package:anno_flutter/infrastructure/mod_manager.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../anno_flutter.dart';
import '../../domain/game_data/game_data.dart';
import '../../domain/game_data/xml/writers/session_xml_writer.dart';
import 'dialogs/new_session_dialog.dart';

class HomeViewProvider extends ChangeNotifier {
  HomeViewProvider({required this.gameDataProvider, required this.mod});

  final GameDataProvider gameDataProvider;
  final ModManager mod;

  final Map<String, _SessionEntityImpl> _sessions = {};

  Map<String, SessionEntity> get sessions => UnmodifiableMapView(_sessions);

  List<AnnoOffset> computeShipPositionsFromSize(AnnoOffset size) {
    final center = AnnoOffset(size.x ~/ 2, size.y ~/ 2);
    final deltaX = (size.x / 2.5) ~/ 2;
    final deltaY = (size.y / 2.5) ~/ 2;

    return [
      AnnoOffset(center.x + deltaX, center.y + deltaY),
      AnnoOffset(center.x + deltaX, center.y - deltaY),
      AnnoOffset(center.x - deltaX, center.y - deltaY),
      AnnoOffset(center.x - deltaX, center.y + deltaY),
    ];
  }

  void newSession(NewSessionSuccess success) {
    _sessions[success.name] = _SessionEntityImpl(
      name: success.name,
      size: success.size,
      playable: success.playable,
      lands: [],
      sessionId: success.sessionId,
      ships: computeShipPositionsFromSize(success.playable.toAnnoOffset())
          .map((e) => ShipEntity(position: e + success.playable.shiftOffset()))
          .toList(),
    );

    notifyListeners();
  }

  void openSession(List<SessionProperty> props, AppLocalizations loc) {
    final gameData = gameDataProvider.value.asSuccess;
    if (gameData == null) {
      return;
    }
    final sessionDataFile = gameDataProvider.findSessionByProperties(props);
    if (sessionDataFile == null) {
      return;
    }

    final name = loc.buildNameForSessionDataFile(sessionDataFile);
    final sessionTemplate = sessionDataFile.template.copyWith();

    final size = sessionTemplate.size;
    final playable = sessionTemplate.playable;

    final elements = <LandEntity>[];
    final shipPositionElements = <ShipEntity>[];

    for (final landTemplate in sessionTemplate.lands) {
      LandDataFile? dataFile;
      LandKind kind;
      LandSize? size;
      LandRotation90? rotation90;
      double rotation90num;
      AnnoOffset sizeNum;
      LandImage image;

      if (landTemplate.mapFilePath != null) {
        dataFile = gameData.findLandDataFile(landTemplate.mapFilePath!);
      }

      if (dataFile != null) {
        kind = dataFile.props.firstWhere((e) => e.isKind).asKind!.kind;
      } else {
        kind = AnnoTransformer.elementTypeToLandKind(landTemplate.type);
      }

      rotation90 = landTemplate.rotation90 ?? LandRotation90.d0;
      rotation90num = rotation90.angle;

      if (dataFile == null) {
        size = landTemplate.size;
        sizeNum = (size ?? LandSize.small).toPoint2D();
      } else {
        sizeNum = dataFile.template.mapSize;
      }

      if (dataFile != null) {
        image = resolveLandImageFromDataFilePath(dataFile.path);
      } else {
        image = resolveLandImageFromProperties(
          sessionId: sessionDataFile.sessionId,
          landElementTemplate: landTemplate,
        );
      }

      elements.add(
        LandEntity(
          position: landTemplate.position,
          image: image,
          size: size,
          sizeNum: sizeNum,
          rotation90: rotation90,
          rotation90num: rotation90num,
          specified: false,
        ),
      );
    }

    for (final shipPositionElement in sessionTemplate.shipPositions) {
      shipPositionElements.add(
        ShipEntity(position: shipPositionElement.position),
      );
    }

    _sessions[name] = _SessionEntityImpl(
      sessionId: sessionDataFile.sessionId,
      name: name,
      size: size,
      playable: playable,
      lands: elements,
      ships: shipPositionElements,
    );

    notifyListeners();
  }

  void close(SessionEntity session) {
    _sessions.removeWhere((_, e) => e == session);
    notifyListeners();
  }

  LandDataFile? resolveLandDataFile({
    required SessionId sessionId,
    List<LandKind>? kind,
    bool? pirate,
  }) {
    final gameData = gameDataProvider.value.asSuccess!;
    return gameData.findLandDataFileByCriteria((dataFile) {
      final biome = dataFile.props.whereType<LandPropertyBiome>().first.biome;
      final map = {
        SessionId.europe: [LandBiome.europe, LandBiome.cape],
        SessionId.africa: [LandBiome.africa],
        SessionId.cape: [LandBiome.europe, LandBiome.cape],
        SessionId.america: [LandBiome.america],
        SessionId.arctic: [LandBiome.arctic],
      };

      if (!map[sessionId]!.contains(biome)) {
        return false;
      }

      if (kind != null) {
        if (!kind.contains(
            dataFile.props.whereType<LandPropertyKind>().first.kind)) {
          return false;
        }
      }
      if (pirate != null) {
        final pirateProp =
            dataFile.props.whereType<LandPropertyPirate>().firstOrNull;
        final p = pirateProp?.pirate ?? false;
        if (p != pirate) {
          return false;
        }
      }

      return true;
    });
  }

  LandImage resolveLandImageFromDataFilePath(String landDataFilePath) {
    final gameData = gameDataProvider.value.asSuccess!;
    final landDataFile = gameData.findLandDataFile(landDataFilePath)!;
    return gameData.images[landDataFile.imagePath]!;
  }

  LandImage resolveLandImageFromDataFile(LandDataFile landDataFile) {
    final gameData = gameDataProvider.value.asSuccess!;
    return gameData.images[landDataFile.imagePath]!;
  }

  LandImage resolveLandImageFromProperties({
    required SessionId sessionId,
    LandElementTemplate? landElementTemplate,
  }) {
    final gameData = gameDataProvider.value.asSuccess!;
    final landDataFileList = gameData.lands;

    bool criteria(LandDataFile landDataFile) {
      return findLandCriteria(
        landDataFile,
        bySessionId: sessionId,
        byElement: landElementTemplate,
      );
    }

    final filtered = landDataFileList.where(criteria);
    final land = filtered.elementAt(Random().nextInt(filtered.length - 1));
    return gameData.images[land.imagePath]!;
  }

  void addThirdPartyLand(String sessionName, bool pirateLand) {
    final session = _assertSession(sessionName);
    final dataFile = resolveLandDataFile(
      sessionId: session.sessionId,
      pirate: pirateLand,
      kind: const [LandKind.thirdParty],
    );
    if (dataFile == null) {
      return print('dataFile == null');
    }
    final land = LandEntity(
      position: const AnnoOffset(0, 0),
      image: resolveLandImageFromDataFile(dataFile),
      sizeNum: dataFile.template.mapSize,
      rotation90num: LandRotation90.d0.angle,
      specified: false,
    );
    session.lands.add(land);
    notifyListeners();
  }

  void addDecorationLand(String sessionName) {
    final session = _assertSession(sessionName);
    final dataFile = resolveLandDataFile(
      sessionId: session.sessionId,
      kind: const [LandKind.decoration, LandKind.dst],
    );
    if (dataFile == null) {
      return print('dataFile == null');
    }
    final land = LandEntity(
      position: const AnnoOffset(0, 0),
      image: resolveLandImageFromProperties(sessionId: session.sessionId),
      sizeNum: dataFile.template.mapSize,
      rotation90num: LandRotation90.d0.angle,
      specified: false,
    );
    session.lands.add(land);
    notifyListeners();
  }

  void addRandomLand(String sessionName, LandSize landSize) {
    final session = _assertSession(sessionName);
    final land = LandEntity(
      position: const AnnoOffset(0, 0),
      image: resolveLandImageFromProperties(sessionId: session.sessionId),
      size: landSize,
      sizeNum: landSize.toPoint2D(),
      rotation90num: LandRotation90.d0.angle,
      specified: false,
    );

    session.lands.add(land);
    notifyListeners();
  }

  bool removeLand(String sessionName, LandEntity land) {
    final session = _assertSession(sessionName);
    if (!session.lands.contains(land)) {
      return false;
    }
    session.lands.remove(land);
    notifyListeners();
    return true;
  }

  void addLand(String sessionName, LandDataFile landDataFile) {
    final session = _assertSession(sessionName);
    final land = LandEntity(
      position: const AnnoOffset(0, 0),
      image: resolveLandImageFromDataFilePath(landDataFile.path),
      sizeNum: landDataFile.template.mapSize,
      rotation90: LandRotation90.d0,
      rotation90num: LandRotation90.d0.angle,
      specified: true,
    );

    session.lands.add(land);
    notifyListeners();
  }

  void updateLandRotation(
    String sessionName,
    LandEntity land,
    LandRotation90 rotation90,
  ) {
    final session = _assertSession(sessionName);
    if (!session.lands.contains(land)) {
      return;
    }
    land.rotation90 = rotation90;
    land.rotation90num = rotation90.angle;
    notifyListeners();
  }

  void updateElementPosition(
    String sessionName,
    ElementEntity element,
    AnnoOffset position,
  ) {
    final session = sessions[sessionName];
    if (session == null) {
      return;
    }
    final ship = element is ShipEntity ? element : null;
    final land = element is LandEntity ? element : null;

    if (land != null) {
      if (session.lands.contains(land)) {
        land.position = position;
      }
    } else if (ship != null) {
      if (session.ships.contains(ship)) {
        ship.position = position;
      }
    }

    notifyListeners();
  }

  _SessionEntityImpl _assertSession(String sessionName) {
    final session = _sessions[sessionName];
    assert(session != null);
    return session!;
  }

  void save(String sessionName) {
    final session = _assertSession(sessionName);
    final writer = SessionXmlWriter(t: XmlTransformer());
    final string = writer.writeDocument(session);

    print(string);

    // mod.save(session);
  }
}

class _SessionEntityImpl implements SessionEntity {
  _SessionEntityImpl({
    required this.name,
    required this.size,
    required this.playable,
    required this.sessionId,
    required this.lands,
    required this.ships,
  });

  @override
  String name;

  @override
  AnnoOffset size;

  @override
  AnnoRect playable;

  @override
  SessionId sessionId;

  @override
  List<LandEntity> lands;

  @override
  List<ShipEntity> ships;
}
