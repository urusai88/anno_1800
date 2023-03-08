import 'package:bless_annotation/bless_annotation.dart';

import '../../game_data.dart';

part 'session_template.g.dart';

@BlessIt()
class SessionTemplate {
  const SessionTemplate({
    required this.size,
    required this.playable,
    this.initPlayable,
    this.enlargedTemplate,
    this.randomlyPlacedThirdParties,
    required this.elements,
  });

  final AnnoOffset size;
  final AnnoRect playable;
  final AnnoRect? initPlayable;
  final bool? enlargedTemplate;
  final bool? randomlyPlacedThirdParties;
  final List<ElementTemplate> elements;

  List<LandElementTemplate> get lands =>
      elements.whereType<LandElementTemplate>().toList();

  List<ShipElementTemplate> get shipPositions =>
      elements.whereType<ShipElementTemplate>().toList();
}
