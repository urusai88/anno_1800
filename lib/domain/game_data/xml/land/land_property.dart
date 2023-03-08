import 'package:bless_annotation/bless_annotation.dart';
import 'package:collection/collection.dart';

import 'land_property_enum.dart';

export 'land_property_enum.dart';

part 'land_property.g.dart';

@BlessIt()
abstract class LandProperty {
  const LandProperty(this.name);

  final String name;

  const factory LandProperty.biome(LandBiome biome) = LandPropertyBiome;

  const factory LandProperty.kind(LandKind kind) = LandPropertyKind;

  const factory LandProperty.number(int number) = LandPropertyNumber;

  const factory LandProperty.pirate(bool pirate) = LandPropertyPirate;

  static T? findInList<T extends LandProperty>(List<LandProperty> props) {
    return props.whereType<T>().firstOrNull;
  }
}

@BlessIt()
class LandPropertyBiome extends LandProperty {
  const LandPropertyBiome(this.biome) : super('biome');

  final LandBiome biome;
}

@BlessIt()
class LandPropertyKind extends LandProperty {
  const LandPropertyKind(this.kind) : super('kind');

  final LandKind kind;
}

@BlessIt()
class LandPropertyNumber extends LandProperty {
  const LandPropertyNumber(this.number) : super('number');

  final int number;
}

@BlessIt()
class LandPropertyPirate extends LandProperty {
  const LandPropertyPirate(this.pirate) : super('pirate');

  final bool pirate;
}
