import 'dart:ui';

import 'package:example/data/tu_chong_repository.dart';
import 'package:example/data/tu_chong_source.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/material.dart';
import 'package:flex_grid/flex_grid.dart';

const double cellHeight = 60;

const double leftRightMargin = 15;
List<String> cloumnNames = <String>[
  'AuthorName',
  'Favorites',
  'Comments',
  'Time',
  'Followers',
];

@FFRoute(
  name: 'fluttercandies://FrozenedRowColumn',
  routeName: 'FrozenedRowColumn',
  description: 'FrozenedRowColumn',
  exts: <String, dynamic>{
    'group': 'Simple',
    'order': 0,
  },
)
class FrozenedRowColumn extends StatefulWidget {
  const FrozenedRowColumn({Key key}) : super(key: key);

  @override
  _FrozenedRowColumnState createState() => _FrozenedRowColumnState();
}

class _FrozenedRowColumnState extends State<FrozenedRowColumn> {
  TuChongRepository listSourceRepository = TuChongRepository(maxLength: 100);

  @override
  Widget build(BuildContext context) {
    final double windowWidth = MediaQueryData.fromWindow(window).size.width;

    final double cellWidth = (windowWidth - leftRightMargin * 2) / 3;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: leftRightMargin),
      child: FlexGrid<TuChongItem>(
        frozenedColumnsCount: 1,
        frozenedRowsCount: 1,
        cellHeight: cellHeight,
        headerHeight: cellHeight,
        columnsCount: cloumnNames.length,
        cellBuilder:
            (BuildContext context, TuChongItem data, int row, int column) {
          return Container(
            color: Colors.white,
            width: cellWidth,
            height: cellHeight,
            alignment: Alignment.center,
            child: Text(data.columns[column].toString()),
          );
        },
        headerBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.white,
            width: cellWidth,
            height: cellHeight,
            alignment: Alignment.center,
            child: Text(cloumnNames[index]),
          );
        },
        list: listSourceRepository,
      ),
    );
  }
}
