import '../../xml/land/land_property.dart';

class LandPropertyReader {
  List<LandProperty> read(String path) {
    final parts = path.split('/').toList();
    var i = parts[1] != 'sessions' ? 1 : 0;
    final s1 = parts[4 + i];

    String name;
    if (const ['moderate', 'colony01'].contains(s1)) {
      name = parts[5 + i];
    } else {
      name = s1;
    }

    LandBiome? biome;
    if (parts[1] == 'dlc01') {
      biome = LandBiome.cape;
    }

    final props = <LandProperty>[];
    if (name == 'community_island') {
      props.addAll([
        const LandProperty.biome(LandBiome.europe),
        const LandProperty.kind(LandKind.large),
      ]);
    } else {
      final tagList = name.split('_');
      props.addAll([
        LandProperty.biome(biome ?? LandBiome.fromTag(tagList[0])),
        LandProperty.kind(LandKind.fromTag(tagList[1])),
        LandProperty.number(int.parse(tagList[2])),
      ]);

      if (name == 'moderate_3rdparty03_01' ||
          name == 'colony01_3rdparty04_01') {
        props.add(const LandProperty.pirate(true));
      }
    }

    return props;
  }
}
