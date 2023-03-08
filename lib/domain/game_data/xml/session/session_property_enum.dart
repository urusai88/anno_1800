import 'package:bless_annotation/bless_annotation.dart';

import '../../game_data.dart';

part 'session_property_enum.g.dart';

@BlessIt()
enum ElementType {
  specifiedLand(0),
  randomLand(1),
  shipPosition(2);

  const ElementType(this.id);

  final int id;

  static ElementType fromId(int id) {
    return ElementType.values.firstWhere((e) => e.id == id);
  }
}

@BlessIt()
enum LandTypeArea { config, randomConfig }

@BlessIt()
enum LandDifficulty {
  normal(0),
  hard(1);

  const LandDifficulty(this.id);

  final int id;

  static LandDifficulty fromId(String id) {
    const map = <String, LandDifficulty>{
      'Normal': LandDifficulty.normal,
      'Hard': LandDifficulty.hard,
    };

    if (map.containsKey(id)) {
      return map[id]!;
    }

    throw Exception([
      'Cannot match the difficulty $id',
      'Allowed values: ${map.keys}',
    ].join('\n'));
  }
}

@BlessIt()
enum LandType {
  normal(0),
  starter(1),
  decoration(2),
  thirdParty(3),
  pirateIsland(4),
  cliff(5);

  const LandType(this.id);

  final int id;

  static LandType fromId(String id) {
    const map = <String, LandType>{
      'Normal': LandType.normal,
      'Starter': LandType.starter,
      'Decoration': LandType.decoration,
      'ThirdParty': LandType.thirdParty,
      'PirateIsland': LandType.pirateIsland,
      'Pirate': LandType.pirateIsland,
      'Cliff': LandType.cliff,
    };

    if (map.containsKey(id.trim())) {
      return map[id]!;
    }

    // final index = LandType.values.indexWhere((e) => e.id == id);

    throw Exception([
      'Cannot match the type $id',
      'Allowed values: ${map.keys}',
    ].join('\n'));
  }
}

@BlessIt()
enum LandRotation90 {
  d0(0),
  d90(1),
  d180(2),
  d270(3);

  const LandRotation90(this.id);

  final int id;

  static LandRotation90 fromId(int id) =>
      LandRotation90.values.firstWhere((e) => e.id == id);

  double get angle {
    switch (this) {
      case LandRotation90.d0:
        return 0;
      case LandRotation90.d90:
        return 90;
      case LandRotation90.d180:
        return 180;
      case LandRotation90.d270:
        return 270;
    }
  }
}

@BlessIt()
enum LandSize {
  small(0, 'Small', 192),
  medium(1, 'Medium', 320),
  large(2, 'Large', 384);

  const LandSize(this.id, this.title, this.size);

  final int id;
  final String title;
  final int size;

  static LandSize fromValue(dynamic value) {
    final n = int.tryParse(value);
    if (n != null) {
      return LandSize.values.firstWhere((e) => e.id == n);
    }
    return LandSize.values.firstWhere((e) => e.title == value);
  }

  AnnoOffset toPoint2D() => AnnoOffset(size, size);
}
