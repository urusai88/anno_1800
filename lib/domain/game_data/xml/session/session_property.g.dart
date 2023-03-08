// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_property.dart';

// **************************************************************************
// BlessGenerator
// **************************************************************************

extension MapSizesBlessExtension on MapSizes {
  MapSizes copyWith(
    MapIslandSize? mapSize,
    MapIslandSize? islandSize,
  ) {
    return MapSizes(
      mapSize ?? this.mapSize,
      islandSize ?? this.islandSize,
    );
  }

  MapSizes copyWithNull(
    bool? islandSize,
  ) {
    return MapSizes(
      mapSize,
      islandSize == true ? null : this.islandSize,
    );
  }
}

extension SessionPropertyBlessExtension on SessionProperty {
  bool get isArchetype => this is ArchetypeSessionProperty;

  bool get isNumber => this is NumberSessionProperty;

  bool get isSizeMap => this is SizeMapSessionProperty;

  bool get isMultiplayer => this is MultiplayerSessionProperty;

  bool get isSessionId => this is SessionIdSessionProperty;

  ArchetypeSessionProperty? get asArchetype => this is ArchetypeSessionProperty
      ? this as ArchetypeSessionProperty?
      : null;

  NumberSessionProperty? get asNumber =>
      this is NumberSessionProperty ? this as NumberSessionProperty? : null;

  SizeMapSessionProperty? get asSizeMap =>
      this is SizeMapSessionProperty ? this as SizeMapSessionProperty? : null;

  MultiplayerSessionProperty? get asMultiplayer =>
      this is MultiplayerSessionProperty
          ? this as MultiplayerSessionProperty?
          : null;

  SessionIdSessionProperty? get asSessionId => this is SessionIdSessionProperty
      ? this as SessionIdSessionProperty?
      : null;

  TYPE map<TYPE>({
    required TYPE Function(ArchetypeSessionProperty) archetype,
    required TYPE Function(NumberSessionProperty) number,
    required TYPE Function(SizeMapSessionProperty) sizeMap,
    required TYPE Function(MultiplayerSessionProperty) multiplayer,
    required TYPE Function(SessionIdSessionProperty) sessionId,
  }) {
    if (this is ArchetypeSessionProperty) {
      return archetype(this as ArchetypeSessionProperty);
    } else if (this is NumberSessionProperty) {
      return number(this as NumberSessionProperty);
    } else if (this is SizeMapSessionProperty) {
      return sizeMap(this as SizeMapSessionProperty);
    } else if (this is MultiplayerSessionProperty) {
      return multiplayer(this as MultiplayerSessionProperty);
    } else if (this is SessionIdSessionProperty) {
      return sessionId(this as SessionIdSessionProperty);
    }

    throw 'ERROR';
  }

  TYPE maybeMap<TYPE>({
    TYPE Function(ArchetypeSessionProperty)? archetype,
    TYPE Function(NumberSessionProperty)? number,
    TYPE Function(SizeMapSessionProperty)? sizeMap,
    TYPE Function(MultiplayerSessionProperty)? multiplayer,
    TYPE Function(SessionIdSessionProperty)? sessionId,
    required TYPE Function(SessionProperty) orElse,
  }) {
    if (this is ArchetypeSessionProperty && archetype != null) {
      return archetype(this as ArchetypeSessionProperty);
    } else if (this is NumberSessionProperty && number != null) {
      return number(this as NumberSessionProperty);
    } else if (this is SizeMapSessionProperty && sizeMap != null) {
      return sizeMap(this as SizeMapSessionProperty);
    } else if (this is MultiplayerSessionProperty && multiplayer != null) {
      return multiplayer(this as MultiplayerSessionProperty);
    } else if (this is SessionIdSessionProperty && sessionId != null) {
      return sessionId(this as SessionIdSessionProperty);
    } else {
      return orElse(this);
    }
  }
}

extension SessionIdSessionPropertyBlessExtension on SessionIdSessionProperty {
  SessionIdSessionProperty copyWith(
    SessionId? sessionId,
  ) {
    return SessionIdSessionProperty(
      sessionId ?? this.sessionId,
    );
  }

  SessionIdSessionProperty copyWithNull() {
    return SessionIdSessionProperty(
      sessionId,
    );
  }
}

extension MultiplayerSessionPropertyBlessExtension
    on MultiplayerSessionProperty {
  MultiplayerSessionProperty copyWith(
    bool? multiplayer,
  ) {
    return MultiplayerSessionProperty(
      multiplayer ?? this.multiplayer,
    );
  }

  MultiplayerSessionProperty copyWithNull() {
    return MultiplayerSessionProperty(
      multiplayer,
    );
  }
}

extension SizeMapSessionPropertyBlessExtension on SizeMapSessionProperty {
  SizeMapSessionProperty copyWith(
    MapSizes? mapSizes,
  ) {
    return SizeMapSessionProperty(
      mapSizes ?? this.mapSizes,
    );
  }

  SizeMapSessionProperty copyWithNull() {
    return SizeMapSessionProperty(
      mapSizes,
    );
  }
}

extension NumberSessionPropertyBlessExtension on NumberSessionProperty {
  NumberSessionProperty copyWith(
    int? number,
  ) {
    return NumberSessionProperty(
      number ?? this.number,
    );
  }

  NumberSessionProperty copyWithNull() {
    return NumberSessionProperty(
      number,
    );
  }
}

extension ArchetypeSessionPropertyBlessExtension on ArchetypeSessionProperty {
  ArchetypeSessionProperty copyWith(
    MapArchetype? archetype,
  ) {
    return ArchetypeSessionProperty(
      archetype ?? this.archetype,
    );
  }

  ArchetypeSessionProperty copyWithNull() {
    return ArchetypeSessionProperty(
      archetype,
    );
  }
}
