import 'package:anno_flutter/presentation/home/home_view_provider.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../../anno_flutter.dart';
import '../../../domain/game_data/game_data.dart';
import 'redactor_view_info_bar.dart';
import 'redactor_view_paint.dart';

class RedactorView extends StatefulWidget {
  const RedactorView({super.key, required this.session});

  final SessionEntity session;

  @override
  State<RedactorView> createState() => RedactorViewState();

  static RedactorViewState of(BuildContext context) =>
      context.findAncestorStateOfType<RedactorViewState>()!;
}

class RedactorViewState extends State<RedactorView> {
  LandEntity? focusedLand;
  ShipEntity? focusedShip;

  HomeViewProvider get homeViewProvider => context.read<HomeViewProvider>();

  @override
  void didUpdateWidget(covariant RedactorView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.session != oldWidget.session) {
      focusedLand = null;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.watch<HomeViewProvider>();
  }

  void updateElementFocus(ElementEntity? element) {
    if (element == null) {
      resetFocus();
    } else if (element is LandEntity) {
      setState(() {
        focusedLand = element;
        focusedShip = null;
      });
    } else if (element is ShipEntity) {
      setState(() {
        focusedShip = element;
        focusedLand = null;
      });
    }
  }

  void resetFocus() {
    if (focusedLand != null || focusedShip != null) {
      setState(() {
        focusedLand = null;
        focusedShip = null;
      });
    }
  }

  void updateElementPosition(ElementEntity element, AnnoOffset position) {
    homeViewProvider.updateElementPosition(
        widget.session.name, element, position);
  }

  void updateLandRotation(LandEntity land, LandRotation90 rotation) {
    homeViewProvider.updateLandRotation(widget.session.name, land, rotation);
  }

  void removeLand(LandEntity land) {
    if (homeViewProvider.removeLand(widget.session.name, land)) {
      setState(() => focusedLand = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 500,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: RedactorViewInfoBar(
              session: widget.session,
              focusedLand: focusedLand,
              focusedShip: focusedShip,
            ),
          ),
        ),
        /*const Divider(
          direction: Axis.vertical,
          style: DividerThemeData(
            // verticalMargin: EdgeInsets.all(12),
          ),
        ),*/
        // const RedactorActionsBar(),
        const Divider(
          direction: Axis.vertical,
          style: DividerThemeData(
              // verticalMargin: EdgeInsets.all(12),
              ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: RedactorViewPaint(
                  session: widget.session,
                  focusedLand: focusedLand,
                  focusedShip: focusedShip,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
