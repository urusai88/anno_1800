import 'dart:math';

import 'package:flutter/material.dart';

import '../../../anno_flutter.dart';
import '../../../domain/game_data/game_data.dart';
import 'redactor_view.dart';
import 'redactor_view_painter.dart';
import 'redactor_view_painter_data.dart';

part 'redactor_view.gestures.dart';

part 'redactor_view_paint.geometry.dart';

class RedactorViewPaint extends StatefulWidget {
  const RedactorViewPaint({
    super.key,
    required this.session,
    required this.focusedLand,
    required this.focusedShip,
  });

  final SessionEntity session;
  final LandEntity? focusedLand;
  final ShipEntity? focusedShip;

  @override
  State<RedactorViewPaint> createState() => RedactorViewPaintState();

  static RedactorViewPaintState of(BuildContext context) =>
      context.findAncestorStateOfType<RedactorViewPaintState>()!;
}

class RedactorViewPaintState extends State<RedactorViewPaint> {
  final transformationController = TransformationController();

  Size? _latestSize;

  late double _size;

  /// Во сколько нужно умножить размер окна что бы получить размер карты
  late double _factor;

  /// Длина грани
  late double _side;
  late double _sleep;
  late Rect _inner;

  late double _bi;

  late Path _outerBordersGamePath;
  late Path _outerBordersScreenPath;

  late Path _innerBordersGamePath;
  late Path _innerBordersScreenPath;

  final _elementDrawData = <ElementEntity, ElementDrawData>{};

  void _computeBasicGeometry(Size size) {
    final p1 = size.topLeft(Offset.zero);
    final p2 = size.bottomRight(Offset.zero);
    _bi = _distance(p1.dx, p1.dy, p2.dx, p2.dy);
    _size = size.width;
    _side = size.width * (size.width / _bi);
    _sleep = size.width - _side;
    _inner = Rect.fromLTWH(0 + _sleep / 2, 0 + _sleep / 2, _side, _side);
    _factor = widget.session.size.x / _inner.width;
  }

  void _computeItemGeometry() {
    _computeSessionBorders();
    _elementDrawData.clear();
    for (final land
        in widget.session.lands.where((e) => e != widget.focusedLand)) {
      _computeLand(land);
    }
    if (widget.focusedLand != null) {
      _computeLand(widget.focusedLand!);
    }
    for (final shipPosition in widget.session.ships) {
      _computeShipPosition(shipPosition);
    }
  }

  void _computeLand(LandEntity land) {
    final images = context.read<GameDataProvider>().value.asSuccess!.images;
    final imageSize = land.sizeNum.asOffset / _factor;

    _elementDrawData[land] = LandDrawData(
      path: _pathFromPositionsGameToScreen(
        land.position.x.toDouble(),
        land.position.y.toDouble(),
        (land.position.x + land.sizeNum.x).toDouble(),
        (land.position.y + land.sizeNum.y).toDouble(),
      ),
      selected: widget.focusedLand == land,
      image: land.image.image,
      rotation: land.rotation90num,
      scaleTo: imageSize,
      position: _gameToScreen(land.position.asOffset),
    );
  }

  void _computeShipPosition(ShipEntity shipPosition) {
    _elementDrawData[shipPosition] = ShipDrawData(
      offset: _gameToScreen(
        Offset(
          shipPosition.position.x.toDouble(),
          shipPosition.position.y.toDouble(),
        ),
      ),
      radius: 3,
    );
  }

  void _computeSessionBorders() {
    final pa = widget.session.playable;
    final size = widget.session.size;

    _innerBordersGamePath = _pathFromPositionsGame(pa.x, pa.y, pa.x1, pa.y1);
    _innerBordersScreenPath = _pathFromPositionsGameToScreen(
      pa.x.toDouble(),
      pa.y.toDouble(),
      pa.x1.toDouble(),
      pa.y1.toDouble(),
    );
    _outerBordersGamePath = _pathFromPositionsGame(0, 0, size.x, size.y);
    _outerBordersScreenPath = _pathFromPositionsGameToScreen(
      0,
      0,
      size.x.toDouble(),
      size.y.toDouble(),
    );
  }

