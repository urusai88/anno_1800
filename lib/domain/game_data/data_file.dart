import 'package:path/path.dart';

import 'game_data.dart';

class SessionDataFile {
  const SessionDataFile({
    required this.path,
    required this.template,
    required this.props,
  });

  final String path;
  final SessionTemplate template;
  final List<SessionProperty> props;

  T _findProperty<T extends SessionProperty>() => props.whereType<T>().first;

  SessionId get sessionId =>
      _findProperty<SessionIdSessionProperty>().sessionId;
}

class LandDataFile {
  const LandDataFile({
    required this.path,
    required this.template,
    required this.props,
  });

  final String path;
  final LandTemplate template;
  final List<LandProperty> props;

  String get imagePath {
    final filename = basenameWithoutExtension(path);
    final directory = dirname(path);
    return join(directory, '_gamedata', filename, 'activemapimage.png')
        .replaceAll('\\', '/');
  }
}
