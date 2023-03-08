import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:computer/computer.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';

import '../../infrastructure/infrastructure.dart';
import 'game_data.dart';

export 'game_data_provider_state.dart';

typedef ImageMapEntry = MapEntry<String, LandImage>;

class GameDataProvider extends ValueNotifier<GameDataProviderState> {
  static const gamePathKey = 'gamePath';

  GameDataProvider({
    required this.rda,
    required this.computer,
    required this.tmpPath,
  }) : super(const GameDataProviderState.initial());

  final RdaProvider rda;
  final Computer computer;

  final logger = Logger('GameData');

  final String tmpPath;

  String get sessionsJsonPath => join(tmpPath, 'sessions.json');

  Future<bool> validateGameDirectory(String path) =>
      File(join(path, 'Bin', 'Win64', 'Anno1800.exe')).exists();

  Future<bool> promptGameDirectory() async {
    try {
      final userVar = promptAnnoDirectory();
      if (userVar == null) {
        value = const GameDataProviderState.directoryFailure();
        return false;
      }
      if (!await validateGameDirectory(userVar)) {
        value = GameDataProviderState.directoryFailure(userVar);
        return false;
      }
      value = GameDataProviderState.directorySuccess(userVar);
      await Hive.box('settings').put(gamePathKey, userVar);
      return true;
    } catch (e, s) {
      print('$s\$s');
      return false;
    }
  }

  Future<bool> _registryGameDirectory() async {
    try {
      final registryVar = getInstallDirFromRegistry();
      if (registryVar == null) {
        value = const GameDataProviderState.directoryFailure();
        return false;
      }
      if (!await validateGameDirectory(registryVar)) {
        value = GameDataProviderState.directoryFailure(registryVar);
        return false;
      }
      value = GameDataProviderState.directorySuccess(registryVar);
      await Hive.box('settings').put(gamePathKey, registryVar);
      return true;
    } catch (e, s) {
      print('$s\$s');
      value = const GameDataProviderState.directoryFailure();
      return false;
    }
  }

  Future<void> beginExtract() async {
    final success = value.asGameDirectorySuccess;
    if (success == null) {
      print('[GameDataProvide] beginExtract() value не directorySuccess');
      return;
    }
    if (value.isExtracting) {
      print('[GameDataProvide] beginExtract() распаковывание в процессе');
      return;
    }

    value = const GameDataProviderState.extracting();

    final mainDataPath = join(success.path, 'maindata');
    final stream = rda.extract(mainDataPath, tmpPath);
    final completer = Completer();
    final subscription = stream.listen((e) {
      value = GameDataProviderState.extracting(
        step: e.step,
        current: e.current,
        total: e.total,
      );
    }, onDone: completer.complete);

    await completer.future;
    await subscription.cancel();

    final extracting = value.asExtracting;
    if (extracting == null) {
      print('[GameDataProvide] beginExtract() value несоответствует ожиданию');
      return;
    }
    if (extracting.step == null || !extracting.step!.isCopying) {
      print('[GameDataProvide] beginExtract() value несоответствует ожиданию');
      return;
    }
    if (extracting.current == null || extracting.total == null) {
      print('[GameDataProvide] beginExtract() value несоответствует ожиданию');
      return;
    }

    if (await validateExtract()) {
      await loadData();
    }
  }

  Future<bool> validateExtract() async {
    final directory = Directory(tmpPath);
    if (!await directory.exists()) {
      return false;
    }
    final sessionJsonFile = File(sessionsJsonPath);
    if (!await sessionJsonFile.exists()) {
      return false;
    }
    return true;
  }

  Future<void> loadData() async {
    value = const GameDataProviderState.loading();

    final transformer = XmlTransformer();
    final sessionReader = SessionXmlReader(transformer: transformer);
    final landReader = LandXmlReader(transformer: transformer);
    final sessionPropsReader = SessionPropertyReader();
    final landPropsReader = LandPropertyReader();
    final sw = Stopwatch()..start();
    final sessionsStr = await File(sessionsJsonPath).readAsString();
    final sessionsJson = (jsonDecode(sessionsStr) as List).cast<String>();

    whereExt(String ext) => (String path) => path.endsWith('.$ext');

    final sessionFilePaths = sessionsJson.where(whereExt('a7tinfo'));
    final landFilePaths = sessionsJson.where(whereExt('a7minfo'));
    final imageFilePaths = sessionsJson.where(whereExt('png'));

    Stream<SessionDataFile> readSessions() async* {
      for (final path in sessionFilePaths) {
        yield SessionDataFile(
          path: path,
          template: sessionReader.readXmlString(
            await File(join(tmpPath, path)).readAsString(),
          ),
          props: sessionPropsReader.read(path),
        );
      }
    }

    Stream<LandDataFile> readLands() async* {
      for (final path in landFilePaths) {
        yield LandDataFile(
          path: path,
          template: landReader
              .readXmlString(await File(join(tmpPath, path)).readAsString()),
          props: landPropsReader.read(path),
        );
      }
    }

    Future<List<ImageMapEntry>> readImages() async {
      final futures = <Future<ImageMapEntry>>[];
      for (final path in imageFilePaths) {
        Future<ImageMapEntry> future() async {
          final bytes = await File(join(tmpPath, path)).readAsBytes();
          final image = await decodeImageFromList(bytes);
          return ImageMapEntry(path, LandImage(bytes: bytes, image: image));
        }

        futures.add(future());
      }

      return Future.wait(futures);
    }

    final sessions = await readSessions().toList();
    final lands = await readLands().toList();
    final images = Map.fromEntries(await readImages());

    value = GameDataProviderState.success(
      sessionsJson: sessionsJson,
      sessions: sessions,
      lands: lands,
      images: images,
    );

    logger.info('Данные загружены за ${sw.elapsedMilliseconds}мс');
    logger.info(
      'Загружено сессий: ${sessions.length}, островов: ${lands.length}',
    );
  }

  Future<void> init() async {
    final box = Hive.box('settings');
    final path = box.get(gamePathKey);
    var validated = false;
    if (path != null) {
      validated = await validateGameDirectory(path);
      logger.info('Box gamePath validated: $validated');
      if (validated) {
        value = GameDataProviderState.directorySuccess(path);
        if (await validateExtract()) {
          logger.info('validateExtract: true');
          await loadData();
        } else {
          logger.info('validateExtract: false');
          unawaited(beginExtract());
        }
        return;
      }
    }

    if (await _registryGameDirectory()) {
      logger.info('Registry gamePath: $path; validated: true');
      if (await validateExtract()) {
        await loadData();
      } else {
        unawaited(beginExtract());
      }
    }
  }

  SessionDataFile? findSessionByProperties(List<SessionProperty> props) {
    SessionDataFile? success(GameDataProviderStateSuccess value) {
      bool validator(SessionDataFile file) {
        if (file.props.length != props.length) {
          return false;
        }
        for (var i = 0; i < file.props.length; ++i) {
          if (file.props[i] != props[i]) {
            return false;
          }
        }
        return true;
      }

      final i = value.sessions.indexWhere(validator);
      return i != -1 ? value.sessions[i] : null;
    }

    return value.maybeMap(
      success: success,
      orElse: (_) => null,
    );
  }
}
