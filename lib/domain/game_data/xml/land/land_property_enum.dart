import 'package:bless_annotation/bless_annotation.dart';

part 'land_property_enum.g.dart';

@BlessIt()
enum LandBiome {
  europe,
  cape,
  america,
  africa,
  arctic;

  factory LandBiome.fromTag(String tag) {
    const map = <String, LandBiome>{
      'moderate': LandBiome.europe,
      'colony01': LandBiome.america,
      'colony02': LandBiome.africa,
      'colony03': LandBiome.arctic,
    };

    if (map.containsKey(tag)) {
      return map[tag]!;
    }

    throw Exception('value for tag $tag not found');
  }
}

@BlessIt()
enum LandKind {
  small,
  medium,
  large,
  decoration,
  dst,
  thirdParty,
  storyIsland,
  settlement,
  strandedsailor,
  battlesite,
  continental,
  gas,
  encounter;

  factory LandKind.fromTag(String tag) {
    const map = <String, LandKind>{
      's': LandKind.small,
      'm': LandKind.medium,
      'l': LandKind.large,
      'd': LandKind.decoration,
      r'3rdparty\d*': LandKind.thirdParty,
      'storyisland': LandKind.storyIsland,
      'settlement': LandKind.settlement,
      'strandedsailor': LandKind.strandedsailor,
      'c': LandKind.continental,
      'encounter': LandKind.encounter,
      'battlesite': LandKind.battlesite,
      'dst': LandKind.dst,
      r'a02+': LandKind.gas,
      r'a01+': LandKind.small,
      r'a03+': LandKind.continental,
    };

    for (final pair in map.entries) {
      final re = RegExp('^${pair.key}\$');
      final match = re.firstMatch(tag);
      if (match != null) {
        return pair.value;
      }
    }

    throw Exception('value for tag $tag not found');
  }

  @override
  String toString() => name;
}
