// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_template.dart';

// **************************************************************************
// BlessGenerator
// **************************************************************************

extension SessionTemplateBlessExtension on SessionTemplate {
  SessionTemplate copyWith({
    AnnoOffset? size,
    AnnoRect? playable,
    AnnoRect? initPlayable,
    bool? enlargedTemplate,
    bool? randomlyPlacedThirdParties,
    List<ElementTemplate>? elements,
  }) {
    return SessionTemplate(
      size: size ?? this.size,
      playable: playable ?? this.playable,
      initPlayable: initPlayable ?? this.initPlayable,
      enlargedTemplate: enlargedTemplate ?? this.enlargedTemplate,
      randomlyPlacedThirdParties:
          randomlyPlacedThirdParties ?? this.randomlyPlacedThirdParties,
      elements: elements ?? this.elements,
    );
  }

  SessionTemplate copyWithNull({
    bool? initPlayable,
    bool? enlargedTemplate,
    bool? randomlyPlacedThirdParties,
  }) {
    return SessionTemplate(
      size: size,
      playable: playable,
      initPlayable: initPlayable == true ? null : this.initPlayable,
      enlargedTemplate: enlargedTemplate == true ? null : this.enlargedTemplate,
      randomlyPlacedThirdParties: randomlyPlacedThirdParties == true
          ? null
          : this.randomlyPlacedThirdParties,
      elements: elements,
    );
  }
}
