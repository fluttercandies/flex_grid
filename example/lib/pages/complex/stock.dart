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
  StockRepository source = StockRepository(<String>[
    'sh600519',
    'sz000625',
    'sz002818',
    'sz000333',
    'sz000651',
    'sh600031',
    'sh000001',
    'sz399001',
    'sh688509',
    'sh688511',
    'sh688609',
    'sh688819',
    'sh688663',
    'sh688668',
    'sh688097',
    'sh688575',
    'sh688683',
    'sh688323',
    'sh688551',
    'sh688676',
    'sh600157',
    'sh600769',
    'sh603683',
    'sh600421',
    'sh603693',
    'sh600483',
    'sh601727',
    'sh603985',
    'sh603559',
    'sh605167',
    'sh601137',
    'sh603214',
    'sh605286',
    'sh603115',
    'sh601636',
    'sh601222',
    'sh600111',
    'sh603305',
    'sh603806',
    'sh605186',
    'sh603991',
    'sh603063',
    'sh601877',
    'sh601016',
    'sh600366',
    'sh605111',
    'sh603324',
    'sh605117',
  ]);
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
          if (column == 0) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(data.name),
                Text(data.code),
              ],
            );
          }
          return Container(
            child: Text(
              data.columns[column].toString(),
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
