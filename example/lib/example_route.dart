// GENERATED CODE - DO NOT MODIFY MANUALLY
// **************************************************************************
// Auto generated by https://github.com/fluttercandies/ff_annotation_route
// **************************************************************************

import 'package:flex_grid/flex_grid.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/widgets.dart';
import 'pages/complex/excel.dart';
import 'pages/complex/stock.dart';
import 'pages/main_page.dart';
import 'pages/simple/frozened_row_column.dart';
import 'pages/simple/huge_data.dart';
import 'pages/simple/tab_view.dart';

// ignore_for_file: prefer_const_literals_to_create_immutables
FFRouteSettings getRouteSettings({
  @required String name,
  Map<String, dynamic> arguments,
}) {
  final Map<String, dynamic> safeArguments =
      arguments ?? const <String, dynamic>{};
  switch (name) {
    case 'fluttercandies://Excel':
      return FFRouteSettings(
        name: name,
        arguments: arguments,
        widget: ExcelDemo(
          key: asT<Key>(safeArguments['key']),
        ),
        routeName: 'Excel',
        description: 'Excel',
        exts: <String, dynamic>{'group': 'Complex', 'order': 0},
      );
    case 'fluttercandies://FrozenedRowColumn':
      return FFRouteSettings(
        name: name,
        arguments: arguments,
        widget: FrozenedRowColumn(
          key: asT<Key>(safeArguments['key']),
          syncPageController:
              asT<SyncPageController>(safeArguments['syncPageController']),
        ),
        routeName: 'FrozenedRowColumn',
        description: 'FrozenedRowColumn',
        exts: <String, dynamic>{'group': 'Simple', 'order': 0},
      );
    case 'fluttercandies://HugeDataDemo':
      return FFRouteSettings(
        name: name,
        arguments: arguments,
        widget: HugeDataDemo(
          key: asT<Key>(safeArguments['key']),
        ),
        routeName: 'HugeDataDemo',
        description: 'HugeDataDemo',
        exts: <String, dynamic>{'group': 'Simple', 'order': 2},
      );
    case 'fluttercandies://StockList':
      return FFRouteSettings(
        name: name,
        arguments: arguments,
        widget: StockList(
          key: asT<Key>(safeArguments['key']),
        ),
        routeName: 'StockList',
        description: 'StockList',
        exts: <String, dynamic>{'group': 'Complex', 'order': 1},
      );
    case 'fluttercandies://TabView':
      return FFRouteSettings(
        name: name,
        arguments: arguments,
        widget: TabView(
          key: asT<Key>(safeArguments['key']),
        ),
        routeName: 'TabView',
        description: 'TabView',
        exts: <String, dynamic>{'group': 'Simple', 'order': 1},
      );
    case 'fluttercandies://demogrouppage':
      return FFRouteSettings(
        name: name,
        arguments: arguments,
        widget: DemoGroupPage(
          keyValue: asT<MapEntry<String, List<DemoRouteResult>>>(
              safeArguments['keyValue']),
        ),
        routeName: 'DemoGroupPage',
      );
    case 'fluttercandies://mainpage':
      return FFRouteSettings(
        name: name,
        arguments: arguments,
        widget: MainPage(),
        routeName: 'MainPage',
      );
    default:
      return const FFRouteSettings(name: '404', routeName: '404_page');
  }
}
