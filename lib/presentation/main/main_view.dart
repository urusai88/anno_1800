import 'package:anno_flutter/presentation/home/home_view.dart';
import 'package:fluent_ui/fluent_ui.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => MainViewState();
}

class MainViewState extends State<MainView> {
  var selected = 0;

  final paneItems = <NavigationPaneItem>[];

  @override
  void initState() {
    super.initState();
    paneItems.add(buildHomePane());
  }

  PaneItem buildHomePane() {
    return PaneItem(
      icon: const Icon(FluentIcons.home),
      title: const Text('Home'),
      body: const HomeView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: NavigationView(
        appBar: const NavigationAppBar(),
        pane: NavigationPane(
          selected: selected,
          displayMode: PaneDisplayMode.minimal,
          items: paneItems,
        ),
      ),
    );
  }
}
