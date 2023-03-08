// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'redactor_land_dialog.dart';

// **************************************************************************
// BlessGenerator
// **************************************************************************

extension DialogLandKindBlessExtension on DialogLandKind {
  bool get isCommon => this == DialogLandKind.common;

  bool get isDecoration => this == DialogLandKind.decoration;

  bool get isThirdParty => this == DialogLandKind.thirdParty;

  bool get isContinental => this == DialogLandKind.continental;

  bool get isGas => this == DialogLandKind.gas;

  bool get isQuest => this == DialogLandKind.quest;

  DialogLandKind? get asCommon =>
      this is DialogLandKind ? this as DialogLandKind? : null;

  DialogLandKind? get asDecoration =>
      this is DialogLandKind ? this as DialogLandKind? : null;

  DialogLandKind? get asThirdParty =>
      this is DialogLandKind ? this as DialogLandKind? : null;

  DialogLandKind? get asContinental =>
      this is DialogLandKind ? this as DialogLandKind? : null;

  DialogLandKind? get asGas =>
      this is DialogLandKind ? this as DialogLandKind? : null;

  DialogLandKind? get asQuest =>
      this is DialogLandKind ? this as DialogLandKind? : null;
}

extension DialogCommonLandTypeBlessExtension on DialogCommonLandType {
  bool get isRandom => this == DialogCommonLandType.random;

  bool get isSpecified => this == DialogCommonLandType.specified;

  DialogCommonLandType? get asRandom =>
      this is DialogCommonLandType ? this as DialogCommonLandType? : null;

  DialogCommonLandType? get asSpecified =>
      this is DialogCommonLandType ? this as DialogCommonLandType? : null;
}

extension DialogLandDifficultyBlessExtension on DialogLandDifficulty {
  bool get isNo => this == DialogLandDifficulty.no;

  bool get isNormal => this == DialogLandDifficulty.normal;

  bool get isHard => this == DialogLandDifficulty.hard;

  DialogLandDifficulty? get asNo =>
      this is DialogLandDifficulty ? this as DialogLandDifficulty? : null;

  DialogLandDifficulty? get asNormal =>
      this is DialogLandDifficulty ? this as DialogLandDifficulty? : null;

  DialogLandDifficulty? get asHard =>
      this is DialogLandDifficulty ? this as DialogLandDifficulty? : null;
}

extension DialogLandNpcTypeBlessExtension on DialogLandNpcType {
  bool get isNo => this == DialogLandNpcType.no;

  bool get isPirate => this == DialogLandNpcType.pirate;

  DialogLandNpcType? get asNo =>
      this is DialogLandNpcType ? this as DialogLandNpcType? : null;

  DialogLandNpcType? get asPirate =>
      this is DialogLandNpcType ? this as DialogLandNpcType? : null;
}
