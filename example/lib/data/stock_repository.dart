import 'package:flex_grid/flex_grid.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:loading_more_list/loading_more_list.dart';

const String _url = 'http://qt.gtimg.cn';

class StockRepository extends LoadingMoreBase<StockInfo> {
  StockRepository(
    this.symbols,
  );

  static List<String> cloumnNames = <String>[
    'Name',
    'Symbol',
    'Price',
    'PreviousClose',
    'Open',
    'Volume',
    'time',
    'Change',
    '% Change',
    'High',
    'Low',
    'Amount',
  ];

  final List<String> symbols;
  int skipNumber = 0;
  @override
  bool get hasMore => skipNumber != symbols.length;

  @override
  Future<bool> refresh([bool notifyStateChanged = false]) {
    skipNumber = 0;
    return super.refresh(notifyStateChanged);
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    bool isSuccess = false;
    try {
      //to show loading more clearly, in your app,remove this
      //await Future.delayed(const Duration(milliseconds: 500));

      final String url =
          _url + '/q=${symbols.skip(skipNumber).take(10).join(',')}';
      final Response result = await HttpClientHelper.get(Uri.parse(url));
      if (result.statusCode != 200) {
        return isSuccess;
      }

      final List<String> stocks = result.body.split(';');

      if (stocks.isNotEmpty) {
        addAll(stocks.map((String e) => StockInfo.fromLine(e)));
        skipNumber += stocks.length;
      }

      isSuccess = true;
    } catch (exception, stack) {
      isSuccess = false;
      print(exception);
      print(stack);
    }
    return isSuccess;
  }
}

class StockInfo with FlexGridRow {
  StockInfo({
    this.name,
    this.code,
    this.price,
    this.preClose,
    this.open,
    this.volume,
    this.time,
    this.change,
    this.changePercent,
    this.high,
    this.low,
    this.amount,
  });

  factory StockInfo.fromLine(String line) {
    final List<String> fileds = line.split('~');
    return StockInfo(
      name: fileds[1],
      code: fileds[2],
      price: fileds[3],
      preClose: fileds[4],
      open: fileds[5],
      volume: fileds[6],
      amount: fileds[7],
      time: fileds[30],
      change: fileds[31],
      changePercent: fileds[32],
      high: fileds[33],
      low: fileds[34],
    );
  }

  final String name;
  final String code;
  final String price;
  final String preClose;
  final String open;
  final String volume;
  final String time;
  final String change;
  final String changePercent;

  final String high;

  final String low;

  //final String close;

  final String amount;

  @override
  List<Object> get columns => <Object>[
        name,
        code,
        price,
        preClose,
        open,
        volume,
        time,
        change,
        changePercent,
        high,
        low,
        amount,
      ];
}
