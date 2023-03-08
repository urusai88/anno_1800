import 'package:fluent_ui/fluent_ui.dart';

import '../../../anno_flutter.dart';
import '../../../domain/game_data/game_data.dart';

class OpenSessionDialog extends StatefulWidget {
  const OpenSessionDialog({super.key});

  @override
  State<OpenSessionDialog> createState() => OpenSessionDialogState();
}

class OpenSessionDialogState extends State<OpenSessionDialog> {
  final values = <SessionProperty>[];
  final properties = <List<SessionProperty>>[];

  AppLocalizations get loc => AppLocalizations.of(context)!;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    recomputeProperties();
  }

  void recomputeProperties() {
    final success = context.read<GameDataProvider>().value.asSuccess!;
    final maps = success.sessions;
    final props = maps.map((e) => e.props).toList();

    properties.clear();
    for (var i = 0; i <= values.length; ++i) {
      final a = props
          .where((e) => e.length > i)
          .where((e) => i != 0 ? e[i - 1] == values[i - 1] : true)
          .map((e) => e[i])
          .toSet()
          .toList();

      if (a.isNotEmpty) {
        properties.add(a);
      }
    }
  }

  void onChanged(int i, SessionProperty? v) {
    setState(() {
      if (i < values.length) {
        values[i] = v!;
        if (i < values.length - 1) {
          // i = 3
          // arr = [0, 1, 2*, 3, 4, 5]
          final tmp = values.take(i + 1).toList();
          values.clear();
          values.addAll(tmp);
        }
      } else {
        values.add(v!);
      }
      recomputeProperties();
    });
  }

  void open() => Navigator.pop(context, values);

  String getPropertyLabel(SessionProperty prop) {
    return prop.map<String>(
      archetype: (archetype) => loc.archetypeName(archetype.archetype.name),
      number: (n) => '${n.number}',
      sizeMap: (size) => loc.buildSize(size.mapSizes),
      multiplayer: (multiplayer) =>
          loc.multiplayer('${multiplayer.multiplayer}'),
      sessionId: (sessionId) => loc.sessionName(sessionId.sessionId.name),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameData = context.watch<GameDataProvider>().value;
    final success = gameData.asSuccess;
    if (success == null) {
      return const Placeholder();
    }

    Iterable<Widget> buildComboBoxList() sync* {
      for (var i = 0; i < properties.length; ++i) {
        final props = properties[i];
        if (i > 0) {
          yield const SizedBox(height: 4);
        }
        final label = loc.uiHomeOpenSessionDialogPropertyPlaceholder(
          props.first.name,
        );

        yield InfoLabel(
          label: label,
          child: ComboBox<SessionProperty>(
            isExpanded: true,
            value: i < values.length ? values[i] : null,
            placeholder: Text(label),
            items: [
              for (final prop in props)
                ComboBoxItem(
                  value: prop,
                  child: Text(getPropertyLabel(prop)),
                ),
            ],
            onChanged: (v) => onChanged(i, v),
          ),
        );
      }
    }

    final comboBoxList = buildComboBoxList().toList();
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: comboBoxList,
    );

    final size = MediaQuery.of(context).size;

    return ContentDialog(
      /*constraints: BoxConstraints(
        maxWidth: size.width * 0.75,
        maxHeight: size.height * 0.75,
      ),*/
      title: Center(child: Text(loc.uiHomeOpenSessionDialogTitle)),
      actions: [
        Button(
          onPressed: () => Navigator.pop(context),
          child: Text(loc.uiHomeOpenSessionDialogCancel),
        ),
        FilledButton(
          onPressed: values.length == properties.length ? open : null,
          child: Text(loc.uiHomeOpenSessionDialogOpen),
        ),
      ],
      content: content,
    );
  }
}
