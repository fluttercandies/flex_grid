import 'package:example/pages/simple/frozened_row_column.dart';
import 'package:extended_tabs/extended_tabs.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flex_grid/flex_grid.dart';
import 'package:flutter/material.dart';

@FFRoute(
  name: 'fluttercandies://TabView',
  routeName: 'TabView',
  description: 'TabView',
  exts: <String, dynamic>{
    'group': 'Simple',
    'order': 1,
  },
)
class TabView extends StatefulWidget {
  const TabView({Key? key}) : super(key: key);

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> with TickerProviderStateMixin {
  TabController? controller;
  TabController? controller1;
  @override
  void initState() {
    super.initState();
    const int index = 0;
    controller = TabController(length: 2, vsync: this, initialIndex: index);
    controller1 = TabController(length: 3, vsync: this, initialIndex: index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar(
          tabs: const <Widget>[
            Tab(text: 'Tab1'),
            Tab(text: 'Tab2'),
          ],
          controller: controller,
          labelColor: Colors.blue,
        ),
        Expanded(
          child: ExtendedTabBarView(
            controller: controller,
            shouldIgnorePointerWhenScrolling: false,
            children: <Widget>[
              Column(
                children: <Widget>[
                  TabBar(
                    tabs: const <Widget>[
                      Tab(text: 'Tab11'),
                      Tab(text: 'Tab12'),
                      Tab(text: 'Tab13')
                    ],
                    controller: controller1,
                    labelColor: Colors.blue,
                  ),
                  Expanded(
                    child: ExtendedTabBarView(
                      shouldIgnorePointerWhenScrolling: false,
                      controller: controller1,
                      children: const <Widget>[
                        KeepAliveWidget(),
                        KeepAliveWidget(),
                        KeepAliveWidget(),
                      ],
                    ),
                  )
                ],
              ),
              Container(
                color: Colors.red,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class KeepAliveWidget extends StatefulWidget {
  const KeepAliveWidget({Key? key}) : super(key: key);
  @override
  _KeepAliveWidgetState createState() => _KeepAliveWidgetState();
}

class _KeepAliveWidgetState extends State<KeepAliveWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const FrozenedRowColumn(
      link: true,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
