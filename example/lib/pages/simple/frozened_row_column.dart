import 'package:example/data/flex_grid_source.dart';
import 'package:example/data/utils.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
@FFArgumentImport()
import 'package:flex_grid/flex_grid.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

const double leftRightMargin = 15;

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
  const FrozenedRowColumn({
    Key key,
    this.link = false,
  }) : super(key: key);
  final bool link;

  @override
  _FrozenedRowColumnState createState() => _FrozenedRowColumnState();
}

class _FrozenedRowColumnState extends State<FrozenedRowColumn> {
  FlexGridSource source = FlexGridSource();

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Colors.grey.withOpacity(0.5);
    final MyCellStyle style =
        MyCellStyle(frozenedColumnsCount: 1, frozenedRowsCount: 1);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
        ),
      ),
      margin: const EdgeInsets.all(15),
      child: FlexGrid<GridRow>(
        frozenedColumnsCount: style.frozenedColumnsCount,
        frozenedRowsCount: style.frozenedRowsCount,
        frozenedTrailingColumnsCount: 1,
        cellStyle: style,
        headerStyle: style,
        footerStyle: style,
        columnsCount: GridRow.cloumnNames.length,
        horizontalPhysics: const ClampingScrollPhysics(),
        link: widget.link,
        physics: const AlwaysScrollableClampingScrollPhysics(),
        cellBuilder: (BuildContext context, GridRow data, int row, int column) {
          return Text(column == 0 ? '$row' : data.columns[column].toString());
        },
        headerBuilder: (BuildContext context, int index) {
          return Text(GridRow.cloumnNames[index]);
        },
        footerBuilder: (BuildContext context, int index) {
          return Text(GridRow.footerNames[index]);
        },
        source: source,
      ),
    );
  }
}
