import 'package:bless_annotation/bless_annotation.dart';

import '../../game_data.dart';

part 'element_template.g.dart';

@BlessIt()
abstract class ElementTemplate {
  const ElementTemplate({required this.position});

  const factory ElementTemplate.land({
    required AnnoOffset position,
    required LandType type,
    required LandTypeArea area,
    List<int>? fertilityGuids,
    bool? randomizeFertilities,
    String? label,
    String? mapFilePath,
    LandDataFile? dataFile,
    List<int>? mineSlotMapping,
    LandRotation90? rotation90,
    LandSize? size,
    bool? locked,
    LandDifficulty? difficulty,
  }) = LandElementTemplate;

  const factory ElementTemplate.ship({required AnnoOffset position}) =
      ShipElementTemplate;

  final AnnoOffset position;
}

@BlessIt()
class ShipElementTemplate extends ElementTemplate {
  const ShipElementTemplate({required super.position});
}

@BlessIt()
class LandElementTemplate extends ElementTemplate {
  const LandElementTemplate({
    required super.position,
    required this.type,
    required this.area,
    this.fertilityGuids,
    this.randomizeFertilities,
    this.label,
    this.mapFilePath,
    this.dataFile,
    this.mineSlotMapping,
    this.rotation90,
    this.size,
    this.locked,
    this.difficulty,
  });

  final List<int>? fertilityGuids;
  final bool? randomizeFertilities;
  final String? label;
  final String? mapFilePath;
  final LandDataFile? dataFile;
  final List<int>? mineSlotMapping;
  final LandRotation90? rotation90;
  final LandSize? size;
  final bool? locked;
  final LandType type;
  final LandTypeArea area;
  final LandDifficulty? difficulty;
}
