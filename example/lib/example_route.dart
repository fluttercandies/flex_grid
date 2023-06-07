// GENERATED CODE - DO NOT MODIFY MANUALLY
// **************************************************************************
// Auto generated by https://github.com/fluttercandies/ff_annotation_route
// **************************************************************************
// fast mode: true
// version: 10.0.9
// **************************************************************************
// ignore_for_file: prefer_const_literals_to_create_immutables,unused_local_variable,unused_import,unnecessary_import,unused_shown_name,implementation_imports,duplicate_import
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flex_grid/flex_grid.dart';
import 'package:flutter/widgets.dart';

import 'pages/complex/excel.dart';
import 'pages/complex/stock.dart';
import 'pages/main_page.dart';
import 'pages/simple/frozened_row_column.dart';
import 'pages/simple/huge_data.dart';
import 'pages/simple/tab_view.dart';

/// Get route settings base on route name, auto generated by https://github.com/fluttercandies/ff_annotation_route
FFRouteSettings getRouteSettings({
  required String name,
  Map<String, dynamic>? arguments,
  PageBuilder? notFoundPageBuilder,
}) {
  final Map<String, dynamic> safeArguments =
      arguments ?? const <String, dynamic>{};
  switch (name) {
    case 'fluttercandies://Excel':
      return FFRouteSettings(
        name: name,
        arguments: arguments,
        builder: () => ExcelDemo(
          key: asT<Key?>(
            safeArguments['key'],
          ),
        ),
        routeName: 'Excel',
        description: 'Excel',
        exts: <String, dynamic>{
          'group': 'Complex',
          'order': 0,
        },
      );
    case 'fluttercandies://FrozenedRowColumn':
      return FFRouteSettings(
        name: name,
        arguments: arguments,
        builder: () => FrozenedRowColumn(
          key: asT<Key?>(
            safeArguments['key'],
          ),
          link: asT<bool>(
            safeArguments['link'],
            false,
          )!,
        ),
        routeName: 'FrozenedRowColumn',
        description: 'FrozenedRowColumn',
        exts: <String, dynamic>{
          'group': 'Simple',
          'order': 0,
        },
      );
    case 'fluttercandies://HugeDataDemo':
      return FFRouteSettings(
        name: name,
        arguments: arguments,
        builder: () => HugeDataDemo(
          key: asT<Key?>(
            safeArguments['key'],
          ),
        ),
        routeName: 'HugeDataDemo',
        description: 'HugeDataDemo',
        exts: <String, dynamic>{
          'group': 'Simple',
          'order': 2,
        },
      );
    case 'fluttercandies://StockList':
      return FFRouteSettings(
        name: name,
        arguments: arguments,
        builder: () => StockList(
          key: asT<Key?>(
            safeArguments['key'],
          ),
        ),
        routeName: 'StockList',
        description: 'StockList',
        exts: <String, dynamic>{
          'group': 'Complex',
          'order': 1,
        },
      );
    case 'fluttercandies://TabView':
      return FFRouteSettings(
        name: name,
        arguments: arguments,
        builder: () => TabView(
          key: asT<Key?>(
            safeArguments['key'],
          ),
        ),
        routeName: 'TabView',
        description: 'TabView',
        exts: <String, dynamic>{
          'group': 'Simple',
          'order': 1,
        },
      );
    case 'fluttercandies://demogrouppage':
      return FFRouteSettings(
        name: name,
        arguments: arguments,
        builder: () => DemoGroupPage(
          keyValue: asT<MapEntry>(
            safeArguments['keyValue'],
          )!,
        ),
        routeName: 'DemoGroupPage',
      );
    case 'fluttercandies://mainpage':
      return FFRouteSettings(
        name: name,
        arguments: arguments,
        builder: () => MainPage(),
        routeName: 'MainPage',
      );
    default:
      return FFRouteSettings(
        name: FFRoute.notFoundName,
        routeName: FFRoute.notFoundRouteName,
        builder: notFoundPageBuilder ?? () => Container(),
      );
  }
}
