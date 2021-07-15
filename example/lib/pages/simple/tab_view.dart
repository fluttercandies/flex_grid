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
  const TabView({Key key}) : super(key: key);

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> with SingleTickerProviderStateMixin {
  TabController controller;
  SyncPageController _syncPageController;
  @override
  void initState() {
    super.initState();
    const int index = 1;
    controller = TabController(length: 3, vsync: this, initialIndex: index);
    _syncPageController = SyncPageController(initialPage: index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar(
          tabs: const <Widget>[
            Tab(text: 'Tab1'),
            Tab(text: 'Tab2'),
            Tab(text: 'Tab3')
          ],
          controller: controller,
          labelColor: Colors.blue,
        ),
        Expanded(
          child: ExtendedTabBarView(
            physics: const LessSpringClampingScrollPhysics(),
            controller: controller,
            pageController: _syncPageController,
            children: <Widget>[
              Container(
                color: Colors.yellow,
              ),
              KeepAliveWidget(
                syncPageController: _syncPageController,
              ),
              Container(
                color: Colors.blue,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class KeepAliveWidget extends StatefulWidget {
  const KeepAliveWidget({Key key, this.syncPageController}) : super(key: key);
  final SyncPageController syncPageController;
  @override
  _KeepAliveWidgetState createState() => _KeepAliveWidgetState();
}

class _KeepAliveWidgetState extends State<KeepAliveWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FrozenedRowColumn(
      syncPageController: widget.syncPageController,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
