// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'redactor_view_painter_data.dart';

// **************************************************************************
// BlessGenerator
// **************************************************************************

extension ElementDrawDataBlessExtension on ElementDrawData {
  bool get isShipDrawData => this is ShipDrawData;

  bool get isLandDrawData => this is LandDrawData;

  ShipDrawData? get asShipDrawData =>
      this is ShipDrawData ? this as ShipDrawData? : null;

  LandDrawData? get asLandDrawData =>
      this is LandDrawData ? this as LandDrawData? : null;

  TYPE map<TYPE>({
    required TYPE Function(ShipDrawData) shipDrawData,
    required TYPE Function(LandDrawData) landDrawData,
  }) {
    if (this is ShipDrawData) {
      return shipDrawData(this as ShipDrawData);
    } else if (this is LandDrawData) {
      return landDrawData(this as LandDrawData);
    }

    throw 'ERROR';
  }

  TYPE maybeMap<TYPE>({
    TYPE Function(ShipDrawData)? shipDrawData,
    TYPE Function(LandDrawData)? landDrawData,
    required TYPE Function(ElementDrawData) orElse,
  }) {
    if (this is ShipDrawData && shipDrawData != null) {
      return shipDrawData(this as ShipDrawData);
    } else if (this is LandDrawData && landDrawData != null) {
      return landDrawData(this as LandDrawData);
    } else {
      return orElse(this);
    }
  }
}

extension LandDrawDataBlessExtension on LandDrawData {
  LandDrawData copyWith({
    Path? path,
    bool? selected,
    Image? image,
    double? rotation,
    Offset? position,
    Offset? scaleTo,
  }) {
    return LandDrawData(
      path: path ?? this.path,
      selected: selected ?? this.selected,
      image: image ?? this.image,
      rotation: rotation ?? this.rotation,
      position: position ?? this.position,
      scaleTo: scaleTo ?? this.scaleTo,
    );
  }

  LandDrawData copyWithNull({
    bool? image,
  }) {
    return LandDrawData(
      path: path,
      selected: selected,
      image: image == true ? null : this.image,
      rotation: rotation,
      position: position,
      scaleTo: scaleTo,
    );
  }
}

extension ShipDrawDataBlessExtension on ShipDrawData {
  ShipDrawData copyWith({
    Offset? offset,
    double? radius,
  }) {
    return ShipDrawData(
      offset: offset ?? this.offset,
      radius: radius ?? this.radius,
    );
  }

  ShipDrawData copyWithNull() {
    return ShipDrawData(
      offset: offset,
      radius: radius,
    );
  }
}
