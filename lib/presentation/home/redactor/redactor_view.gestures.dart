part of 'redactor_view_paint.dart';

class RedactorViewPaintGestures extends StatefulWidget {
  const RedactorViewPaintGestures({super.key, required this.child});

  final Widget child;

  @override
  State<RedactorViewPaintGestures> createState() =>
      _RedactorViewPaintGesturesState();
}

class _RedactorViewPaintGesturesState extends State<RedactorViewPaintGestures> {
  RedactorViewPaintState get state => RedactorViewPaint.of(context);

  RedactorViewState get viewState => RedactorView.of(context);

  Offset? dragOffset;

  void _onTapDown(PointerDownEvent event) {
    final element = state.findElement(event.localPosition);
    if (element != null) {
      viewState.updateElementFocus(element);
      dragOffset =
          state.findLocalPosition(element.position, event.localPosition);
    } else {
      viewState.resetFocus();
    }
  }

  void _onTapUp(PointerUpEvent event) {}

  void _onPointerMove(PointerMoveEvent event) {
    ElementEntity? element;
    if (viewState.focusedLand != null) {
      element = viewState.focusedLand;
    } else if (viewState.focusedShip != null) {
      element = viewState.focusedShip;
    }

    if (element == null) {
      return;
    }

    state.updateElementPosition(element, event.localPosition, dragOffset);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: _onTapDown,
      onPointerUp: _onTapUp,
      onPointerMove: _onPointerMove,
      child: widget.child,
    );
  }
}
