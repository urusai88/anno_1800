import 'package:anno_flutter/infrastructure/mod_manager.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';

import '../../anno_flutter.dart';
import '../../domain/game_data/game_data.dart';
import 'dialogs/new_session_dialog.dart';
import 'dialogs/open_session_dialog.dart';
import 'home_view_provider.dart';
import 'redactor/redactor_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewProvider>(
      create: (context) => HomeViewProvider(
        gameDataProvider: context.read<GameDataProvider>(),
        mod: context.read<ModManager>(),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          HomeViewActions(),
          Divider(direction: Axis.vertical),
          Expanded(child: HomeViewTabs()),
        ],
      ),
    );
  }
}

class HomeViewActions extends StatelessWidget {
  const HomeViewActions({super.key});

  void newSession(BuildContext context) async {
    final result = await showDialog<NewSessionSuccess>(
      context: context,
      barrierDismissible: true,
      builder: (context) => const NewSessionDialog(),
    );
    if (result == null) {
      return;
    }
    context.read<HomeViewProvider>().newSession(result);
  }

  void openSession(BuildContext context) async {
    final result = await showDialog<List<SessionProperty>>(
      context: context,
      barrierDismissible: true,
      builder: (context) => const OpenSessionDialog(),
    );
    if (result == null) {
      return;
    }
    context
        .read<HomeViewProvider>()
        .openSession(result, AppLocalizations.of(context)!);
  }

  void openDebugSession(BuildContext context) {
    context.read<HomeViewProvider>().openSession(const <SessionProperty>[
      SessionProperty.sessionId(SessionId.europe),
      SessionProperty.archetype(MapArchetype.europe),
      SessionProperty.size(
        MapSizes(MapIslandSize.small, MapIslandSize.small),
      ),
      SessionProperty.number(1),
    ], AppLocalizations.of(context)!);
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ButtonStyle(
      padding: ButtonState.all(const EdgeInsets.all(24)),
    );

    return Column(
      children: [
        Tooltip(
          message: AppLocalizations.of(context)!.uiHomeActionsAddTooltip,
          child: IconButton(
            style: buttonStyle,
            icon: const Icon(FluentIcons.add),
            onPressed: () => newSession(context),
          ),
        ),
        Tooltip(
          message: AppLocalizations.of(context)!.uiHomeActionsOpenTooltip,
          child: IconButton(
            style: buttonStyle,
            icon: const Icon(FluentIcons.process_map),
            onPressed: () => openSession(context),
          ),
        ),
        if (kDebugMode)
          Tooltip(
            message: AppLocalizations.of(context)!.uiHomeActionsOpenTooltip,
            child: IconButton(
              style: buttonStyle,
              icon: const Icon(FluentIcons.process_map),
              onPressed: () => openDebugSession(context),
            ),
          ),
      ],
    );
  }
}

class HomeViewTabs extends StatefulWidget {
  const HomeViewTabs({super.key});

  @override
  State<HomeViewTabs> createState() => _HomeViewTabsState();
}

class _HomeViewTabsState extends State<HomeViewTabs> {
  var currentIndex = 0;

  void close(SessionEntity session) {
    context.read<HomeViewProvider>().close(session);
    if (currentIndex > 0) {
      setState(() => currentIndex--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessions = context.watch<HomeViewProvider>().sessions;

    Iterable<Tab> buildTabs() sync* {
      for (final entry in sessions.entries) {
        yield Tab(
          onClosed: () => close(entry.value),
          text: Text(entry.key),
          body: RedactorView(session: entry.value),
        );
      }
    }

    final tabs = buildTabs().toList();

    return TabView(
      currentIndex: currentIndex,
      tabWidthBehavior: TabWidthBehavior.sizeToContent,
      onChanged: (i) => setState(() => currentIndex = i),
      tabs: tabs,
    );
  }
}