  ElementEntity? findElement(Offset position) {
    bool where(ElementDrawData e) {
      return e.map(
        shipDrawData: (e) {
          final rect = Rect.fromCircle(center: e.offset, radius: e.radius);
          final path = Path()..addOval(rect);
          return path.contains(position);
        },
        landDrawData: (e) => e.path.contains(position),
      );
    }

    final elements = Map.fromEntries(_elementDrawData.entries.where((e) {
      return where(e.value);
    }).toList());

    if (elements.isEmpty) {
      return null;
    }

    final ship =
        elements.entries.firstWhereOrNull((e) => e.value is ShipDrawData);
    if (ship != null) {
      return ship.key;
    }

    final lands =
        elements.entries.where((e) => e.value is LandDrawData).toList();
    if (lands.isEmpty) {
      return null;
    }
    if (lands.length == 1) {
      return lands.first.key;
    }

    lands.sort((a, b) {
      final aLand = a.key as LandEntity;
      final bLand = b.key as LandEntity;
      final s1 = aLand.sizeNum.x + aLand.sizeNum.y;
      final s2 = bLand.sizeNum.x + bLand.sizeNum.y;
      return s1.compareTo(s2);
    });

    return lands.first.key;
  }

  Offset findLocalPosition(
    AnnoOffset entityGamePosition,
    Offset screenPosition,
  ) {
    final gamePosition = _screenToGame(screenPosition);
    return (gamePosition - entityGamePosition.asOffset) / _factor;
  }

  void updateElementPosition(
    ElementEntity element,
    Offset position, [
    Offset? dragOffset,
  ]) {
    var nextPosition = _screenToGame(position);
    if (dragOffset != null) {
      nextPosition -= (dragOffset * _factor);
    }

    final nextPositionX =
        Offset(nextPosition.dx, element.position.y.toDouble());
    final nextPositionY =
        Offset(element.position.x.toDouble(), nextPosition.dy);

    final ship = element is ShipEntity ? element : null;
    final land = element is LandEntity ? element : null;

    if (ship != null) {
      if (nextPosition.dx < 0 || nextPosition.dy < 0) {
        return;
      }
      if (nextPosition.dx > widget.session.size.x ||
          nextPosition.dy > widget.session.size.y) {
        return;
      }
      RedactorView.of(context)
          .updateElementPosition(ship, AnnoOffset.fromOffset(nextPosition));
      return;
    }

    if (land != null) {
      List<Offset> buildPoints(Offset position) {
        return [
          position,
          position + Offset(land.sizeNum.x.toDouble(), 0),
          position +
              Offset(land.sizeNum.x.toDouble(), land.sizeNum.y.toDouble()),
          position + Offset(0, land.sizeNum.y.toDouble()),
        ];
      }

      bool checkPosition(List<Offset> points) {
        for (final point in points) {
          if (!_outerBordersGamePath.contains(point)) {
            return false;
          }
        }
        return true;
      }

      final successX = checkPosition(buildPoints(nextPositionX));
      final successY = checkPosition(buildPoints(nextPositionY));

      if (!successX && !successY) {
        return;
      }

      nextPosition = Offset(
        successX ? nextPosition.dx : land.position.x.toDouble(),
        successY ? nextPosition.dy : land.position.y.toDouble(),
      );

      RedactorView.of(context)
          .updateElementPosition(land, AnnoOffset.fromOffset(nextPosition));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        if (_latestSize != size) {
          _computeBasicGeometry(_latestSize = size);
        }
        _computeItemGeometry();

        return InteractiveViewer(
          maxScale: 5,
          child: RedactorViewPaintGestures(
            child: CustomPaint(
              size: size,
              painter: RedactorViewPainter(
                size: size,
                outerBordersPath: _outerBordersScreenPath,
                innerBordersPath: _innerBordersScreenPath,
                drawData: _elementDrawData.values.toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}

/*
class Interactive extends StatefulWidget {
  const Interactive({super.key, required this.child});

  final Widget child;

  @override
  State<Interactive> createState() => InteractiveState();
}

class InteractiveState extends State<Interactive> {
  var scale = 1.0;
  var alignment = Alignment.center;

  late Size size;

  Alignment clamp(Alignment alignment) {
    return Alignment(
      min(1, max(-1, alignment.x)),
      min(1, max(-1, alignment.y)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent &&
            event.kind == PointerDeviceKind.mouse) {
          final delta = event.scrollDelta.dy * 0.001;
          setState(() => scale = min(2.5, max(1, scale - delta)));
        }
      },
      onPointerMove: (event) {
        if (event.kind != PointerDeviceKind.mouse) {
          return;
        }

        final p = Alignment(
          event.delta.dx * scale / size.width,
          event.delta.dy * scale / size.height,
        );

        setState(() => alignment = clamp(alignment - p));
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          size = constraints.biggest;

          return ClipRect(
            child: OverflowBox(
              alignment: alignment,
              maxHeight: size.height * scale,
              maxWidth: size.width * scale,
              child: widget.child,
            ),
          );

          return widget.child;
        },
      ),
    );
  }
}
*/
