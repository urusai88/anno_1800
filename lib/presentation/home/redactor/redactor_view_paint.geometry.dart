part of 'redactor_view_paint.dart';

extension RedactorViewPaintGeometryExtension on RedactorViewPaintState {
  double _deg2rad(num deg) => deg * pi / 180;

  double _distance(num x1, num y1, num x2, num y2) {
    var distancex = (x1 - x2).abs();
    var distancey = (y1 - y2).abs();
    return sqrt((distancex * distancex) + (distancey * distancey));
  }

  Offset _gameToScreen(Offset offset) {
    offset /= _factor;
    final rad = _deg2rad(-135);
    final dx = offset.dy;
    final dy = offset.dx;
    final o = Size(_side, _side).center(Offset.zero);
    final x1 = cos(rad) * (dx - o.dx) - sin(rad) * (dy - o.dy) + o.dx;
    final y1 = sin(rad) * (dx - o.dx) + cos(rad) * (dy - o.dy) + o.dy;

    return Offset(x1 + _sleep / 2, y1 + _sleep / 2);
  }

  Offset _screenToGame(Offset pos) {
    pos = pos - Offset(_sleep, _sleep) / 2;
    final dx = pos.dy;
    final dy = pos.dx;
    final rad = _deg2rad(-135);
    final o = Size(_side, _side).center(Offset.zero);
    final x1 = cos(rad) * (dx - o.dx) - sin(rad) * (dy - o.dy) + o.dx;
    final y1 = sin(rad) * (dx - o.dx) + cos(rad) * (dy - o.dy) + o.dy;

    return Offset(x1, y1) * _factor;
  }

  Offset _gameToScreenDouble(double x, double y) => _gameToScreen(Offset(x, y));

  Offset _screenToGameDouble(double x, double y) => _screenToGame(Offset(x, y));

  Path _pathFromPositionsGame(int x, int y, int x1, int y1) {
    return Path()
      ..moveTo(x.toDouble(), y.toDouble())
      ..lineTo(x1.toDouble(), y.toDouble())
      ..lineTo(x1.toDouble(), y1.toDouble())
      ..lineTo(x.toDouble(), y1.toDouble())
      ..lineTo(x.toDouble(), y.toDouble());
  }

  Path _pathFromPositionsGameToScreen(
    double x,
    double y,
    double x1,
    double y1,
  ) {
    /*x = x / _factor;
    y = y / _factor;
    x1 = x1 / _factor;
    y1 = y1 / _factor;*/

    final p = [
      _gameToScreenDouble(x, y),
      _gameToScreenDouble(x1, y),
      _gameToScreenDouble(x1, y1),
      _gameToScreenDouble(x, y1),
      _gameToScreenDouble(x, y),
    ];

    return Path()
      ..moveTo(p[0].dx, p[0].dy)
      ..lineTo(p[1].dx, p[1].dy)
      ..lineTo(p[2].dx, p[2].dy)
      ..lineTo(p[3].dx, p[3].dy)
      ..lineTo(p[0].dx, p[0].dy);
  }
}
