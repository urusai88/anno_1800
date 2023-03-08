// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rda_provider.dart';

// **************************************************************************
// BlessGenerator
// **************************************************************************

extension ProgressStepBlessExtension on ProgressStep {
  bool get isReading => this == ProgressStep.reading;

  bool get isComputing => this == ProgressStep.computing;

  bool get isCopying => this == ProgressStep.copying;

  ProgressStep? get asReading =>
      this is ProgressStep ? this as ProgressStep? : null;

  ProgressStep? get asComputing =>
      this is ProgressStep ? this as ProgressStep? : null;

  ProgressStep? get asCopying =>
      this is ProgressStep ? this as ProgressStep? : null;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExtractProgress _$ExtractProgressFromJson(Map<String, dynamic> json) =>
    ExtractProgress(
      $enumDecode(_$ProgressStepEnumMap, json['step']),
      json['current'] as int,
      json['total'] as int,
    );

const _$ProgressStepEnumMap = {
  ProgressStep.reading: 0,
  ProgressStep.computing: 1,
  ProgressStep.copying: 2,
};
