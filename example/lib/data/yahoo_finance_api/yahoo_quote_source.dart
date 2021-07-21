import 'dart:convert';

import 'package:http_client_helper/http_client_helper.dart';
import 'package:loading_more_list/loading_more_list.dart';

import 'quotes_response.dart';

const String _url = 'https://query1.finance.yahoo.com/v7/finance/quote';

String ss =
    'https://query1.finance.yahoo.com/v1/finance/screener?crumb=2pPzKtgGRwz&lang=en-US&region=US&formatted=true&corsDomain=finance.yahoo.com';

/// access-control-allow-credentials: true
/// access-control-allow-headers: Content-Type, Origin
/// access-control-allow-methods: GET, POST, PUT, DELETE, HEAD, OPTIONS
/// access-control-allow-origin: https://finance.yahoo.com
/// age: 0
/// allow: POST,OPTIONS
/// cache-control: private, no-cache, no-store
/// content-length: 1623
/// content-type: application/vnd.sun.wadl+xml
/// date: Sat, 17 Jul 2021 01:38:47 GMT
/// expect-ct: max-age=31536000, report-uri="http://csp.yahoo.com/beacon/csp?src=yahoocom-expect-ct-report-only"
/// last-modified: Sat, 17 Jul 2021 01:38:47 UTC
/// referrer-policy: no-referrer-when-downgrade
/// server: ATS
/// strict-transport-security: max-age=15552000
/// vary: Origin
/// x-content-type-options: nosniff
/// x-envoy-decorator-operation: finance-screeners--mtls-production-gq1.finance-k8s.svc.yahoo.local:4080/*
/// x-envoy-upstream-service-time: 4
/// x-request-id: 0afe6c76-37f1-46fb-beeb-319db91ba28e
/// x-xss-protection: 1; mode=block
/// x-yahoo-request-id: 7c9ebhhgf4d57
/// y-rid: 7c9ebhhgf4d57
/// :authority: query2.finance.yahoo.com
/// :method: OPTIONS
/// :path: /v1/finance/screener?crumb=2pPzKtgGRwz&lang=en-US&region=US&formatted=true&corsDomain=finance.yahoo.com
/// :scheme: https
/// accept: */*
/// accept-encoding: gzip, deflate, br
/// accept-language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6
/// access-control-request-headers: content-type
/// access-control-request-method: POST
/// origin: https://finance.yahoo.com
/// referer: https://finance.yahoo.com/gainers?count=25&offset=25
/// sec-fetch-dest: empty
/// sec-fetch-mode: cors
/// sec-fetch-site: same-site
/// user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36 Edg/91.0.864.70

/// crumb=2pPzKtgGRwz&lang=en-US&region=US&formatted=true&corsDomain=finance.yahoo.com
///
///
/// :authority: query2.finance.yahoo.com
/// :method: OPTIONS
/// :path: /v1/finance/screener?crumb=2pPzKtgGRwz&lang=en-US&region=US&formatted=true&corsDomain=finance.yahoo.com
/// :scheme: https
/// accept: */*
/// accept-encoding: gzip, deflate, br
/// accept-language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6
/// access-control-request-headers: content-type
/// access-control-request-method: POST
/// origin: https://finance.yahoo.com
/// referer: https://finance.yahoo.com/gainers?count=25&offset=25
/// sec-fetch-dest: empty
/// sec-fetch-mode: cors
/// sec-fetch-site: same-site
/// user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36 Edg/91.0.864.70
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
