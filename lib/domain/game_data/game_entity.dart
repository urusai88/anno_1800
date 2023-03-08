import 'game_data.dart';

abstract class SessionEntity {
  const SessionEntity();

  String get name;

  AnnoOffset get size;

  AnnoRect get playable;

  SessionId get sessionId;

  List<LandEntity> get lands;

  List<ShipEntity> get ships;
}

abstract class ElementEntity {
  ElementEntity({required this.position});

  AnnoOffset position;
}

class LandEntity extends ElementEntity {
  LandEntity({
    this.name = 'Dummy island',
    required super.position,
    required this.image,
    // required this.kind,
    this.size,
    required this.sizeNum,
    this.rotation90,
    required this.rotation90num,
    required this.specified,
    this.mapFilePath,
    this.landLabel,
  });

  final String name;
  final LandSize? size;
  final AnnoOffset sizeNum;
  LandRotation90? rotation90;
  double rotation90num;
  final String? mapFilePath;
  final String? landLabel;

  final bool specified;

  // final LandKind kind;

  LandImage image;
}

class ShipEntity extends ElementEntity {
  ShipEntity({required super.position});
}
