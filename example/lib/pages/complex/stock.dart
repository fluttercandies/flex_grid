import 'package:example/data/flex_grid_source.dart';
import 'package:example/data/stock_repository.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/material.dart';
@FFArgumentImport()
import 'package:flex_grid/flex_grid.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

const double leftRightMargin = 15;

@FFRoute(
  name: 'fluttercandies://StockList',
  routeName: 'StockList',
  description: 'StockList',
  exts: <String, dynamic>{
    'group': 'Complex',
    'order': 1,
  },
)
class StockList extends StatefulWidget {
  const StockList({
    Key key,
  }) : super(key: key);
  @override
  _StockListState createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  StockRepository source =
      StockRepository(<String>['sh600519', 'sh000625', 'sz002818', 'sz']);
  int frozenedColumnsCount = 1;
  @override
  void initState() {
    //YahooHistoricalSource('000001.ss')..refresh();
    super.initState();
  }

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
      child: FlexGrid<StockInfo>(
        frozenedColumnsCount: frozenedColumnsCount,
        columnsCount: StockRepository.cloumnNames.length,
        physics: const AlwaysScrollableClampingScrollPhysics(),
        cellBuilder:
            (BuildContext context, StockInfo data, int row, int column) {
          return Container(
            child: Text(
              data.columns[column].toString(),
              // style: TextStyle(
              //   color: column == 4 || column == 5 ? data.changeColor : null,
              // ),
            ),
            decoration: BoxDecoration(
              color:
                  column < frozenedColumnsCount ? Colors.yellow : Colors.white,
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
          return Text(StockRepository.cloumnNames[index]);
        },
        source: source,
      ),
    );
  }
}
