import 'dart:math';

import 'package:anno_flutter/presentation/entry/entry_view.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';

export 'extensions.dart';

class AppScrollBehavior extends FluentScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => PointerDeviceKind.values.toSet();

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    final axis = axisDirectionToAxis(details.direction);

    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          final mse = details.controller.position.maxScrollExtent;
          final o = details.controller.offset;
          final dy = event.scrollDelta.dy;
          final n = min(mse, max(0, o + dy)).toDouble();
          details.controller.jumpTo(n);
        }
      },
      child: Scrollbar(
        controller: details.controller,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: axis == Axis.horizontal ? 16 : 0.0,
            right: axis == Axis.vertical ? 16 : 0.0,
          ),
          child: child,
        ),
      ),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    Widget app = Builder(
      builder: (context) {
        return FluentApp(
          scrollBehavior: const AppScrollBehavior(),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            FluentLocalizations.delegate,
            AppLocalizations.delegate,
          ],
          theme: FluentThemeData(
            brightness: MediaQuery.of(context).platformBrightness,
            tooltipTheme: const TooltipThemeData(
              waitDuration: Duration(milliseconds: 150),
              showDuration: Duration(milliseconds: 150),
            ),
          ),
          themeMode: ThemeMode.dark,
          supportedLocales: const [
            Locale('ru'),
          ],
          home: const EntryView(),
        );
      },
    );

    return MediaQuery.fromWindow(child: app);
  }
}
