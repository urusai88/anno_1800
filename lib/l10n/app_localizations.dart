import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ru.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('ru')];

  /// No description provided for @islandKindSmall.
  ///
  /// In ru, this message translates to:
  /// **'Маленький остров'**
  String get islandKindSmall;

  /// No description provided for @islandKindMedium.
  ///
  /// In ru, this message translates to:
  /// **'Средний остров'**
  String get islandKindMedium;

  /// No description provided for @islandKindLarge.
  ///
  /// In ru, this message translates to:
  /// **'Большой остаров'**
  String get islandKindLarge;

  /// No description provided for @islandKindDecoration.
  ///
  /// In ru, this message translates to:
  /// **'Декоративный остров'**
  String get islandKindDecoration;

  /// No description provided for @islandKindDst.
  ///
  /// In ru, this message translates to:
  /// **'DST - НЕИЗВЕСТНО'**
  String get islandKindDst;

  /// No description provided for @islandKindThirdParty.
  ///
  /// In ru, this message translates to:
  /// **'NPC'**
  String get islandKindThirdParty;

  /// No description provided for @islandKindStoryIsland.
  ///
  /// In ru, this message translates to:
  /// **'Племена (Энбеса)'**
  String get islandKindStoryIsland;

  /// No description provided for @islandKindSettlement.
  ///
  /// In ru, this message translates to:
  /// **'Арчибальд Блейк (Энбеса)'**
  String get islandKindSettlement;

  /// No description provided for @islandKindStrandedsailor.
  ///
  /// In ru, this message translates to:
  /// **'sailor - НЕИЗВЕСТНО'**
  String get islandKindStrandedsailor;

  /// No description provided for @islandKindBattlesite.
  ///
  /// In ru, this message translates to:
  /// **'Место крушения - НЕИЗВЕСТНО'**
  String get islandKindBattlesite;

  /// No description provided for @islandKindContinental.
  ///
  /// In ru, this message translates to:
  /// **'Континент'**
  String get islandKindContinental;

  /// No description provided for @islandKindEncounter.
  ///
  /// In ru, this message translates to:
  /// **'Encounter Трелони - НЕИЗВЕСТНО'**
  String get islandKindEncounter;

  /// No description provided for @landSize.
  ///
  /// In ru, this message translates to:
  /// **'{landSizeName, select, small{Маленький} medium{Средний} large{Большой} other{Не указан (Маленький по умолчанию)}}'**
  String landSize(String landSizeName);

  /// No description provided for @sessionName.
  ///
  /// In ru, this message translates to:
  /// **'{sessionName, select, europe{Старый свет} america{Новый свет} arctic{Арктика} cape{Мыс Трелони} africa{Энбеса} other{}}'**
  String sessionName(String sessionName);

  /// No description provided for @landBiomeName.
  ///
  /// In ru, this message translates to:
  /// **'{landBiomeName, select, europe{Старый свет} america{Новый свет} arctic{Арктика} cape{Мыс Трелони} africa{Энбеса} other{}}'**
  String landBiomeName(String landBiomeName);

  /// No description provided for @landKindName.
  ///
  /// In ru, this message translates to:
  /// **'{landKindName, select, small{Маленький} medium{Средний} large{Большой} decoration{Декорация} other{}}'**
  String landKindName(String landKindName);

  /// No description provided for @archetypeName.
  ///
  /// In ru, this message translates to:
  /// **'{archetypeName, select, europe{Обычный} europeArchipel{Архипелаг} europeAtoll{Атолл} europeCorners{По краям} europeSnowflake{Снежинка} europeIslandArc{Дуга} other{}}'**
  String archetypeName(String archetypeName);

  /// No description provided for @multiplayer.
  ///
  /// In ru, this message translates to:
  /// **'{multiplayerName, select, true{Да} false{Нет} other{}}'**
  String multiplayer(String multiplayerName);

  /// No description provided for @mapSizes.
  ///
  /// In ru, this message translates to:
  /// **'{mapSizesName, select, small{Маленький} medium{Средний} large{Большой} other{}}'**
  String mapSizes(String mapSizesName);

  /// No description provided for @landPropertyName.
  ///
  /// In ru, this message translates to:
  /// **'{landPropertyName, select, biome{Биом} kind{Тип} number{Номер} other{}}'**
  String landPropertyName(String landPropertyName);

  /// No description provided for @uiHomeActionsAddTooltip.
  ///
  /// In ru, this message translates to:
  /// **'Создать новую карту'**
  String get uiHomeActionsAddTooltip;

  /// No description provided for @uiHomeActionsOpenTooltip.
  ///
  /// In ru, this message translates to:
  /// **'Открыть карту'**
  String get uiHomeActionsOpenTooltip;

  /// No description provided for @uiHomeNewSessionDialogTitle.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get uiHomeNewSessionDialogTitle;

  /// No description provided for @uiHomeNewSessionDialogCancel.
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get uiHomeNewSessionDialogCancel;

  /// No description provided for @uiHomeNewSessionDialogNew.
  ///
  /// In ru, this message translates to:
  /// **'Создать'**
  String get uiHomeNewSessionDialogNew;

  /// No description provided for @uiHomeNewSessionDialogNameHeader.
  ///
  /// In ru, this message translates to:
  /// **'Название'**
  String get uiHomeNewSessionDialogNameHeader;

  /// No description provided for @uiHomeNewSessionDialogSizeHeader.
  ///
  /// In ru, this message translates to:
  /// **'Размер'**
  String get uiHomeNewSessionDialogSizeHeader;

  /// No description provided for @uiHomeNewSessionDialogPlayableHeader.
  ///
  /// In ru, this message translates to:
  /// **'Размер игрового поля'**
  String get uiHomeNewSessionDialogPlayableHeader;

  /// No description provided for @uiHomeNewSessionDialogNameValidatorError0.
  ///
  /// In ru, this message translates to:
  /// **'Значение не должно быть пустым'**
  String get uiHomeNewSessionDialogNameValidatorError0;

  /// No description provided for @uiHomeNewSessionDialogSizeValidatorError0.
  ///
  /// In ru, this message translates to:
  /// **'Значение должно быть в пределах 1000 и 3000'**
  String get uiHomeNewSessionDialogSizeValidatorError0;

  /// No description provided for @uiHomeNewSessionDialogPlayableValidatorError0.
  ///
  /// In ru, this message translates to:
  /// **'Значение не должно быть пустым'**
  String get uiHomeNewSessionDialogPlayableValidatorError0;

  /// No description provided for @uiHomeNewSessionDialogPlayableValidatorError1.
  ///
  /// In ru, this message translates to:
  /// **'Значение должно быть в формате \"%d %d %d %d\"'**
  String get uiHomeNewSessionDialogPlayableValidatorError1;

  /// No description provided for @uiHomeNewSessionDialogPlayableValidatorError2.
  ///
  /// In ru, this message translates to:
  /// **'Значение не должно быть ниже 0'**
  String get uiHomeNewSessionDialogPlayableValidatorError2;

  /// No description provided for @uiHomeNewSessionDialogPlayableValidatorError3.
  ///
  /// In ru, this message translates to:
  /// **'Значение не должно быть выше {n}'**
  String uiHomeNewSessionDialogPlayableValidatorError3(Object n);

  /// No description provided for @uiHomeNewSessionDialogSessionValidatorError0.
  ///
  /// In ru, this message translates to:
  /// **'Сессия должна быть выбрана'**
  String get uiHomeNewSessionDialogSessionValidatorError0;

  /// No description provided for @uiHomeOpenSessionDialogPropertyPlaceholder.
  ///
  /// In ru, this message translates to:
  /// **'{placeholder, select, sessionId{Название сессии} multiplayer{Мультиплеер} size{Размер} archetype{Архетип} number{Номер} other{}}'**
  String uiHomeOpenSessionDialogPropertyPlaceholder(String placeholder);

  /// No description provided for @uiHomeOpenSessionDialogTitle.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get uiHomeOpenSessionDialogTitle;

  /// No description provided for @uiHomeOpenSessionDialogCancel.
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get uiHomeOpenSessionDialogCancel;

  /// No description provided for @uiHomeOpenSessionDialogOpen.
  ///
  /// In ru, this message translates to:
  /// **'Открыть'**
  String get uiHomeOpenSessionDialogOpen;

  /// No description provided for @uiHomeAddLandDialogDialogLandKindHeader.
  ///
  /// In ru, this message translates to:
  /// **'Тип острова'**
  String get uiHomeAddLandDialogDialogLandKindHeader;

  /// No description provided for @uiHomeAddLandDialogDialogLandDifficultyName.
  ///
  /// In ru, this message translates to:
  /// **'{dialogLandDifficultyName, select, no{Нет} normal{Средний} hard{Сложный} other{}}'**
  String uiHomeAddLandDialogDialogLandDifficultyName(
      String dialogLandDifficultyName);

  /// No description provided for @uiHomeAddLandDialogDialogLandDifficultyHeader.
  ///
  /// In ru, this message translates to:
  /// **'Зафиксировать сложность острова'**
  String get uiHomeAddLandDialogDialogLandDifficultyHeader;

  /// No description provided for @uiHomeAddLandDialogRandomLandSizeHeader.
  ///
  /// In ru, this message translates to:
  /// **'Размер острова'**
  String get uiHomeAddLandDialogRandomLandSizeHeader;

  /// No description provided for @uiHomeAddLandDialogSpecifiedBiomeHeader.
  ///
  /// In ru, this message translates to:
  /// **'Биом (сессия)'**
  String get uiHomeAddLandDialogSpecifiedBiomeHeader;

  /// No description provided for @uiHomeAddLandDialogNpcType.
  ///
  /// In ru, this message translates to:
  /// **'Тип случайного острова НПЦ'**
  String get uiHomeAddLandDialogNpcType;

  /// No description provided for @dialogCommonLandType.
  ///
  /// In ru, this message translates to:
  /// **'{dialogCommonLandType, select, random{Случайный} specified{Специализированный} other{}}'**
  String dialogCommonLandType(String dialogCommonLandType);

  /// No description provided for @uiHomeAddLandDialogDialogLandKind.
  ///
  /// In ru, this message translates to:
  /// **'{dialogLandKindName, select, common{Игровой остров} decoration{Декорация} thirdParty{НПЦ} continental{Континент} gas{Газ} quest{Квест} other{}}'**
  String uiHomeAddLandDialogDialogLandKind(String dialogLandKindName);

  /// No description provided for @uiHomeAddLandDialogDialogLandNpcTypeName.
  ///
  /// In ru, this message translates to:
  /// **'{dialogLandNpcType, select, pirate{Пиратский} no{Случайный} other{}}'**
  String uiHomeAddLandDialogDialogLandNpcTypeName(String dialogLandNpcType);

  /// No description provided for @uiInfoBarSaveButton.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить сессию'**
  String get uiInfoBarSaveButton;

  /// No description provided for @uiInfoBarAddLandButton.
  ///
  /// In ru, this message translates to:
  /// **'Добавить остров'**
  String get uiInfoBarAddLandButton;

  /// No description provided for @uiInfoBarOpenImageButton.
  ///
  /// In ru, this message translates to:
  /// **'Открыть изображение'**
  String get uiInfoBarOpenImageButton;

  /// No description provided for @uiInfoBarRemoveLandButton.
  ///
  /// In ru, this message translates to:
  /// **'Удалить остров'**
  String get uiInfoBarRemoveLandButton;

  /// No description provided for @uiInfoBarSessionInfo.
  ///
  /// In ru, this message translates to:
  /// **'Сессия'**
  String get uiInfoBarSessionInfo;

  /// No description provided for @uiInfoBarElementInfo.
  ///
  /// In ru, this message translates to:
  /// **'Выделенный элемент'**
  String get uiInfoBarElementInfo;

  /// No description provided for @uiInfoBarSessionIdLabel.
  ///
  /// In ru, this message translates to:
  /// **'Сессия'**
  String get uiInfoBarSessionIdLabel;

  /// No description provided for @uiInfoBarSizeLabel.
  ///
  /// In ru, this message translates to:
  /// **'Размер'**
  String get uiInfoBarSizeLabel;

  /// No description provided for @uiInfoBarPlayableLabel.
  ///
  /// In ru, this message translates to:
  /// **'Игровые границы'**
  String get uiInfoBarPlayableLabel;

  /// No description provided for @uiInfoBarElementTypeLabel.
  ///
  /// In ru, this message translates to:
  /// **'Тип элемента'**
  String get uiInfoBarElementTypeLabel;

  /// No description provided for @uiInfoBarElementType.
  ///
  /// In ru, this message translates to:
  /// **'{elementType, select, LandEntity{Остров} ShipEntity{Корабль} other{}}'**
  String uiInfoBarElementType(String elementType);

  /// No description provided for @uiInfoBarElementPosition.
  ///
  /// In ru, this message translates to:
  /// **'Координаты'**
  String get uiInfoBarElementPosition;

  /// No description provided for @uiInfoBarLandSizeLabel.
  ///
  /// In ru, this message translates to:
  /// **'Размер острова'**
  String get uiInfoBarLandSizeLabel;

  /// No description provided for @uiInfoBarLandElementSizeLabel.
  ///
  /// In ru, this message translates to:
  /// **'Размер элемента'**
  String get uiInfoBarLandElementSizeLabel;

  /// No description provided for @uiInfoBarLandRotationLabel.
  ///
  /// In ru, this message translates to:
  /// **'Поворот'**
  String get uiInfoBarLandRotationLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
