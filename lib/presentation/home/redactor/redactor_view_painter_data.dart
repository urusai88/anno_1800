import 'dart:ui';

import 'package:bless_annotation/bless_annotation.dart';

part 'redactor_view_painter_data.g.dart';

@BlessIt()
abstract class ElementDrawData {
  const ElementDrawData();
}

@BlessIt()
class LandDrawData extends ElementDrawData {
  const LandDrawData({
    required this.path,
    required this.selected,
    required this.image,
    required this.rotation,
    required this.position,
    required this.scaleTo,
  });

  final Path path;
  final bool selected;
  final Image? image;
  final double rotation;
  final Offset position;
  final Offset scaleTo;
}

@BlessIt()
class ShipDrawData extends ElementDrawData {
  const ShipDrawData({required this.offset, required this.radius});

  final Offset offset;
  final double radius;
}
