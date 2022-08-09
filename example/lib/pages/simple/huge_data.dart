import 'package:example/data/big_data_source.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
@FFArgumentImport()
import 'package:flex_grid/flex_grid.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

@FFRoute(
  name: 'fluttercandies://HugeDataDemo',
  routeName: 'HugeDataDemo',
  description: 'HugeDataDemo',
  exts: <String, dynamic>{
    'group': 'Simple',
    'order': 2,
  },
)
class HugeDataDemo extends StatefulWidget {
  const HugeDataDemo({
    Key key,
  }) : super(key: key);
  @override
  _HugeDataDemoState createState() => _HugeDataDemoState();
}

class _HugeDataDemoState extends State<HugeDataDemo> {
  BigData source = BigData();

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Colors.grey.withOpacity(0.5);
    return Column(
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Rows:      10000\nColumns: 10000'),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: borderColor,
              ),
            ),
            margin: const EdgeInsets.all(15),
            child: FlexGrid<BigDataRow>(
              frozenedColumnsCount: 1,
              highPerformance: true,
              columnsCount: BigDataRow.columnCount,
              physics: const AlwaysScrollableClampingScrollPhysics(),
              cellBuilder:
                  (BuildContext context, BigDataRow data, int row, int column) {
                return Text(
                    column == 0 ? '$row' : data.columns[column].toString());
              },
              headerBuilder: (BuildContext context, int index) {
                return Text('Header$index');
              },
              source: source,
            ),
          ),
        ),
      ],
    );
  }
}
