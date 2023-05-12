import 'dart:async';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
// ignore: implementation_imports
import 'package:equatable/src/equatable_utils.dart' show equals;
import 'package:flex_grid/flex_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gbk2utf8/flutter_gbk2utf8.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:loading_more_list/loading_more_list.dart';

import 'utils.dart';

const String _url = 'http://qt.gtimg.cn';

class StockRepository extends LoadingMoreBase<StockInfo> {
  StockRepository() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      _update();
    });
    lastRefreshTime = DateTime.now();
  }

  static List<String> cloumnNames = <String>[
    'Name/Code',
    'Price',
    'Close',
    'Open',
    'Volume',
    //'time',
    'Change',
    '% Change',
    'High',
    'Low',
    'Amount',
  ];

  final List<String> symbols = <String>[
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
  ];
  int skipNumber = 0;
  int _firstIndex = -1;
  int _lastIndex = -1;
  @override
  bool get hasMore => skipNumber < symbols.length;
  late Timer _timer;
  DateTime? lastRefreshTime;
  int get frozenedColumnsCount => 1;
  @override
  Future<bool> refresh([bool notifyStateChanged = false]) async {
    skipNumber = 0;
    final bool done = await super.refresh(notifyStateChanged);

    lastRefreshTime = DateTime.now();
    return done;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    bool isSuccess = false;
    try {
      //to show loading more clearly, in your app,remove this
      //await Future.delayed(const Duration(milliseconds: 500));

      final String url =
          _url + '/q=${symbols.skip(skipNumber).take(10).join(',')}';
      final Response result =
          await (HttpClientHelper.get(Uri.parse(url)) as FutureOr<Response>);
      if (result.statusCode != 200) {
        return isSuccess;
      }

      final List<String> stocks = gbk.decode(result.bodyBytes).split('\n');
      stocks.removeWhere((String element) => element.isEmpty);

      if (stocks.isNotEmpty) {
        for (final String stock in stocks) {
          add(StockInfo.fromLine(stock));
        }
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

  void updateViewport(int firstIndex, int lastIndex) {
    _firstIndex = firstIndex;
    _lastIndex = lastIndex;
  }

  // just an demo, in fact you should update all stock
  Future<void> _update() async {
    if (_firstIndex >= 0 && _lastIndex > _firstIndex && _lastIndex < length) {
      final String url = _url +
          '/q=${skip(_firstIndex).take(_lastIndex - _firstIndex).map((StockInfo e) => e.fullCode).join(',')}';
      final Response result =
          await (HttpClientHelper.get(Uri.parse(url)) as FutureOr<Response>);

      if (result.statusCode == 200) {
        final List<String> stocks = gbk.decode(result.bodyBytes).split('\n');
        stocks.removeWhere((String element) => element.isEmpty);

        if (stocks.isNotEmpty) {
          for (final String stock in stocks) {
            final StockInfo newStock = StockInfo.fromLine(stock);

            final StockInfo? oldStock = firstWhereOrNull(
              (StockInfo element) => newStock == element,
            );
            if (oldStock != null) {
              oldStock.update(newStock);
            }
          }
        }
      }
    }
  }
}

class StockInfo with FlexGridRow, EquatableMixin, ChangeNotifier {
  StockInfo({
    this.fullCode,
    this.name,
    this.code,
    this.price,
    this.close,
    this.open,
    this.volume,
    this.change,
    this.changePercent,
    this.high,
    this.low,
    this.amount,
  });

  factory StockInfo.fromLine(String line) {
    final List<String> fileds = line.split('~');
    return StockInfo(
      // v_sz000858="
      fullCode: fileds[0].split('=').first.split('_').last,
      name: fileds[1],
      code: fileds[2],
      price: asT<double>(fileds[3]),
      close: asT<double>(fileds[4]),
      open: asT<double>(fileds[5]),
      volume: fileds[6],
      amount: fileds[37],
      //time: fileds[30],
      change: asT<double>(fileds[31]),
      changePercent: asT<double>(fileds[32]),
      high: asT<double>(fileds[33]),
      low: asT<double>(fileds[34]),
    );
  }
  String? fullCode;
  String? name;
  String? code;
  double? price;
  double? close;
  double? open;
  String? volume;
  double? change;
  double? changePercent;
  double? high;
  double? low;
  String? amount;

  @override
  List<Object?> get columns => <Object?>[
        name,
        price,
        close,
        open,
        volume,
        change,
        changePercent.toString() + '%',
        high,
        low,
        amount,
      ];

  Color? getTextColor(int column) {
    if (column == 1) {
      return _getTextColor(price, close);
    } else if (column == 3) {
      return _getTextColor(open, close);
    } else if (column == 5 || column == 6) {
      return _getTextColor(change, 0);
    } else if (column == 7) {
      return _getTextColor(high, close);
    } else if (column == 8) {
      return _getTextColor(low, close);
    }
    return null;
  }

  Color _getTextColor(double? left, double? right) {
    return left == right
        ? Colors.black
        : (left! > right! ? Colors.red : Colors.green);
  }

  void update(StockInfo stockInfo) {
    if (stockInfo == this && !equals(stockInfo.compareProps, compareProps)) {
      price = stockInfo.price;
      close = stockInfo.close;
      open = stockInfo.open;
      volume = stockInfo.volume;
      change = stockInfo.change;
      changePercent = stockInfo.changePercent;
      high = stockInfo.high;
      low = stockInfo.low;
      amount = stockInfo.amount;
      backgroundColor = Colors.blue.withOpacity(0.4);
      Future<void>.delayed(
        const Duration(milliseconds: 200),
        () {
          backgroundColor = Colors.white;
        },
      );
    }
  }

  @override
  List<Object?> get props => <Object?>[
        fullCode,
      ];

  List<Object?> get compareProps => <Object?>[
        fullCode,
        name,
        price,
        close,
        open,
        volume,
        change,
        changePercent,
        high,
        low,
        amount,
      ];

  Color _backgroundColor = Colors.white;
  Color get backgroundColor => _backgroundColor;
  set backgroundColor(Color value) {
    if (_backgroundColor != value) {
      _backgroundColor = value;
      notifyListeners();
    }
  }

  bool _showMenu = false;
  bool get showMenu => _showMenu;
  set showMenu(bool value) {
    if (_showMenu != value) {
      _showMenu = value;
      notifyListeners();
    }
  }
}
