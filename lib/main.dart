import 'dart:convert';
import 'dart:io';

import 'package:anno_flutter/infrastructure/mod_manager.dart';
import 'package:anno_flutter/infrastructure/rda_provider.dart';
import 'package:computer/computer.dart';
import 'package:crypto/crypto.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';

import 'anno_flutter.dart';

Future<void> _buildRda(String sourcePath, String outputPath) async {
  final logger = Logger('main');
  final box = await Hive.openBox('build');
  final hashStored = box.get('hash');
  final sw = Stopwatch()..start();

  final directoryList = <Directory>[
    Directory(sourcePath),
    Directory(join(sourcePath, 'lib')),
    Directory(join(sourcePath, 'FileFormats')),
  ];
  final files = <File>[];

  for (final directory in directoryList) {
    await directory
        .list()
        .where((e) => e is File)
        .cast<File>()
        .forEach(files.add);
  }

  final bytesList = files.map((e) => e.readAsBytesSync());
  final hash = bytesList
      .map((e) => md5.convert(e))
      .map((e) => '$e')
      .fold('', (p, e) => p + e);
  final hashTime = sw.elapsedMilliseconds;
  if (hashStored == hash) {
    return;
  }

  logger.info('Сборка RDA');

  final arguments = <String>[];
  arguments.add('publish');
  arguments.addAll(['--output', outputPath]);
  arguments.addAll(['-c', 'Release']);
  arguments.addAll([
    '-p:PublishSingleFile=true',
    '-p:DebugType=None',
    '-p:DebugSymbol=false',
    '--self-contained',
  ]);

  final result = await Process.run(
    'dotnet',
    arguments,
    workingDirectory: sourcePath,
    stdoutEncoding: const Utf8Codec(),
    stderrEncoding: const Utf8Codec(),
  );

  final lines = (result.stdout as String).split('\n');
  final successLine = lines.firstWhereOrNull(
    (e) {
      e = e.trim();
      var o = outputPath;
      if (o.endsWith('\\') || o.endsWith('/')) {
        o = o.substring(0, o.length - 1);
      }
      if (e.endsWith('\\') || e.endsWith('/')) {
        e = e.substring(0, e.length - 1);
      }

      return e.startsWith('RDA -> ') && e.endsWith(o);
    },
  );

  if (successLine == null) {
    logger.warning('Не удалось собрать RDA. Вывод:');
    logger.warning('stdout: ${result.stdout}');
    logger.warning('stderr: ${result.stderr}');
  } else {
    box.put('hash', hash);

    logger.info(
      // ignore: unnecessary_brace_in_string_interps
      'Сборка RDA завершена за ${sw.elapsedMilliseconds}мс. Чтение хеша ${hashTime}мс',
    );
  }
}

void main() async {
  if (kDebugMode) {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      String levelName = '';
      if (record.level > Level.INFO) {
        levelName += ' ${record.level.name}';
      }
      print('[${record.loggerName}]$levelName: ${record.message}');
    });
  }

  await Hive.initFlutter();
  await Hive.openBox('settings');

  final logger = Logger('main');
  final currentPath = Directory.current.path;
  final rdaPath = normalize(join(currentPath, '.rda'));
  final rdaExe = normalize(join(rdaPath, 'RDA.exe'));
  final rdaSourcePath = normalize(join(currentPath, 'third_party', 'RDA'));

  logger.info('Application paths:');
  logger.info('current: $currentPath');
  logger.info('RDAexe:  $rdaExe');
  logger.info('Source:  $rdaSourcePath');

  if (kDebugMode) {
    await _buildRda(rdaSourcePath, rdaPath);
  }

  await Computer.shared().turnOn(workersCount: 8);

  Widget app = MultiProvider(
    providers: [
      Provider<Computer>(create: (_) => Computer.shared()),
      Provider<RdaProvider>(
        create: (context) => RdaProvider(rdaExePath: rdaExe),
      ),
      Provider<ModManager>(
        create: (context) => const ModManager(),
      ),
      ListenableProvider<GameDataProvider>(
        create: (context) => GameDataProvider(
          rda: context.read<RdaProvider>(),
          computer: context.read<Computer>(),
          tmpPath: '.tmp',
        )..init(),
        dispose: (_, value) => value.dispose(),
      ),
    ],
    child: const App(),
  );

  runApp(app);
}
