import 'dart:math';

import 'package:flutter/material.dart';

import 'redactor_view_painter_data.dart';

class RedactorViewPainter extends CustomPainter {
  RedactorViewPainter({
    required this.size,
    required this.outerBordersPath,
    required this.innerBordersPath,
    required this.drawData,
  });

  final Size size;
  final Path outerBordersPath;
  final Path innerBordersPath;
  final List<ElementDrawData> drawData;

  final _outerBorderPaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  final _innerBorderPaint = Paint()
    ..color = Colors.white.withOpacity(0.5)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  final _islandBorderPaint = Paint()
    ..color = Colors.green
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  final _islandBorderPaintSelected = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  final _shipPositionPaint = Paint()
    ..color = Colors.yellow
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    _drawSessionBorders(canvas);
    for (final drawData in drawData.whereType<LandDrawData>()) {
      _drawLand(canvas, drawData);
    }
    for (final drawData in drawData.whereType<ShipDrawData>()) {
      _drawShipPosition(canvas, drawData);
    }
  }

  void _drawSessionBorders(Canvas canvas) {
    canvas.drawPath(innerBordersPath, _innerBorderPaint);
    canvas.drawPath(outerBordersPath, _outerBorderPaint);
  }

  void _drawLand(Canvas canvas, LandDrawData drawData) {
    canvas.drawPath(
      drawData.path,
      drawData.selected ? _islandBorderPaintSelected : _islandBorderPaint,
    );
    final image = drawData.image;
    final scaleToX = drawData.scaleTo.dx;
    final scaleToY = drawData.scaleTo.dy;

    if (image != null) {
      var posX = drawData.position.dx;
      var posY = drawData.position.dy;

      final angle = (-drawData.rotation - 45) * pi / 180;
      final scaleX = scaleToX / image.width;
      final scaleY = scaleToY / image.height;
      final bi = _distance(0, 0, scaleToX, scaleToY);
      final biScale = bi / scaleToX;

      posX = posX - scaleToX / 2;
      posY = posY - bi + (bi - scaleToY) / 2;

      final centerX = posX + (scaleToX) / 2;
      final centerY = posY + (scaleToY) / 2;

      var rect = Rect.fromLTWH(posX, posY, scaleToX, scaleToY);

      canvas.save();
      canvas.translate(centerX, centerY);
      canvas.rotate(angle);
      canvas.translate(-centerX, -centerY);
      canvas.drawImageNine(
        image,
        Rect.zero,
        rect,
        Paint()..color = const Color.fromRGBO(0, 0, 0, 0.8),
      );
      canvas.restore();
    }
  }

  void _drawShipPosition(Canvas canvas, ShipDrawData drawData) {
    canvas.drawCircle(drawData.offset, drawData.radius, _shipPositionPaint);
  }

  double _distance(num x1, num y1, num x2, num y2) {
    var distancex = (x1 - x2).abs();
    var distancey = (y1 - y2).abs();
    return sqrt((distancex * distancex) + (distancey * distancey));
  }

  Offset _rotate(double x, double y, double ox, double oy, double angle) {
    return Offset(
      cos(angle) * (x - ox) - sin(angle) * (y - oy) + ox,
      sin(angle) * (x - ox) + cos(angle) * (y - oy) + oy,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
