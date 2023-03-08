import 'game_data/xml/land/land_property.dart';
import 'game_data/xml/session/session_property.dart';

class AnnoTransformer {
  const AnnoTransformer._();

  static LandKind elementTypeToLandKind(LandType value) {
    const map = <LandType, LandKind>{
      LandType.decoration: LandKind.decoration,
      LandType.normal: LandKind.small,
      LandType.pirateIsland: LandKind.thirdParty,
      LandType.thirdParty: LandKind.thirdParty,
      LandType.starter: LandKind.small,
      LandType.cliff: LandKind.gas,
    };

    return map[value]!;
  }
}
