import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:anno_flutter/anno_flutter.dart';
import 'package:bless_annotation/bless_annotation.dart';

import '../../infrastructure/rda_provider.dart';
import 'game_data.dart';

part 'game_data_provider_state.g.dart';

var _random = Random();

typedef LandDataFileCriteria = bool Function(LandDataFile);

@BlessIt()
abstract class GameDataProviderState {
  const GameDataProviderState();

  const factory GameDataProviderState.initial() = GameDataProviderStateInitial;

  const factory GameDataProviderState.directoryFailure([String? path]) =
      GameDataProviderStateGameDirectoryFailure;

  const factory GameDataProviderState.directorySuccess(String path) =
      GameDataProviderStateGameDirectorySuccess;

  const factory GameDataProviderState.extracting({
    ProgressStep? step,
    int? current,
    int? total,
  }) = GameDataProviderStateExtracting;

  const factory GameDataProviderState.loading() = GameDataProviderStateLoading;

  const factory GameDataProviderState.success({
    required List<String> sessionsJson,
    required List<SessionDataFile> sessions,
    required List<LandDataFile> lands,
    required Map<String, LandImage> images,
  }) = GameDataProviderStateSuccess;

  const factory GameDataProviderState.failure() = GameDataProviderStateFailure;
}

@BlessIt()
class GameDataProviderStateInitial extends GameDataProviderState {
  const GameDataProviderStateInitial();
}

class GameDataProviderStateGameDirectoryFailure extends GameDataProviderState {
  const GameDataProviderStateGameDirectoryFailure([this.path]);

  final String? path;
}

class GameDataProviderStateGameDirectorySuccess extends GameDataProviderState {
  const GameDataProviderStateGameDirectorySuccess(this.path);

  final String path;
}

class GameDataProviderStateExtracting extends GameDataProviderState {
  const GameDataProviderStateExtracting({
    this.step,
    this.current,
    this.total,
  });

  final ProgressStep? step;
  final int? current;
  final int? total;
}

class GameDataProviderStateLoading extends GameDataProviderState {
  const GameDataProviderStateLoading();
}

class LandImage {
  const LandImage({required this.image, required this.bytes});

  final Image image;
  final Uint8List bytes;
}

@BlessIt()
class GameDataProviderStateSuccess extends GameDataProviderState {
  const GameDataProviderStateSuccess({
    required this.sessionsJson,
    required this.sessions,
    required this.lands,
    required this.images,
  });

  final List<String> sessionsJson;
  final List<SessionDataFile> sessions;
  final List<LandDataFile> lands;
  final Map<String, LandImage> images;

  LandDataFile? findLandDataFileByCriteria(LandDataFileCriteria criteria) {
    final candidates = lands.where(criteria).toList();
    if (candidates.isEmpty) {
      return null;
    }
    if (candidates.length == 1) {
      return candidates.first;
    }
    return candidates[_random.nextInt(candidates.length - 1)];
  }

  LandDataFile? findLandDataFile(String path) {
    return lands.firstWhereOrNull(
      (e) => e.path == '$path${path.endsWith('info') ? '' : 'info'}',
    );
  }

  String findRandomIslandImageByCriteria(
    bool Function(LandDataFile) criteria,
  ) {
    final candidates = lands.where(criteria).toList();
    if (candidates.isEmpty) {
      // return null;
    }
    return candidates[_random.nextInt(candidates.length - 1)].imagePath;
  }
}

@BlessIt()
class GameDataProviderStateFailure extends GameDataProviderState {
  const GameDataProviderStateFailure();
}
