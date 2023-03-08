// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_data_provider_state.dart';

// **************************************************************************
// BlessGenerator
// **************************************************************************

extension GameDataProviderStateBlessExtension on GameDataProviderState {
  bool get isFailure => this is GameDataProviderStateFailure;

  bool get isSuccess => this is GameDataProviderStateSuccess;

  bool get isLoading => this is GameDataProviderStateLoading;

  bool get isExtracting => this is GameDataProviderStateExtracting;

  bool get isGameDirectorySuccess =>
      this is GameDataProviderStateGameDirectorySuccess;

  bool get isGameDirectoryFailure =>
      this is GameDataProviderStateGameDirectoryFailure;

  bool get isInitial => this is GameDataProviderStateInitial;

  GameDataProviderStateFailure? get asFailure =>
      this is GameDataProviderStateFailure
          ? this as GameDataProviderStateFailure?
          : null;

  GameDataProviderStateSuccess? get asSuccess =>
      this is GameDataProviderStateSuccess
          ? this as GameDataProviderStateSuccess?
          : null;

  GameDataProviderStateLoading? get asLoading =>
      this is GameDataProviderStateLoading
          ? this as GameDataProviderStateLoading?
          : null;

  GameDataProviderStateExtracting? get asExtracting =>
      this is GameDataProviderStateExtracting
          ? this as GameDataProviderStateExtracting?
          : null;

  GameDataProviderStateGameDirectorySuccess? get asGameDirectorySuccess =>
      this is GameDataProviderStateGameDirectorySuccess
          ? this as GameDataProviderStateGameDirectorySuccess?
          : null;

  GameDataProviderStateGameDirectoryFailure? get asGameDirectoryFailure =>
      this is GameDataProviderStateGameDirectoryFailure
          ? this as GameDataProviderStateGameDirectoryFailure?
          : null;

  GameDataProviderStateInitial? get asInitial =>
      this is GameDataProviderStateInitial
          ? this as GameDataProviderStateInitial?
          : null;

  TYPE map<TYPE>({
    required TYPE Function(GameDataProviderStateFailure) failure,
    required TYPE Function(GameDataProviderStateSuccess) success,
    required TYPE Function(GameDataProviderStateLoading) loading,
    required TYPE Function(GameDataProviderStateExtracting) extracting,
    required TYPE Function(GameDataProviderStateGameDirectorySuccess)
        gameDirectorySuccess,
    required TYPE Function(GameDataProviderStateGameDirectoryFailure)
        gameDirectoryFailure,
    required TYPE Function(GameDataProviderStateInitial) initial,
  }) {
    if (this is GameDataProviderStateFailure) {
      return failure(this as GameDataProviderStateFailure);
    } else if (this is GameDataProviderStateSuccess) {
      return success(this as GameDataProviderStateSuccess);
    } else if (this is GameDataProviderStateLoading) {
      return loading(this as GameDataProviderStateLoading);
    } else if (this is GameDataProviderStateExtracting) {
      return extracting(this as GameDataProviderStateExtracting);
    } else if (this is GameDataProviderStateGameDirectorySuccess) {
      return gameDirectorySuccess(
          this as GameDataProviderStateGameDirectorySuccess);
    } else if (this is GameDataProviderStateGameDirectoryFailure) {
      return gameDirectoryFailure(
          this as GameDataProviderStateGameDirectoryFailure);
    } else if (this is GameDataProviderStateInitial) {
      return initial(this as GameDataProviderStateInitial);
    }

    throw 'ERROR';
  }

  TYPE maybeMap<TYPE>({
    TYPE Function(GameDataProviderStateFailure)? failure,
    TYPE Function(GameDataProviderStateSuccess)? success,
    TYPE Function(GameDataProviderStateLoading)? loading,
    TYPE Function(GameDataProviderStateExtracting)? extracting,
    TYPE Function(GameDataProviderStateGameDirectorySuccess)?
        gameDirectorySuccess,
    TYPE Function(GameDataProviderStateGameDirectoryFailure)?
        gameDirectoryFailure,
    TYPE Function(GameDataProviderStateInitial)? initial,
    required TYPE Function(GameDataProviderState) orElse,
  }) {
    if (this is GameDataProviderStateFailure && failure != null) {
      return failure(this as GameDataProviderStateFailure);
    } else if (this is GameDataProviderStateSuccess && success != null) {
      return success(this as GameDataProviderStateSuccess);
    } else if (this is GameDataProviderStateLoading && loading != null) {
      return loading(this as GameDataProviderStateLoading);
    } else if (this is GameDataProviderStateExtracting && extracting != null) {
      return extracting(this as GameDataProviderStateExtracting);
    } else if (this is GameDataProviderStateGameDirectorySuccess &&
        gameDirectorySuccess != null) {
      return gameDirectorySuccess(
          this as GameDataProviderStateGameDirectorySuccess);
    } else if (this is GameDataProviderStateGameDirectoryFailure &&
        gameDirectoryFailure != null) {
      return gameDirectoryFailure(
          this as GameDataProviderStateGameDirectoryFailure);
    } else if (this is GameDataProviderStateInitial && initial != null) {
      return initial(this as GameDataProviderStateInitial);
    } else {
      return orElse(this);
    }
  }
}

extension GameDataProviderStateInitialBlessExtension
    on GameDataProviderStateInitial {
  GameDataProviderStateInitial copyWith() {
    return GameDataProviderStateInitial();
  }

  GameDataProviderStateInitial copyWithNull() {
    return GameDataProviderStateInitial();
  }
}

extension GameDataProviderStateSuccessBlessExtension
    on GameDataProviderStateSuccess {
  GameDataProviderStateSuccess copyWith({
    List<String>? sessionsJson,
    List<SessionDataFile>? sessions,
    List<LandDataFile>? lands,
    Map<String, LandImage>? images,
  }) {
    return GameDataProviderStateSuccess(
      sessionsJson: sessionsJson ?? this.sessionsJson,
      sessions: sessions ?? this.sessions,
      lands: lands ?? this.lands,
      images: images ?? this.images,
    );
  }

  GameDataProviderStateSuccess copyWithNull() {
    return GameDataProviderStateSuccess(
      sessionsJson: sessionsJson,
      sessions: sessions,
      lands: lands,
      images: images,
    );
  }
}

extension GameDataProviderStateFailureBlessExtension
    on GameDataProviderStateFailure {
  GameDataProviderStateFailure copyWith() {
    return GameDataProviderStateFailure();
  }

  GameDataProviderStateFailure copyWithNull() {
    return GameDataProviderStateFailure();
  }
}
