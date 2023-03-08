import '../../session_id.dart';
import '../../xml/session/session_property.dart';

class SessionPropertyReader {
  List<SessionProperty> read(String path) {
    final parts = path.split('/').toList();
    var i = parts[1] != 'sessions' ? 1 : 0;

    final s1 = parts[3 + i];
    final n = SessionId.isNeedSecondPart(s1);
    final s2 = n ? parts[4 + i] : null;
    if (n) i++;
    final sessionId = SessionId.fromPathPart(s1, s2);
    final tag = parts[4 + i];
    final tagList = tag.split('_').toList();

    final props = <SessionProperty>[
      SessionProperty.sessionId(sessionId),
    ];

    switch (sessionId) {
      case SessionId.cape:
      case SessionId.arctic:
        break;
      case SessionId.africa:
        props.add(SessionProperty.multiplayer(tagList.length > 2));
        break;
      case SessionId.america:
        props.add(SessionProperty.size(MapSizes.fromCode(tagList[1])));
        props.add(SessionProperty.number(int.parse(tagList[2])));
        break;
      case SessionId.europe:
        try {
          props.add(SessionProperty.size(MapSizes.fromCode(tagList[1])));
          props.add(SessionProperty.number(int.parse(tagList[2])));
          props.add(const SessionProperty.archetype(MapArchetype.europe));
        } on StateError catch (_) {
          props.add(SessionProperty.size(MapSizes.fromCode(tagList[2])));
          props.add(SessionProperty.number(int.parse(tagList[3])));
          props.add(
            SessionProperty.archetype(MapArchetype.fromCode(tagList[1])),
          );
        }
    }

    SessionProperty.sort(props);

    return props;
  }
}
