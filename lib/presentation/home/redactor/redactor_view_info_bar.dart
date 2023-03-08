import 'package:anno_flutter/presentation/home/home_view_provider.dart';
import 'package:anno_flutter/presentation/home/redactor/redactor_view.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../../anno_flutter.dart';
import '../../../domain/game_data/game_data.dart';
import 'dialogs/redactor_land_dialog.dart';

class RedactorViewInfoBar extends StatelessWidget {
  const RedactorViewInfoBar({
    super.key,
    required this.session,
    required this.focusedLand,
    required this.focusedShip,
  });

  final SessionEntity session;
  final LandEntity? focusedLand;
  final ShipEntity? focusedShip;

  void openImage(BuildContext context) {
    final image = focusedLand!.image;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        final mq = MediaQuery.of(context);
        final constraints = BoxConstraints(
          maxWidth: mq.size.width * 0.85,
          maxHeight: mq.size.height * 0.85,
        );

        return ContentDialog(
          constraints: constraints,
          content: Image.memory(image.bytes),
        );
      },
    );
  }

  void addLand(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (innerContext) => ChangeNotifierProvider<HomeViewProvider>.value(
        value: context.read<HomeViewProvider>(),
        child: RedactorLandDialog(sessionName: session.name),
      ),
    );
  }

  Widget buildLabel(String text1, String text2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InfoLabel(label: text1),
        InfoLabel(label: text2),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final size = session.size;
    final pa = session.playable;
    final land = focusedLand;
    final ship = focusedShip;
    final element = ship ?? land;

    const headerStyle = TextStyle(fontSize: 20);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: FilledButton(
                child: Text(loc.uiInfoBarSaveButton),
                onPressed: () =>
                    context.read<HomeViewProvider>().save(session.name),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton(
                child: Text(loc.uiInfoBarAddLandButton),
                onPressed: () => addLand(context),
              ),
            ),
          ],
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(loc.uiInfoBarSessionInfo, style: headerStyle),
          ),
        ),
        buildLabel(
          loc.uiInfoBarSessionIdLabel,
          loc.sessionName(session.sessionId.name),
        ),
        buildLabel(loc.uiInfoBarSizeLabel, '${size.x}x${size.y}'),
        buildLabel(
          loc.uiInfoBarPlayableLabel,
          '${pa.x} ${pa.y} ${pa.x1} ${pa.y1}',
        ),
        if (element != null) ...[
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(loc.uiInfoBarElementInfo, style: headerStyle),
            ),
          ),
          buildLabel(
            loc.uiInfoBarElementTypeLabel,
            loc.uiInfoBarElementType('${element.runtimeType}'),
          ),
          buildLabel(
            loc.uiInfoBarElementPosition,
            '${element.position.x}:${element.position.y}',
          ),
        ],
        if (land != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InfoLabel(label: loc.uiInfoBarLandSizeLabel),
              InfoLabel(label: '${land.sizeNum.x}x${land.sizeNum.y}'),
            ],
          ),
          if (!land.specified)
            buildLabel(
              loc.uiInfoBarLandElementSizeLabel,
              land.size != null ? loc.landSize(land.size!.name) : 'null',
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InfoLabel(label: loc.uiInfoBarLandRotationLabel),
              const Spacer(),
              for (var i = 0; i < LandRotation90.values.length; ++i) ...[
                if (i > 0) const SizedBox(width: 8),
                RadioButton(
                  checked: land.rotation90 == null
                      ? LandRotation90.values[i].isD0
                      : land.rotation90 == LandRotation90.values[i],
                  onChanged: (_) => RedactorView.of(context)
                      .updateLandRotation(land, LandRotation90.values[i]),
                  content: Text('${LandRotation90.values[i].angle}'),
                ),
              ]
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  child: Text(loc.uiInfoBarRemoveLandButton),
                  onPressed: () => RedactorView.of(context).removeLand(land),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  child: Text(loc.uiInfoBarOpenImageButton),
                  onPressed: () => openImage(context),
                ),
              ),
            ],
          ),
        ],
        const Spacer(),
      ],
    );
  }
}
