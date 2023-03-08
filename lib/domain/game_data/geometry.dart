import 'dart:ui';

class AnnoOffset {
  const AnnoOffset(this.x, this.y);

  AnnoOffset.fromOffset(Offset offset)
      : x = offset.dx.toInt(),
        y = offset.dy.toInt();

  final int x;
  final int y;

  AnnoOffset operator +(AnnoOffset other) =>
      AnnoOffset(x + other.x, y + other.y);

  AnnoOffset operator -(AnnoOffset other) =>
      AnnoOffset(x - other.x, y - other.y);

  Offset get asOffset => Offset(x.toDouble(), y.toDouble());

  @override
  String toString() => 'AnnoOffset($x, $y)';
}

class AnnoRect {
  const AnnoRect(this.x, this.y, this.x1, this.y1);

  final int x;
  final int y;
  final int x1;
  final int y1;

  AnnoOffset toAnnoOffset() => AnnoOffset(x1 - x, y1 - y);

  AnnoOffset shiftOffset() => AnnoOffset(x, y);

  @override
  String toString() => 'AnnoRect($x, $y, $x1, $y1)';
}
