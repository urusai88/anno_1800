import 'package:bless_annotation/bless_annotation.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../../../anno_flutter.dart';
import '../../../../domain/game_data/game_data.dart';
import '../../home_view_provider.dart';
import 'specified_land_list.dart';
import 'specified_land_menu.dart';

part 'redactor_land_dialog.g.dart';

@BlessIt()
enum DialogLandKind {
  common,
  decoration,
  thirdParty,
  continental,
  gas,
  quest;
}

@BlessIt()
enum DialogCommonLandType {
  random,
  specified;
}

@BlessIt()
enum DialogLandDifficulty {
  no,
  normal,
  hard;
}

@BlessIt()
enum DialogLandNpcType {
  no,
  pirate;
}

class RedactorLandDialog extends StatefulWidget {
  const RedactorLandDialog({super.key, required this.sessionName});

  final String sessionName;

  @override
  State<RedactorLandDialog> createState() => RedactorLandDialogState();
}

class RedactorLandDialogState extends State<RedactorLandDialog> {
  DialogLandKind? dialogKind;
  DialogCommonLandType? commonLandType;
  LandSize? commonLandSize;
  DialogLandDifficulty commonLandDifficulty = DialogLandDifficulty.no;
  DialogLandNpcType dialogLandNpcType = DialogLandNpcType.no;

  SessionId? sessionId;

  LandBiome? landBiome;
  LandKind? specifyLandKind;
  LandDataFile? specifyLandDataFile;

  bool validated = false;

  late GameDataProviderStateSuccess gameData;

  HomeViewProvider get homeViewProvider => context.read<HomeViewProvider>();

