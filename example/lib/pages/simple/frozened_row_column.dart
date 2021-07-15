import 'package:example/data/flex_grid_source.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/material.dart';
@FFArgumentImport()
import 'package:flex_grid/flex_grid.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

const double cellHeight = 60;
const double cellWidth = 100;
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
    this.syncPageController,
  }) : super(key: key);
  final SyncPageController syncPageController;
  @override
  _FrozenedRowColumnState createState() => _FrozenedRowColumnState();
}

class _FrozenedRowColumnState extends State<FrozenedRowColumn> {
  FlexGridSource source = FlexGridSource();

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Colors.grey.withOpacity(0.5);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
        ),
      ),
      margin: const EdgeInsets.all(15),
      child: FlexGrid<GridRow>(
        frozenedColumnsCount: 1,
        frozenedRowsCount: 1,
        cellHeight: cellHeight,
        headerHeight: cellHeight,
        columnsCount: GridRow.cloumnNames.length,
        horizontalSyncController: widget.syncPageController,
        physics: const AlwaysScrollableClampingScrollPhysics(),
        cellBuilder: (BuildContext context, GridRow data, int row, int column) {
          return Container(
            width: cellWidth,
            height: cellHeight,
            alignment: Alignment.center,
            child: Text(column == 0 ? '$row' : data.columns[column].toString()),
            decoration: BoxDecoration(
              color: column == 0 || row == 0 ? Colors.yellow : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: borderColor,
                ),
                right: column == GridRow.cloumnNames.length - 1
                    ? BorderSide.none
                    : BorderSide(
                        color: borderColor,
                      ),
              ),
            ),
          );
        },
        headerBuilder: (BuildContext context, int index) {
          return Container(
            width: cellWidth,
            height: cellHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.lightGreen,
              border: Border(
                bottom: BorderSide(
                  color: borderColor,
                ),
                right: index == GridRow.cloumnNames.length - 1
                    ? BorderSide.none
                    : BorderSide(
                        color: borderColor,
                      ),
              ),
            ),
            child: Text(GridRow.cloumnNames[index]),
          );
        },
        source: source,
      ),
    );
  }
}
