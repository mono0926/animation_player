import 'dart:async';

import 'package:animation_player/animation_player.dart';
import 'package:flutter/material.dart';
import 'package:progress_animation_builder/progress_animation_builder.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const _Home(),
    );
  }
}

class _Home extends StatefulWidget {
  const _Home({Key key}) : super(key: key);

  @override
  __HomeState createState() => __HomeState();
}

class __HomeState extends State<_Home> {
  var _isInitial = false;

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 3), (_) {
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
              duration: Duration(milliseconds: 1000),
              builder: (context, animation) {
                return AnimatedIcon(
                  icon: icon,
                  progress: animation,
                );
              },
            ),
            trailing: Icon(Icons.chevron_right),
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
        separatorBuilder: (_, __) => const Divider(height: 0),
      ),
    );
  }
}

class _DetailPage extends StatelessWidget {
  const _DetailPage({
    Key key,
    @required this.iconData,
  }) : super(key: key);

  final AnimatedIconData iconData;

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
  AnimatedIcons.view_list
];
