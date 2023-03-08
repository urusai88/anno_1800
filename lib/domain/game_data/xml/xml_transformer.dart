import '../game_data.dart';

class XmlTransformer {
  AnnoOffset parseAnnoOffset(String value) {
    final p = value.split(' ').map(int.tryParse).toList();
    if (p.length != 2 || p.contains(null)) {
      throw [
        'Значение должно быть в формате "%d %d"',
        'Например: "500 500"',
        'Дано: "$value"',
      ].join('\n');
    }
    return AnnoOffset(p[0]!, p[1]!);
  }

  AnnoRect parseAnnoRect(String value) {
    final p = value.split(' ').map(int.tryParse).toList();
    if (p.length != 4 || p.contains(null)) {
      throw [
        'Значение должно быть в формате "%d %d %d %d"',
        'Например: "100 100 1800 1800"',
        'Дано: "$value"',
      ].join('\n');
    }
    return AnnoRect(p[0]!, p[1]!, p[2]!, p[3]!);
  }

  List<int> parseList(String value) {
    final result = value.trim().split(' ').map(int.tryParse).toList();
    if (result.contains(null)) {
      throw [
        'Значение должно должно состоять из целых чисел, разделённых пробелом',
        'Например: "2172 3637 3373 963 46"',
        'Дано: "$value"',
      ].join('\n');
    }
    return result.map((e) => e!).toList();
  }

  String formatAnnoOffset(AnnoOffset value) {
    return '${value.x} ${value.y}';
  }

  String formatAnnoRect(AnnoRect value) {
    return '${value.x} ${value.y} ${value.x1} ${value.y1}';
  }

  String formatList(List<int> value) {
    return value.join(' ');
  }
}
