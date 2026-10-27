import 'dart:async';

import 'package:animation_player/animation_player.dart';
import 'package:material_ui/material_ui.dart';
import 'package:progress_animation_builder/progress_animation_builder.dart';

void main() => runApp(const App());

class const App({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: _Home(),
    );
  }
}

class const _Home() extends StatefulWidget {
  @override
  __HomeState createState() => __HomeState();
}

class __HomeState() extends State<_Home> {
  var _isInitial = false;

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 3), (_) {
      setState(() => _isInitial = !_isInitial);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimationPlayer example'),
      ),
      body: ListView.separated(
        itemCount: _icons.length,
        itemBuilder: (context, index) {
          final icon = _icons[index];
          return ListTile(
            title: ProgressAnimationBuilder(
              value: _isInitial ? 0 : 1,
              duration: const Duration(milliseconds: 1000),
              builder: (context, animation) {
                return AnimatedIcon(
                  icon: icon,
                  progress: animation,
                );
              },
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (context) => _DetailPage(
                    iconData: icon,
                  ),
                ),
              );
            },
          );
        },
        separatorBuilder: (_, _) => const Divider(height: 0),
      ),
    );
  }
}

class const _DetailPage({
  required final AnimatedIconData iconData,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final targetSize = MediaQuery.of(context).size.width * 2 / 3;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: AnimationPlayer(
          builder: (context, animation) {
            return AnimatedIcon(
              size: targetSize,
              icon: iconData,
              progress: animation,
            );
          },
        ),
      ),
    );
  }
}

const _icons = <AnimatedIconData>[
  AnimatedIcons.add_event,
  AnimatedIcons.arrow_menu,
  AnimatedIcons.close_menu,
  AnimatedIcons.ellipsis_search,
  AnimatedIcons.event_add,
  AnimatedIcons.home_menu,
  AnimatedIcons.list_view,
  AnimatedIcons.menu_arrow,
  AnimatedIcons.menu_close,
  AnimatedIcons.menu_home,
  AnimatedIcons.pause_play,
  AnimatedIcons.play_pause,
  AnimatedIcons.search_ellipsis,
  AnimatedIcons.view_list,
];
