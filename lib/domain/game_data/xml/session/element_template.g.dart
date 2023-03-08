// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'element_template.dart';

// **************************************************************************
// BlessGenerator
// **************************************************************************

extension ElementTemplateBlessExtension on ElementTemplate {
  bool get isLand => this is LandElementTemplate;

  bool get isShip => this is ShipElementTemplate;

  LandElementTemplate? get asLand =>
      this is LandElementTemplate ? this as LandElementTemplate? : null;

  ShipElementTemplate? get asShip =>
      this is ShipElementTemplate ? this as ShipElementTemplate? : null;

  TYPE map<TYPE>({
    required TYPE Function(LandElementTemplate) land,
    required TYPE Function(ShipElementTemplate) ship,
  }) {
    if (this is LandElementTemplate) {
      return land(this as LandElementTemplate);
    } else if (this is ShipElementTemplate) {
      return ship(this as ShipElementTemplate);
    }

    throw 'ERROR';
  }

  TYPE maybeMap<TYPE>({
    TYPE Function(LandElementTemplate)? land,
    TYPE Function(ShipElementTemplate)? ship,
    required TYPE Function(ElementTemplate) orElse,
  }) {
    if (this is LandElementTemplate && land != null) {
      return land(this as LandElementTemplate);
    } else if (this is ShipElementTemplate && ship != null) {
      return ship(this as ShipElementTemplate);
    } else {
      return orElse(this);
    }
  }
}

extension ShipElementTemplateBlessExtension on ShipElementTemplate {
  ShipElementTemplate copyWith({
    AnnoOffset? position,
  }) {
    return ShipElementTemplate(
      position: position ?? this.position,
    );
  }

  ShipElementTemplate copyWithNull() {
    return ShipElementTemplate(
      position: position,
    );
  }
}

extension LandElementTemplateBlessExtension on LandElementTemplate {
  LandElementTemplate copyWith({
    AnnoOffset? position,
    LandType? type,
    LandTypeArea? area,
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
  }) {
    return LandElementTemplate(
      position: position ?? this.position,
      type: type ?? this.type,
      area: area ?? this.area,
      fertilityGuids: fertilityGuids ?? this.fertilityGuids,
      randomizeFertilities: randomizeFertilities ?? this.randomizeFertilities,
      label: label ?? this.label,
      mapFilePath: mapFilePath ?? this.mapFilePath,
      dataFile: dataFile ?? this.dataFile,
      mineSlotMapping: mineSlotMapping ?? this.mineSlotMapping,
      rotation90: rotation90 ?? this.rotation90,
      size: size ?? this.size,
      locked: locked ?? this.locked,
      difficulty: difficulty ?? this.difficulty,
    );
  }

  LandElementTemplate copyWithNull({
    bool? fertilityGuids,
    bool? randomizeFertilities,
    bool? label,
    bool? mapFilePath,
    bool? dataFile,
    bool? mineSlotMapping,
    bool? rotation90,
    bool? size,
    bool? locked,
    bool? difficulty,
  }) {
    return LandElementTemplate(
      position: position,
      type: type,
      area: area,
      fertilityGuids: fertilityGuids == true ? null : this.fertilityGuids,
      randomizeFertilities:
          randomizeFertilities == true ? null : this.randomizeFertilities,
      label: label == true ? null : this.label,
      mapFilePath: mapFilePath == true ? null : this.mapFilePath,
      dataFile: dataFile == true ? null : this.dataFile,
      mineSlotMapping: mineSlotMapping == true ? null : this.mineSlotMapping,
      rotation90: rotation90 == true ? null : this.rotation90,
      size: size == true ? null : this.size,
      locked: locked == true ? null : this.locked,
      difficulty: difficulty == true ? null : this.difficulty,
    );
  }
}
