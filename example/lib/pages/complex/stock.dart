import 'package:example/data/flex_grid_source.dart';
import 'package:example/data/yahoo_finance_api/quotes_response.dart';
import 'package:example/data/yahoo_finance_api/yahoo_historical_source.dart';
import 'package:example/data/yahoo_finance_api/yahoo_quote_source.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/material.dart';
@FFArgumentImport()
import 'package:flex_grid/flex_grid.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

const double cellHeight = 60;
const double cellWidth = 100;
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
  YahooQuoteSource source = YahooQuoteSource(<String>[
    '000001.ss',
    '399001.sz',
    'SRAMF',
    'RLLCF',
    'AVASF',
  ]);
  int frozenedColumnsCount = 1;
  @override
  void initState() {
    YahooHistoricalSource('000001.ss')..refresh();
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
      child: FlexGrid<Security>(
        frozenedColumnsCount: frozenedColumnsCount,
        cellHeight: cellHeight,
        headerHeight: cellHeight,
        columnsCount: YahooQuoteSource.cloumnNames.length,
        physics: const AlwaysScrollableClampingScrollPhysics(),
        cellBuilder:
            (BuildContext context, Security data, int row, int column) {
          return Container(
            width: cellWidth,
            height: cellHeight,
            alignment: Alignment.center,
            child: Text(
              data.columns[column].toString(),
              style: TextStyle(
                color: column == 4 || column == 5 ? data.changeColor : null,
              ),
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
                right: index == YahooQuoteSource.cloumnNames.length - 1
                    ? BorderSide.none
                    : BorderSide(
                        color: borderColor,
                      ),
              ),
            ),
            child: Text(YahooQuoteSource.cloumnNames[index]),
          );
        },
        source: source,
      ),
    );
  }
}
