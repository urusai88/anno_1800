import 'package:fluent_ui/fluent_ui.dart';

import '../../../../anno_flutter.dart';
import '../../../../domain/game_data/game_data.dart';

class SpecifiedLandPicked extends StatelessWidget {
  const SpecifiedLandPicked({
    super.key,
    required this.lands,
    required this.picked,
    required this.onTap,
  });

  final List<LandDataFile> lands;
  final LandDataFile? picked;
  final ValueChanged<LandDataFile?> onTap;

  @override
  Widget build(BuildContext context) {
    final success = context.read<GameDataProvider>().value.asSuccess!;
    final loc = AppLocalizations.of(context)!;

    return SizedBox(
      height: 300,
      child: ListView.builder(
        itemCount: lands.length,
        scrollDirection: Axis.horizontal,
        cacheExtent: 3840,
        itemBuilder: (context, index) {
          final land = lands[index];
          final landImage = success.images[land.imagePath]!;
          final image = Image.memory(landImage.bytes);

          Border? border;
          if (picked == land) {
            border = Border.fromBorderSide(BorderSide(color: Colors.yellow));
          }

          return GestureDetector(
            onTap: () => onTap(land),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                foregroundDecoration: BoxDecoration(
                  border: border,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: image),
                    for (final prop in land.props)
                      _PropertyRow(landProperty: prop),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PropertyRow extends StatelessWidget {
  const _PropertyRow({super.key, required this.landProperty});

  final LandProperty landProperty;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final name = loc.landPropertyName(landProperty.name);

    String value = '';
    if (landProperty.isKind) {
      value = loc.landKindName(landProperty.asKind!.kind.name);
    } else if (landProperty.isBiome) {
      value = loc.landBiomeName(landProperty.asBiome!.biome.name);
    } else if (landProperty.isNumber) {
      value = '${landProperty.asNumber!.number}';
    }

    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text('$name:'), Text(value)],
        ),
      ),
    );
  }
}
