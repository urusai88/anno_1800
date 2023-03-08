import 'package:anno_flutter/anno_flutter.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/game_data/game_data.dart';

class SpecifiedLandMenu extends StatelessWidget {
  static TextStyle noStyle = TextStyle(color: Colors.grey[100]);

  const SpecifiedLandMenu({
    super.key,
    required this.biome,
    required this.kind,
    required this.onBiomeChanged,
    required this.onKindChanged,
  });

  final LandBiome? biome;
  final LandKind? kind;

  final ValueChanged<LandBiome?> onBiomeChanged;
  final ValueChanged<LandKind?> onKindChanged;

  Widget biomeComboBox(AppLocalizations loc) {
    Iterable<ComboBoxItem<LandBiome>> comboBoxItems() sync* {
      yield ComboBoxItem<LandBiome>(
        child: Text('No', style: noStyle),
      );

      for (final biome in LandBiome.values) {
        yield ComboBoxItem<LandBiome>(
          value: biome,
          child: Text(loc.landBiomeName(biome.name)),
        );
      }
    }

    return ComboBox<LandBiome>(
      value: biome,
      items: comboBoxItems().toList(),
      onChanged: onBiomeChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InfoLabel(label: loc.uiHomeAddLandDialogSpecifiedBiomeHeader),
        biomeComboBox(loc),
      ],
    );
  }
}
