import 'package:bless_annotation/bless_annotation.dart';

import '../../game_data.dart';

part 'land_template.g.dart';

@BlessIt()
class LandTemplate {
  const LandTemplate({required this.mapSize});

  final AnnoOffset mapSize;
}
