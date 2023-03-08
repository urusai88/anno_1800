import 'game_data.dart';

bool findLandCriteria(
  LandDataFile landData, {
  SessionId? bySessionId,
  LandElementTemplate? byElement,
}) {
  if (byElement != null) {
    final kind =
        landData.props.map((e) => e.asKind).whereType<LandPropertyKind>().first;

    switch (byElement.type) {
      case LandType.normal:
        if ([
          LandKind.small,
          LandKind.medium,
          LandKind.large,
        ].contains(kind.kind)) {
          return false;
        }
        break;
      case LandType.decoration:
        if (kind.kind != LandKind.decoration) {
          return false;
        }
        break;
      case LandType.starter:
        if ([
          LandKind.small,
          LandKind.medium,
          LandKind.large,
        ].contains(kind.kind)) {
          return false;
        }
        break;
      case LandType.pirateIsland:
      case LandType.thirdParty:
        if (kind.kind.isThirdParty) {
          return false;
        }
        break;
      case LandType.cliff:
        // TODO: Handle this case.
        break;
    }
  }

  if (bySessionId != null) {
    final props = landData.props
        .map((e) => e.asBiome)
        .whereType<LandPropertyBiome>()
        .map((e) => e.biome);
    const map = <SessionId, LandBiome>{
      SessionId.europe: LandBiome.europe,
      SessionId.america: LandBiome.america,
      SessionId.cape: LandBiome.cape,
      SessionId.arctic: LandBiome.arctic,
      SessionId.africa: LandBiome.africa,
    };

    return props.contains(map[bySessionId]!);
  }

  return true;
}
