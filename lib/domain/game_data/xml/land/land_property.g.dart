// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'land_property.dart';

// **************************************************************************
// BlessGenerator
// **************************************************************************

extension LandPropertyBlessExtension on LandProperty {
  bool get isPirate => this is LandPropertyPirate;

  bool get isNumber => this is LandPropertyNumber;

  bool get isKind => this is LandPropertyKind;

  bool get isBiome => this is LandPropertyBiome;

  LandPropertyPirate? get asPirate =>
      this is LandPropertyPirate ? this as LandPropertyPirate? : null;

  LandPropertyNumber? get asNumber =>
      this is LandPropertyNumber ? this as LandPropertyNumber? : null;

  LandPropertyKind? get asKind =>
      this is LandPropertyKind ? this as LandPropertyKind? : null;

  LandPropertyBiome? get asBiome =>
      this is LandPropertyBiome ? this as LandPropertyBiome? : null;

  TYPE map<TYPE>({
    required TYPE Function(LandPropertyPirate) pirate,
    required TYPE Function(LandPropertyNumber) number,
    required TYPE Function(LandPropertyKind) kind,
    required TYPE Function(LandPropertyBiome) biome,
  }) {
    if (this is LandPropertyPirate) {
      return pirate(this as LandPropertyPirate);
    } else if (this is LandPropertyNumber) {
      return number(this as LandPropertyNumber);
    } else if (this is LandPropertyKind) {
      return kind(this as LandPropertyKind);
    } else if (this is LandPropertyBiome) {
      return biome(this as LandPropertyBiome);
    }

    throw 'ERROR';
  }

  TYPE maybeMap<TYPE>({
    TYPE Function(LandPropertyPirate)? pirate,
    TYPE Function(LandPropertyNumber)? number,
    TYPE Function(LandPropertyKind)? kind,
    TYPE Function(LandPropertyBiome)? biome,
    required TYPE Function(LandProperty) orElse,
  }) {
    if (this is LandPropertyPirate && pirate != null) {
      return pirate(this as LandPropertyPirate);
    } else if (this is LandPropertyNumber && number != null) {
      return number(this as LandPropertyNumber);
    } else if (this is LandPropertyKind && kind != null) {
      return kind(this as LandPropertyKind);
    } else if (this is LandPropertyBiome && biome != null) {
      return biome(this as LandPropertyBiome);
    } else {
      return orElse(this);
    }
  }
}

extension LandPropertyBiomeBlessExtension on LandPropertyBiome {
  LandPropertyBiome copyWith(
    LandBiome? biome,
  ) {
    return LandPropertyBiome(
      biome ?? this.biome,
    );
  }

  LandPropertyBiome copyWithNull() {
    return LandPropertyBiome(
      biome,
    );
  }
}

extension LandPropertyKindBlessExtension on LandPropertyKind {
  LandPropertyKind copyWith(
    LandKind? kind,
  ) {
    return LandPropertyKind(
      kind ?? this.kind,
    );
  }

  LandPropertyKind copyWithNull() {
    return LandPropertyKind(
      kind,
    );
  }
}

extension LandPropertyNumberBlessExtension on LandPropertyNumber {
  LandPropertyNumber copyWith(
    int? number,
  ) {
    return LandPropertyNumber(
      number ?? this.number,
    );
  }

  LandPropertyNumber copyWithNull() {
    return LandPropertyNumber(
      number,
    );
  }
}

extension LandPropertyPirateBlessExtension on LandPropertyPirate {
  LandPropertyPirate copyWith(
    bool? pirate,
  ) {
    return LandPropertyPirate(
      pirate ?? this.pirate,
    );
  }

  LandPropertyPirate copyWithNull() {
    return LandPropertyPirate(
      pirate,
    );
  }
}
