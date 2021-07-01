// GENERATED CODE - DO NOT MODIFY MANUALLY
// **************************************************************************
// Auto generated by https://github.com/fluttercandies/ff_annotation_route
// **************************************************************************

import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/widgets.dart';
import 'pages/main_page.dart';

// ignore_for_file: prefer_const_literals_to_create_immutables
FFRouteSettings getRouteSettings({
  @required String name,
  Map<String, dynamic> arguments,
}) {
  final Map<String, dynamic> safeArguments =
      arguments ?? const <String, dynamic>{};
  switch (name) {
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
