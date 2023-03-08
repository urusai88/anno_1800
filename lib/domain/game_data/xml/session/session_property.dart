import 'package:bless_annotation/bless_annotation.dart';
import 'package:equatable/equatable.dart';

import '../../game_data.dart';

export 'session_property_enum.dart';

part 'session_property.g.dart';

enum MapIslandSize {
  large('l'),
  medium('m'),
  small('s');

  const MapIslandSize(this.code);

  factory MapIslandSize.fromCode(String code) =>
      MapIslandSize.values.firstWhere((e) => e.code == code);

  final String code;
}

enum MapArchetype {
  europe,
  europeArchipel('archipel'),
  europeAtoll('atoll'),
  europeCorners('corners'),
  europeSnowflake('snowflake'),
  europeIslandArc('islandarc');

  const MapArchetype([this.code = '']);

  factory MapArchetype.fromCode(String code) {
    try {
      return MapArchetype.values.firstWhere((e) => e.code == code);
    } on StateError catch (_) {
      throw Exception('StateError $code');
    }
  }

  final String code;
}

@BlessIt()
class MapSizes with EquatableMixin {
  const MapSizes(
    this.mapSize, [
    this.islandSize,
  ]);

  final MapIslandSize mapSize;
  final MapIslandSize? islandSize;

  factory MapSizes.fromCode(String code) {
    final codes = code.split('');
    if (codes.length != 1 && codes.length != 2) {
      throw StateError('code.length must be 1 or 2');
    }
    return MapSizes(
      MapIslandSize.fromCode(codes[0]),
      codes.length > 1 ? MapIslandSize.fromCode(codes[1]) : null,
    );
  }

  @override
  List<Object?> get props => [mapSize, islandSize];
}

@BlessIt()
abstract class SessionProperty {
  static const List<Type> priority = [
    SessionIdSessionProperty,
    ArchetypeSessionProperty,
    SizeMapSessionProperty,
    NumberSessionProperty,
    MultiplayerSessionProperty,
  ];

  const SessionProperty();

  String get name;

  const factory SessionProperty.sessionId(SessionId value) =
      SessionIdSessionProperty;

  const factory SessionProperty.multiplayer(bool value) =
      MultiplayerSessionProperty;

  const factory SessionProperty.size(MapSizes value) = SizeMapSessionProperty;

  const factory SessionProperty.number(int value) = NumberSessionProperty;

  const factory SessionProperty.archetype(MapArchetype value) =
      ArchetypeSessionProperty;

  static void sort(List<SessionProperty> props) {
    props.sort((a, b) {
      return priority
          .indexOf(a.runtimeType)
          .compareTo(priority.indexOf(b.runtimeType));
    });
  }
}

@BlessIt()
class SessionIdSessionProperty extends SessionProperty with EquatableMixin {
  const SessionIdSessionProperty(this.sessionId);

  final SessionId sessionId;

  @override
  final String name = 'sessionId';

  @override
  List<Object?> get props => [sessionId];
}

@BlessIt()
class MultiplayerSessionProperty extends SessionProperty with EquatableMixin {
  const MultiplayerSessionProperty(this.multiplayer);

  final bool multiplayer;

  @override
  final String name = 'multiplayer';

  @override
  List<Object?> get props => [multiplayer];
}

@BlessIt()
class SizeMapSessionProperty extends SessionProperty with EquatableMixin {
  const SizeMapSessionProperty(this.mapSizes);

  final MapSizes mapSizes;

  @override
  final String name = 'size';

  @override
  List<Object?> get props => [mapSizes];
}

@BlessIt()
class NumberSessionProperty extends SessionProperty with EquatableMixin {
  const NumberSessionProperty(this.number);

  final int number;

  @override
  final String name = 'number';

  @override
  List<Object?> get props => [number];
}

@BlessIt()
class ArchetypeSessionProperty extends SessionProperty with EquatableMixin {
  const ArchetypeSessionProperty(this.archetype);

  final MapArchetype archetype;

  @override
  final String name = 'archetype';

  @override
  List<Object?> get props => [archetype];
}
