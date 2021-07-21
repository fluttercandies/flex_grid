import 'package:http_client_helper/http_client_helper.dart';
import 'package:loading_more_list/loading_more_list.dart';

import 'candle.dart';
import 'period.dart';
import 'show_option.dart';

const String _url = 'https://query1.finance.yahoo.com/v7/finance/download';

class YahooHistoricalSource extends LoadingMoreBase<Candle> {
  YahooHistoricalSource(
    this.symbol,
  ) {
    end = DateTime.now().toUtc().difference(DateTime(1970, 1, 1, 0, 0, 0));
  }

  final String symbol;
  Duration end;
  Duration get start => end - const Duration(days: 50);
  @override
  bool get hasMore => true;

  @override
  Future<bool> refresh([bool notifyStateChanged = false]) {
    return super.refresh(notifyStateChanged);
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    bool isSuccess = false;
    try {
      //to show loading more clearly, in your app,remove this
      //await Future.delayed(const Duration(milliseconds: 500));

      final String url = _url +
          '/$symbol?period1=${start.inSeconds}&period2=${end.inSeconds}&interval=1${Period.Daily.name}&events=${ShowOption.History.name}';
      final Response result = await HttpClientHelper.get(Uri.parse(url));

      if (result.statusCode != 200) {
        return isSuccess;
      }

      final List<String> lines = result.body.split('\n');
      for (int i = 1; i < lines.length; i++) {
        add(Candle.fromList(lines[i].split(',')));
      }

      end = last.dateTime.difference(DateTime(1970, 1, 1, 0, 0, 0));

      isSuccess = true;
    } catch (exception, stack) {
      isSuccess = false;
      print(exception);
      print(stack);
    }
    return isSuccess;
  }
}