  AppLocalizations get loc => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    final gameData = context.read<GameDataProvider>().value.asSuccess;
    assert(gameData != null);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    gameData = context.watch<GameDataProvider>().value.asSuccess!;
  }

  void validate() {
    if (dialogKind == null) return setState(() => validated = false);

    if (dialogKind!.isCommon) {
      if (commonLandType == null) return setState(() => validated = false);

      if (commonLandType!.isRandom) {
        return setState(() => validated =
            // ignore: unnecessary_null_comparison
            commonLandSize != null && commonLandDifficulty != null);
      }
      if (commonLandType!.isSpecified) {
        return setState(() => validated = specifyLandDataFile != null);
      }
    }
    if (dialogKind!.isDecoration) {
      if (commonLandType == null) return setState(() => validated = false);
      if (commonLandType!.isRandom) return setState(() => validated = true);
      if (commonLandType!.isSpecified) {
        return setState(() => validated = specifyLandDataFile != null);
      }
    }
    if (dialogKind!.isThirdParty) {
      if (commonLandType == null) return setState(() => validated = false);
      if (commonLandType!.isRandom) {
        // ignore: unnecessary_null_comparison
        return setState(() => validated = dialogLandNpcType != null);
      }
      if (commonLandType!.isSpecified) {
        return setState(() => validated = specifyLandDataFile != null);
      }
    }
    if (dialogKind!.isContinental) {
      return setState(() => validated = specifyLandDataFile != null);
    }
    if (dialogKind!.isGas) {
      return setState(() => validated = specifyLandDataFile != null);
    }
    if (dialogKind!.isQuest) {
      return setState(() => validated = specifyLandDataFile != null);
    }
  }

  void onKindChanged(DialogLandKind? kind) {
    setState(() => dialogKind = kind);
    validate();
  }

  void onBasicKindChanged(DialogCommonLandType? value, bool isTrue) {
    setState(() => commonLandType = value ?? DialogCommonLandType.random);
    validate();
  }

  void onBasicLandSizeChanged(LandSize? value, bool isTrue) {
    setState(() => commonLandSize = value);
    validate();
  }

  void onDialogLandDifficultyChanged(
    DialogLandDifficulty? value,
    bool isTrue,
  ) {
    setState(() => commonLandDifficulty = value ?? DialogLandDifficulty.no);
    validate();
  }

  void add() {
    if (!validated || dialogKind == null) return;
    // Обработка случаев со специализированными островами
    if (dialogKind!.isCommon ||
        dialogKind!.isDecoration ||
        dialogKind!.isThirdParty) {
      if (commonLandType?.isSpecified ?? false) {
        if (specifyLandDataFile == null) return;
        homeViewProvider.addLand(widget.sessionName, specifyLandDataFile!);
        return Navigator.pop(context);
      }
    }

    if (dialogKind!.isContinental || dialogKind!.isGas || dialogKind!.isQuest) {
      if (specifyLandDataFile == null) return;
      homeViewProvider.addLand(widget.sessionName, specifyLandDataFile!);
      return Navigator.pop(context);
    }

    if (dialogKind!.isCommon ||
        dialogKind!.isDecoration ||
        dialogKind!.isThirdParty) {
      if (commonLandType == null) return;
      if (commonLandType!.isRandom) {
        if (dialogKind!.isCommon) {
          if (commonLandSize == null) return;
          homeViewProvider.addRandomLand(widget.sessionName, commonLandSize!);
        }
        if (dialogKind!.isDecoration) {
          homeViewProvider.addDecorationLand(widget.sessionName);
        }
        if (dialogKind!.isThirdParty) {
          // ignore: unnecessary_null_comparison
          if (dialogLandNpcType == null) return;
          homeViewProvider.addThirdPartyLand(
              widget.sessionName, dialogLandNpcType.isPirate);
        }
      }
      if (commonLandType!.isSpecified) {
        if (specifyLandDataFile == null) return;
        homeViewProvider.addLand(widget.sessionName, specifyLandDataFile!);
      }
    }

    Navigator.pop(context);
  }

  Widget kindComboBox() {
    Iterable<ComboBoxItem<DialogLandKind>> comboBoxList() sync* {
      for (final kind in DialogLandKind.values) {
        yield ComboBoxItem(
          value: kind,
          child: Text(loc.uiHomeAddLandDialogDialogLandKind(kind.name)),
        );
      }
    }

    return IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoLabel(label: loc.uiHomeAddLandDialogDialogLandKindHeader),
          ComboBox<DialogLandKind>(
            value: dialogKind,
            placeholder: Text(loc.uiHomeAddLandDialogDialogLandKindHeader),
            onChanged: onKindChanged,
            items: comboBoxList().toList(),
          ),
        ],
      ),
    );
  }

  Widget commonToggle() {
    Iterable<Widget> buildRadioList() sync* {
      for (var i = 0; i < DialogCommonLandType.values.length; ++i) {
        final value = DialogCommonLandType.values[i];

        yield IntrinsicWidth(
          child: RadioButton(
            checked: commonLandType == value,
            onChanged: (isTrue) => onBasicKindChanged(value, isTrue),
            content: Text(loc.dialogCommonLandType(value.name)),
          ),
        );

        if (i < LandSize.values.length) {
          yield const SizedBox(width: 8);
        }
      }
    }

    return Wrap(
      children: buildRadioList().toList(),
    );
  }

  Widget commonRandom() {
    Iterable<Widget> buildRadioList() sync* {
      for (var i = 0; i < LandSize.values.length; ++i) {
        final value = LandSize.values[i];

        yield IntrinsicWidth(
          child: RadioButton(
            checked: commonLandSize == value,
            onChanged: (isTrue) => onBasicLandSizeChanged(value, isTrue),
            content: Text(loc.landSize(value.name)),
          ),
        );

        if (i < LandSize.values.length) {
          yield const SizedBox(width: 8);
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InfoLabel(label: loc.uiHomeAddLandDialogRandomLandSizeHeader),
        Wrap(
          alignment: WrapAlignment.start,
          children: buildRadioList().toList(),
        ),
      ],
    );
  }

  Widget commonRandomDifficulty() {
    Iterable<Widget> buildRadioList() sync* {
      for (var i = 0; i < DialogLandDifficulty.values.length; ++i) {
        final value = DialogLandDifficulty.values[i];
        final content =
            loc.uiHomeAddLandDialogDialogLandDifficultyName(value.name);

        yield IntrinsicWidth(
          child: RadioButton(
            checked: commonLandDifficulty == value,
            onChanged: (isTrue) => onDialogLandDifficultyChanged(value, isTrue),
            content: Text(content),
          ),
        );

        if (i < LandSize.values.length) {
          yield const SizedBox(width: 8);
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InfoLabel(label: loc.uiHomeAddLandDialogDialogLandDifficultyHeader),
        Wrap(
          alignment: WrapAlignment.start,
          children: buildRadioList().toList(),
        ),
      ],
    );
  }

  Widget commonSpecified() {
    Iterable<LandDataFile> lands = gameData.lands;
    final dialogKind = this.dialogKind;

    if (dialogKind != null) {
      if (dialogKind.isCommon) {
        lands = lands.where((e) {
          return <LandKind>[
            LandKind.small,
            LandKind.medium,
            LandKind.large,
            // LandKind.continental,
          ].contains(e.props.whereType<LandPropertyKind>().first.kind);
        });
      } else if (dialogKind.isDecoration) {
        lands = lands.where((e) {
          return <LandKind>[
            LandKind.decoration,
            LandKind.dst,
          ].contains(e.props.whereType<LandPropertyKind>().first.kind);
        });
      } else if (dialogKind.isThirdParty) {
        lands = lands.where((e) {
          return <LandKind>[
            LandKind.thirdParty,
          ].contains(e.props.whereType<LandPropertyKind>().first.kind);
        });
      } else if (dialogKind.isContinental) {
        lands = lands.where((e) {
          return <LandKind>[
            LandKind.continental,
          ].contains(e.props.whereType<LandPropertyKind>().first.kind);
        });
      } else if (dialogKind.isGas) {
        lands = lands.where((e) {
          return <LandKind>[
            LandKind.gas,
          ].contains(e.props.whereType<LandPropertyKind>().first.kind);
        });
      } else if (dialogKind.isQuest) {
        lands = lands.where((e) {
          return <LandKind>[
            LandKind.encounter,
            LandKind.settlement,
            LandKind.storyIsland,
            LandKind.strandedsailor,
          ].contains(e.props.whereType<LandPropertyKind>().first.kind);
        });
      }
    }

    if (landBiome != null) {
      lands = lands.where((e) {
        return e.props.whereType<LandPropertyBiome>().first.biome == landBiome;
      });
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: SpecifiedLandMenu(
              biome: landBiome,
              kind: specifyLandKind,
              onBiomeChanged: (value) => setState(() {
                specifyLandDataFile = null;
                landBiome = value;
                validate();
              }),
              onKindChanged: (value) => setState(() {
                specifyLandDataFile = null;
                specifyLandKind = value;
                validate();
              }),
            ),
          ),
          Expanded(
            flex: 4,
            child: SpecifiedLandPicked(
              lands: lands.toList(),
              picked: specifyLandDataFile,
              onTap: (v) {
                setState(() => specifyLandDataFile = v);
                validate();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget npcType() {
    Iterable<Widget> buildRadioList() sync* {
      for (var i = 0; i < DialogLandNpcType.values.length; ++i) {
        final value = DialogLandNpcType.values[i];

        yield IntrinsicWidth(
          child: RadioButton(
            checked: dialogLandNpcType == value,
            onChanged: (isTrue) {
              setState(() {
                dialogLandNpcType = value;
                validate();
              });
            },
            content: Text(
              loc.uiHomeAddLandDialogDialogLandNpcTypeName(value.name),
            ),
          ),
        );

        if (i < LandSize.values.length) {
          yield const SizedBox(width: 8);
        }
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InfoLabel(label: loc.uiHomeAddLandDialogNpcType),
        Wrap(children: buildRadioList().toList()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return ContentDialog(
      constraints: BoxConstraints.tight(mq.size * 0.8),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(alignment: Alignment.centerLeft, child: kindComboBox()),
                if (dialogKind != null) const SizedBox(height: 8),
                if (dialogKind?.isCommon ?? false) ...[
                  commonToggle(),
                  if (commonLandType?.isRandom ?? false) ...[
                    const SizedBox(height: 8),
                    commonRandom(),
                    const SizedBox(height: 8),
                    commonRandomDifficulty(),
                  ],
                  if (commonLandType?.isSpecified ?? false) ...[
                    const SizedBox(height: 8),
                    commonSpecified(),
                  ],
                ],
                if (dialogKind?.isDecoration ?? false) ...[
                  commonToggle(),
                  if (commonLandType?.isSpecified ?? false) ...[
                    const SizedBox(height: 8),
                    commonSpecified(),
                  ],
                ],
                if (dialogKind?.isThirdParty ?? false) ...[
                  commonToggle(),
                  if (commonLandType?.isSpecified ?? false) ...[
                    const SizedBox(height: 8),
                    commonSpecified(),
                  ],
                  if (commonLandType?.isRandom ?? false) ...[
                    const SizedBox(height: 8),
                    npcType(),
                  ]
                ],
                if (dialogKind?.isContinental ?? false) ...[
                  commonSpecified(),
                ],
                if (dialogKind?.isGas ?? false) ...[
                  commonSpecified(),
                ],
                if (dialogKind?.isQuest ?? false) ...[
                  commonSpecified(),
                ],
              ],
            ),
          ),
          Row(
            children: [
              const Spacer(),
              FilledButton(
                onPressed: validated ? add : null,
                child: Text('add'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
