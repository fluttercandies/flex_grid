import 'dart:convert';

import 'package:http_client_helper/http_client_helper.dart';
import 'package:loading_more_list/loading_more_list.dart';

import 'quotes_response.dart';

const String _url = 'https://query1.finance.yahoo.com/v7/finance/quote';

String ss =
    'https://query1.finance.yahoo.com/v1/finance/screener?crumb=2pPzKtgGRwz&lang=en-US&region=US&formatted=true&corsDomain=finance.yahoo.com';

class YahooQuoteSource extends LoadingMoreBase<Security> {
  YahooQuoteSource(
    this.symbols,
  );

  static List<String> cloumnNames = <String>[
    'Symbol',
    'Name',
    'Price',
    'PreviousClose',
    'Change',
    '% Change',
    'Low',
    'High',
    'Volume',
    'Avg Vol (3 month)',
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
          _url + '?symbols=${symbols.skip(skipNumber).take(10).join(',')}';
      final Response result = await HttpClientHelper.get(Uri.parse(url));
      if (result.statusCode != 200) {
        return isSuccess;
      }
      final List<Security> list = QuotesResponse.fromJson(
              json.decode(result.body) as Map<String, dynamic>)
          .quoteResponse
          .result;
      if (list.isNotEmpty) {
        addAll(list);
        skipNumber += list.length;
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
