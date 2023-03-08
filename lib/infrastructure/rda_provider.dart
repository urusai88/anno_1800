import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:bless_annotation/bless_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rda_provider.g.dart';

const _progressStepReading = 0;
const _progressStepComputing = 1;
const _progressStepCopying = 2;

@JsonEnum()
@BlessIt()
enum ProgressStep {
  @JsonValue(_progressStepReading)
  reading(_progressStepReading),
  @JsonValue(_progressStepComputing)
  computing(_progressStepComputing),
  @JsonValue(_progressStepCopying)
  copying(_progressStepCopying);

  const ProgressStep(this.id);

  final int id;
}

@JsonSerializable(createToJson: false)
class ExtractProgress {
  const ExtractProgress(this.step, this.current, this.total);

  factory ExtractProgress.fromJson(Map<String, dynamic> json) =>
      _$ExtractProgressFromJson(json);

  final ProgressStep step;
  final int current;
  final int total;

// Map<String, dynamic> toJson() => _$ExtractProgressToJson(this);
}

class RdaProvider {
  const RdaProvider({required String rdaExePath}) : _rdaExePath = rdaExePath;

  final String _rdaExePath;

  Stream<ExtractProgress> extract(String inputPath, String outputPath) {
    final controller = StreamController<ExtractProgress>();
    final outerReceivePort = ReceivePort();
    // final exitReceivePort = ReceivePort();
    final subscription = outerReceivePort.listen((message) {
      controller.sink.add(message as ExtractProgress);
    });
/*
    exitReceivePort.listen((_) {
      subscription.cancel();
      controller.close();
      exitReceivePort.close();
    });
*/
    compute(
      _runExtract,
      _RunExtractMessage(
        rdaExePath: _rdaExePath,
        inputPath: inputPath,
        outputPath: outputPath,
        port: outerReceivePort.sendPort,
      ),
    ).then((_) {
      subscription.cancel();
      controller.close();
    });
/*
    Isolate.spawn(
      _runExtract,
      _RunExtractMessage(
        rdaExePath: _rdaExePath,
        inputPath: inputPath,
        outputPath: outputPath,
        port: outerReceivePort.sendPort,
      ),
    ).then((isolate) => isolate.addOnExitListener(exitReceivePort.sendPort));
*/
    return controller.stream;
  }

  static Future<void> _runExtract(_RunExtractMessage message) async {
    final rdaExePath = message.rdaExePath;
    final inputPath = message.inputPath;
    final outputPath = message.outputPath;
    final port = message.port;

    void listener(String value) {
      value = value.trim();
      if (value.isEmpty || value == 'done') {
        return;
      }
      final json = Map<String, dynamic>.from(jsonDecode(value) as Map);
      port.send(ExtractProgress.fromJson(json));
    }

    final arguments = ['extract_sessions', '-i=$inputPath', '-o=$outputPath'];

    StreamSubscription<String>? subscription;

    try {
      final process = await Process.start(rdaExePath, arguments);
      subscription =
          process.stdout.transform(const Utf8Decoder()).listen(listener);
      await process.exitCode;
    } finally {
      subscription?.cancel();
      subscription = null;
    }
  }
}

class _RunExtractMessage {
  const _RunExtractMessage({
    required this.rdaExePath,
    required this.inputPath,
    required this.outputPath,
    required this.port,
  });

  final String rdaExePath;
  final String inputPath;
  final String outputPath;
  final SendPort port;
}
