import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get islandKindSmall => 'Маленький остров';

  @override
  String get islandKindMedium => 'Средний остров';

  @override
  String get islandKindLarge => 'Большой остаров';

  @override
  String get islandKindDecoration => 'Декоративный остров';

  @override
  String get islandKindDst => 'DST - НЕИЗВЕСТНО';

  @override
  String get islandKindThirdParty => 'NPC';

  @override
  String get islandKindStoryIsland => 'Племена (Энбеса)';

  @override
  String get islandKindSettlement => 'Арчибальд Блейк (Энбеса)';

  @override
  String get islandKindStrandedsailor => 'sailor - НЕИЗВЕСТНО';

  @override
  String get islandKindBattlesite => 'Место крушения - НЕИЗВЕСТНО';

  @override
  String get islandKindContinental => 'Континент';

  @override
  String get islandKindEncounter => 'Encounter Трелони - НЕИЗВЕСТНО';

  @override
  String landSize(String landSizeName) {
    String _temp0 = intl.Intl.selectLogic(
      landSizeName,
      {
        'small': 'Маленький',
        'medium': 'Средний',
        'large': 'Большой',
        'other': 'Не указан (Маленький по умолчанию)',
      },
    );
    return '$_temp0';
  }

  @override
  String sessionName(String sessionName) {
    String _temp0 = intl.Intl.selectLogic(
      sessionName,
      {
        'europe': 'Старый свет',
        'america': 'Новый свет',
        'arctic': 'Арктика',
        'cape': 'Мыс Трелони',
        'africa': 'Энбеса',
        'other': '',
      },
    );
    return '$_temp0';
  }

  @override
  String landBiomeName(String landBiomeName) {
    String _temp0 = intl.Intl.selectLogic(
      landBiomeName,
      {
        'europe': 'Старый свет',
        'america': 'Новый свет',
        'arctic': 'Арктика',
        'cape': 'Мыс Трелони',
        'africa': 'Энбеса',
        'other': '',
      },
    );
    return '$_temp0';
  }

  @override
  String landKindName(String landKindName) {
    String _temp0 = intl.Intl.selectLogic(
      landKindName,
      {
        'small': 'Маленький',
        'medium': 'Средний',
        'large': 'Большой',
        'decoration': 'Декорация',
        'other': '',
      },
    );
    return '$_temp0';
  }

  @override
  String archetypeName(String archetypeName) {
    String _temp0 = intl.Intl.selectLogic(
      archetypeName,
      {
        'europe': 'Обычный',
        'europeArchipel': 'Архипелаг',
        'europeAtoll': 'Атолл',
        'europeCorners': 'По краям',
        'europeSnowflake': 'Снежинка',
        'europeIslandArc': 'Дуга',
        'other': '',
      },
    );
    return '$_temp0';
  }

  @override
  String multiplayer(String multiplayerName) {
    String _temp0 = intl.Intl.selectLogic(
      multiplayerName,
      {
        'true': 'Да',
        'false': 'Нет',
        'other': '',
      },
    );
    return '$_temp0';
  }

  @override
  String mapSizes(String mapSizesName) {
    String _temp0 = intl.Intl.selectLogic(
      mapSizesName,
      {
        'small': 'Маленький',
        'medium': 'Средний',
        'large': 'Большой',
        'other': '',
      },
    );
    return '$_temp0';
  }

  @override
  String landPropertyName(String landPropertyName) {
    String _temp0 = intl.Intl.selectLogic(
      landPropertyName,
      {
        'biome': 'Биом',
        'kind': 'Тип',
        'number': 'Номер',
        'other': '',
      },
    );
    return '$_temp0';
  }

  @override
  String get uiHomeActionsAddTooltip => 'Создать новую карту';

  @override
  String get uiHomeActionsOpenTooltip => 'Открыть карту';

  @override
  String get uiHomeNewSessionDialogTitle => 'Настройки';

  @override
  String get uiHomeNewSessionDialogCancel => 'Назад';

  @override
  String get uiHomeNewSessionDialogNew => 'Создать';

  @override
  String get uiHomeNewSessionDialogNameHeader => 'Название';

  @override
  String get uiHomeNewSessionDialogSizeHeader => 'Размер';

  @override
  String get uiHomeNewSessionDialogPlayableHeader => 'Размер игрового поля';

  @override
  String get uiHomeNewSessionDialogNameValidatorError0 =>
      'Значение не должно быть пустым';

  @override
  String get uiHomeNewSessionDialogSizeValidatorError0 =>
      'Значение должно быть в пределах 1000 и 3000';

  @override
  String get uiHomeNewSessionDialogPlayableValidatorError0 =>
      'Значение не должно быть пустым';

  @override
  String get uiHomeNewSessionDialogPlayableValidatorError1 =>
      'Значение должно быть в формате \"%d %d %d %d\"';

  @override
  String get uiHomeNewSessionDialogPlayableValidatorError2 =>
      'Значение не должно быть ниже 0';

  @override
  String uiHomeNewSessionDialogPlayableValidatorError3(Object n) {
    return 'Значение не должно быть выше $n';
  }

  @override
  String get uiHomeNewSessionDialogSessionValidatorError0 =>
      'Сессия должна быть выбрана';

  @override
  String uiHomeOpenSessionDialogPropertyPlaceholder(String placeholder) {
    String _temp0 = intl.Intl.selectLogic(
      placeholder,
      {
        'sessionId': 'Название сессии',
        'multiplayer': 'Мультиплеер',
        'size': 'Размер',
        'archetype': 'Архетип',
        'number': 'Номер',
        'other': '',
      },
    );
    return '$_temp0';
  }

  @override
  String get uiHomeOpenSessionDialogTitle => 'Настройки';

  @override
  String get uiHomeOpenSessionDialogCancel => 'Назад';

  @override
  String get uiHomeOpenSessionDialogOpen => 'Открыть';

  @override
  String get uiHomeAddLandDialogDialogLandKindHeader => 'Тип острова';

  @override
  String uiHomeAddLandDialogDialogLandDifficultyName(
      String dialogLandDifficultyName) {
    String _temp0 = intl.Intl.selectLogic(
      dialogLandDifficultyName,
      {
        'no': 'Нет',
        'normal': 'Средний',
        'hard': 'Сложный',
        'other': '',
      },
    );
    return '$_temp0';
  }

  @override
  String get uiHomeAddLandDialogDialogLandDifficultyHeader =>
      'Зафиксировать сложность острова';

  @override
  String get uiHomeAddLandDialogRandomLandSizeHeader => 'Размер острова';

  @override
  String get uiHomeAddLandDialogSpecifiedBiomeHeader => 'Биом (сессия)';

  @override
  String get uiHomeAddLandDialogNpcType => 'Тип случайного острова НПЦ';

  @override
  String dialogCommonLandType(String dialogCommonLandType) {
    String _temp0 = intl.Intl.selectLogic(
      dialogCommonLandType,
      {
        'random': 'Случайный',
        'specified': 'Специализированный',
        'other': '',
      },
    );
    return '$_temp0';
  }

  @override
  String uiHomeAddLandDialogDialogLandKind(String dialogLandKindName) {
    String _temp0 = intl.Intl.selectLogic(
      dialogLandKindName,
      {
        'common': 'Игровой остров',
        'decoration': 'Декорация',
        'thirdParty': 'НПЦ',
        'continental': 'Континент',
        'gas': 'Газ',
        'quest': 'Квест',
        'other': '',
      },
    );
    return '$_temp0';
  }

  @override
  String uiHomeAddLandDialogDialogLandNpcTypeName(String dialogLandNpcType) {
    String _temp0 = intl.Intl.selectLogic(
      dialogLandNpcType,
      {
        'pirate': 'Пиратский',
        'no': 'Случайный',
        'other': '',
      },
    );
    return '$_temp0';
  }

  @override
  String get uiInfoBarSaveButton => 'Сохранить сессию';

  @override
  String get uiInfoBarAddLandButton => 'Добавить остров';

  @override
  String get uiInfoBarOpenImageButton => 'Открыть изображение';

  @override
  String get uiInfoBarRemoveLandButton => 'Удалить остров';

  @override
  String get uiInfoBarSessionInfo => 'Сессия';

  @override
  String get uiInfoBarElementInfo => 'Выделенный элемент';

  @override
  String get uiInfoBarSessionIdLabel => 'Сессия';

  @override
  String get uiInfoBarSizeLabel => 'Размер';

  @override
  String get uiInfoBarPlayableLabel => 'Игровые границы';

  @override
  String get uiInfoBarElementTypeLabel => 'Тип элемента';

  @override
  String uiInfoBarElementType(String elementType) {
    String _temp0 = intl.Intl.selectLogic(
      elementType,
      {
        'LandEntity': 'Остров',
        'ShipEntity': 'Корабль',
        'other': '',
      },
    );
    return '$_temp0';
  }

  @override
  String get uiInfoBarElementPosition => 'Координаты';

  @override
  String get uiInfoBarLandSizeLabel => 'Размер острова';

  @override
  String get uiInfoBarLandElementSizeLabel => 'Размер элемента';

  @override
  String get uiInfoBarLandRotationLabel => 'Поворот';
}
