import 'domain/game_data/game_data.dart';
import 'l10n/app_localizations.dart';

extension AppLocalizationsExtensions on AppLocalizations {
  String buildNameForSessionDataFile(SessionDataFile sessionDataFile) {
    final props = sessionDataFile.props;
    final nameParts = <String>[];

    for (final prop in props) {
      if (prop.isSessionId) {
        nameParts.add(sessionName(prop.asSessionId!.sessionId.name));
      } else if (prop.isSizeMap) {
        nameParts.add(buildSize(prop.asSizeMap!.mapSizes));
      } else if (prop.isArchetype) {
        nameParts.add(archetypeName(prop.asArchetype!.archetype.name));
      }
    }

    return nameParts.join(', ');
  }

  String buildSize(MapSizes sizes) {
    var nameParts = <String>['Карта - ${mapSizes(sizes.mapSize.name)}'];
    if (sizes.islandSize != null) {
      nameParts.add(', Острова - ${mapSizes(sizes.islandSize!.name)}');
    }
    return nameParts.join('');
  }
}
