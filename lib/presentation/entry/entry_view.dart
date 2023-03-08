import 'package:anno_flutter/infrastructure/rda_provider.dart';
import 'package:anno_flutter/presentation/main/main_view.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../anno_flutter.dart';

class EntryView extends StatefulWidget {
  const EntryView({super.key});

  @override
  State<EntryView> createState() => EntryViewState();
}

class EntryViewState extends State<EntryView> {
  late GameDataProvider gameDataProvider = context.read<GameDataProvider>();

  @override
  void initState() {
    super.initState();
    gameDataProvider.addListener(gameDataListener);
  }

  @override
  void dispose() {
    gameDataProvider.removeListener(gameDataListener);
    super.dispose();
  }

  void gameDataListener() {
    if (gameDataProvider.value.isSuccess) {
      Navigator.pushAndRemoveUntil(
        context,
        FluentPageRoute(builder: (context) => const MainView()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameData = context.watch<GameDataProvider>().value;

    Widget child = gameData.map(
      failure: (_) => const ProgressRing(),
      loading: (_) => const ProgressRing(),
      success: (_) => const ProgressRing(),
      extracting: (value) {
        String? stepName;
        String? progressName;
        if (value.step?.isReading ?? false) {
          stepName = 'Чтение (1/3)';
        } else if (value.step?.isComputing ?? false) {
          stepName = 'Вычисление (2/3)';
        } else if (value.step?.isCopying ?? false) {
          stepName = 'Копирование (3/3)';
        }

        if (value.current != null && value.total != null) {
          progressName = '${value.current}/${value.total}';
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ProgressRing(),
            const SizedBox(height: 8),
            Text('Распаковка'),
            if (stepName != null && progressName != null)
              Text('$stepName $progressName'),
          ],
        );
      },
      gameDirectorySuccess: (success) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Директория ${success.path} является директорией Anno 1800'),
            const SizedBox(height: 8),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: FilledButton(
                onPressed: context.read<GameDataProvider>().beginExtract,
                child: Text('Начать разархивирование данных'),
              ),
            ),
          ],
        );
      },
      gameDirectoryFailure: (failure) {
        String errorText;
        if (failure.path == null) {
          errorText = 'Не удалось определить директорию Anno 1800';
        } else {
          errorText =
              'Директория ${failure.path!} не является директорией Anno 1800';
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(errorText),
            const SizedBox(height: 8),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: FilledButton(
                onPressed: context.read<GameDataProvider>().promptGameDirectory,
                child: Text('Выбрать директорию\nAnno 1800'),
              ),
            ),
          ],
        );
      },
      initial: (_) => const ProgressRing(),
    );

    return Acrylic(
      child: Center(
        child: Center(child: child),
      ),
    );
  }
}
