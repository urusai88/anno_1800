import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';

import '../../../anno_flutter.dart';
import '../../../domain/game_data/game_data.dart';

class NewSessionSuccess {
  const NewSessionSuccess(this.name, this.size, this.playable, this.sessionId);

  final String name;
  final AnnoOffset size;
  final AnnoRect playable;
  final SessionId sessionId;
}

class NewSessionDialog extends StatefulWidget {
  const NewSessionDialog({super.key});

  @override
  State<NewSessionDialog> createState() => NewSessionDialogState();
}

class NewSessionDialogState extends State<NewSessionDialog> {
  final nameController = TextEditingController();
  final sizeController = TextEditingController();
  final playableController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  String nameValue = '';
  String sizeValue = '';
  String playableValue = '';

  SessionId? sessionId;

  var validated = false;

  AppLocalizations get loc => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      nameValue = nameController.text = 'Map 1';
      sizeValue = sizeController.text = '1920';
      playableValue = playableController.text = '330 400 1830 1900';
      sessionId = SessionId.europe;
      validated = true;
    }
  }

  void newSession() {
    final s = int.parse(sizeValue);
    final p = clearPlayable(playableValue).split(' ').map(int.parse).toList();

    Navigator.of(context).pop(
      NewSessionSuccess(
        nameValue,
        AnnoOffset(s, s),
        AnnoRect(p[0], p[1], p[2], p[3]),
        sessionId!,
      ),
    );
  }

  void updateValidated() {
    if (formKey.currentState != null) {
      setState(() => validated = formKey.currentState!.validate());
    }
  }

  String? nameValidator(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return loc.uiHomeNewSessionDialogNameValidatorError0;
    }
    return null;
  }

  String? sizeValidator(String? value) {
    final error = loc.uiHomeNewSessionDialogSizeValidatorError0;
    if (value == null) {
      return error;
    }
    final i = int.tryParse(value);
    if (i == null || i < 1000 || i > 3000) {
      return error;
    }
    return null;
  }

  String? playableValidator(String? value) {
    if (value == null) {
      return loc.uiHomeNewSessionDialogPlayableValidatorError0;
    }
    while (value!.contains('  ')) {
      value = value.replaceAll('  ', ' ');
    }
    final parts = value.trim().split(' ');
    if (parts.length != 4) {
      return loc.uiHomeNewSessionDialogPlayableValidatorError1;
    }
    var intsNullable = parts.map(int.tryParse).toList();
    if (intsNullable.contains(null)) {
      return 'A value must be in "%d %d %d %d" format';
    }
    final ints = intsNullable.map((e) => e as int).toList();
    final size = int.tryParse(sizeValue);
    for (final i in ints) {
      if (i < 0) {
        return loc.uiHomeNewSessionDialogPlayableValidatorError2;
      }
      if (size != null && i > size) {
        return loc.uiHomeNewSessionDialogPlayableValidatorError3(size);
      }
    }
    return null;
  }

  String? sessionValidator(SessionId? session) {
    if (session == null) {
      return loc.uiHomeNewSessionDialogSessionValidatorError0;
    }
    return null;
  }

  static String clearPlayable(String value) {
    while (value.contains('  ')) {
      value = value.replaceAll('  ', ' ');
    }
    return value.trim();
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Center(child: Text(loc.uiHomeNewSessionDialogTitle)),
      content: Form(
        key: formKey,
        onChanged: updateValidated,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InfoLabel(label: loc.uiHomeNewSessionDialogNameHeader),
            TextFormBox(
              controller: nameController,
              validator: nameValidator,
              onChanged: (v) => setState(() => nameValue = v),
            ),
            const SizedBox(height: 4),
            InfoLabel(label: loc.uiHomeNewSessionDialogSizeHeader),
            TextFormBox(
              controller: sizeController,
              placeholder: '1920',
              validator: sizeValidator,
              onChanged: (v) => setState(() => sizeValue = v),
            ),
            const SizedBox(height: 4),
            InfoLabel(label: loc.uiHomeNewSessionDialogPlayableHeader),
            TextFormBox(
              controller: playableController,
              placeholder: '180 180 1800 1820',
              validator: playableValidator,
              onChanged: (v) => setState(() => playableValue = v),
            ),
            const SizedBox(height: 4),
            InfoLabel(label: loc.uiHomeNewSessionDialogPlayableHeader),
            ComboboxFormField<SessionId>(
              value: sessionId,
              items: [
                for (final value in SessionId.values)
                  ComboBoxItem(
                    value: value,
                    child: Text(loc.sessionName(value.name)),
                  ),
              ],
              onChanged: (v) => setState(() => sessionId = v),
              validator: sessionValidator,
            ),
          ],
        ),
      ),
      actions: [
        Button(
          onPressed: () => Navigator.pop(context),
          child: Text(loc.uiHomeNewSessionDialogCancel),
        ),
        FilledButton(
          onPressed: validated ? newSession : null,
          child: Text(loc.uiHomeOpenSessionDialogOpen),
        ),
      ],
    );
  }
}
