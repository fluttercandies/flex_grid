import 'dart:convert';
import 'dart:ui';
import 'package:flex_grid/flex_grid.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

class QuotesResponse {
  QuotesResponse({
    this.quoteResponse,
  });

  factory QuotesResponse.fromJson(Map<String, dynamic> jsonRes) =>
      jsonRes == null
          ? null
          : QuotesResponse(
              quoteResponse: QuoteResponse.fromJson(
                  asT<Map<String, dynamic>>(jsonRes['quoteResponse'])),
            );

  QuoteResponse quoteResponse;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'quoteResponse': quoteResponse,
      };
  @override
  String toString() {
    return jsonEncode(this);
  }
}

class QuoteResponse {
  QuoteResponse({
    this.error,
    this.result,
  });

  factory QuoteResponse.fromJson(Map<String, dynamic> jsonRes) {
    if (jsonRes == null) {
      return null;
    }

    final List<Security> result =
        jsonRes['result'] is List ? <Security>[] : null;
    if (result != null) {
      for (final dynamic item in jsonRes['result']) {
        if (item != null) {
          tryCatch(() {
            result.add(Security.fromJson(asT<Map<String, dynamic>>(item)));
          });
        }
      }
    }
    return QuoteResponse(
      error: asT<Object>(jsonRes['error']),
      result: result,
    );
  }

  Object error;
  List<Security> result;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'error': error,
        'result': result,
      };
  @override
  String toString() {
    return jsonEncode(this);
  }
}

class Security with FlexGridRow {
  Security({
    this.ask,
    this.askSize,
    this.averageDailyVolume10Day,
    this.averageDailyVolume3Month,
    this.bid,
    this.bidSize,
    this.bookValue,
    this.currency,
    this.earningsTimestamp,
    this.earningsTimestampEnd,
    this.earningsTimestampStart,
    this.epsForward,
    this.epsTrailingTwelveMonths,
    this.esgPopulated,
    this.exchange,
    this.exchangeDataDelayedBy,
    this.exchangeTimezoneName,
    this.exchangeTimezoneShortName,
    this.fiftyDayAverage,
    this.fiftyDayAverageChange,
    this.fiftyDayAverageChangePercent,
    this.fiftyTwoWeekHigh,
    this.fiftyTwoWeekHighChange,
    this.fiftyTwoWeekHighChangePercent,
    this.fiftyTwoWeekLow,
    this.fiftyTwoWeekLowChange,
    this.fiftyTwoWeekLowChangePercent,
    this.fiftyTwoWeekRange,
    this.financialCurrency,
    this.firstTradeDateMilliseconds,
    this.forwardPE,
    this.fullExchangeName,
    this.gmtOffSetMilliseconds,
    this.language,
    this.longName,
    this.market,
    this.marketCap,
    this.marketState,
    this.messageBoardId,
    this.priceHint,
    this.priceToBook,
    this.quoteSourceName,
    this.quoteType,
    this.region,
    this.regularMarketChange,
    this.regularMarketChangePercent,
    this.regularMarketDayHigh,
    this.regularMarketDayLow,
    this.regularMarketDayRange,
    this.regularMarketOpen,
    this.regularMarketPreviousClose,
    this.regularMarketPrice,
    this.regularMarketTime,
    this.regularMarketVolume,
    this.sharesOutstanding,
    this.shortName,
    this.sourceInterval,
    this.symbol,
    this.tradeable,
    this.trailingAnnualDividendRate,
    this.trailingAnnualDividendYield,
    this.trailingPE,
    this.triggerable,
    this.twoHundredDayAverage,
    this.twoHundredDayAverageChange,
    this.twoHundredDayAverageChangePercent,
  });

  factory Security.fromJson(Map<String, dynamic> jsonRes) => jsonRes == null
      ? null
      : Security(
          ask: asT<double>(jsonRes['ask']),
          askSize: asT<int>(jsonRes['askSize']),
          averageDailyVolume10Day: asT<int>(jsonRes['averageDailyVolume10Day']),
          averageDailyVolume3Month:
              asT<int>(jsonRes['averageDailyVolume3Month']),
          bid: asT<double>(jsonRes['bid']),
          bidSize: asT<int>(jsonRes['bidSize']),
          bookValue: asT<double>(jsonRes['bookValue']),
          currency: asT<String>(jsonRes['currency']),
          earningsTimestamp: asT<int>(jsonRes['earningsTimestamp']),
          earningsTimestampEnd: asT<int>(jsonRes['earningsTimestampEnd']),
          earningsTimestampStart: asT<int>(jsonRes['earningsTimestampStart']),
          epsForward: asT<double>(jsonRes['epsForward']),
          epsTrailingTwelveMonths:
              asT<double>(jsonRes['epsTrailingTwelveMonths']),
          esgPopulated: asT<bool>(jsonRes['esgPopulated']),
          exchange: asT<String>(jsonRes['exchange']),
          exchangeDataDelayedBy: asT<int>(jsonRes['exchangeDataDelayedBy']),
          exchangeTimezoneName: asT<String>(jsonRes['exchangeTimezoneName']),
          exchangeTimezoneShortName:
              asT<String>(jsonRes['exchangeTimezoneShortName']),
          fiftyDayAverage: asT<double>(jsonRes['fiftyDayAverage']),
          fiftyDayAverageChange: asT<double>(jsonRes['fiftyDayAverageChange']),
          fiftyDayAverageChangePercent:
              asT<double>(jsonRes['fiftyDayAverageChangePercent']),
          fiftyTwoWeekHigh: asT<double>(jsonRes['fiftyTwoWeekHigh']),
          fiftyTwoWeekHighChange:
              asT<double>(jsonRes['fiftyTwoWeekHighChange']),
          fiftyTwoWeekHighChangePercent:
              asT<double>(jsonRes['fiftyTwoWeekHighChangePercent']),
          fiftyTwoWeekLow: asT<double>(jsonRes['fiftyTwoWeekLow']),
          fiftyTwoWeekLowChange: asT<double>(jsonRes['fiftyTwoWeekLowChange']),
          fiftyTwoWeekLowChangePercent:
              asT<double>(jsonRes['fiftyTwoWeekLowChangePercent']),
          fiftyTwoWeekRange: asT<String>(jsonRes['fiftyTwoWeekRange']),
          financialCurrency: asT<String>(jsonRes['financialCurrency']),
          firstTradeDateMilliseconds:
              asT<int>(jsonRes['firstTradeDateMilliseconds']),
          forwardPE: asT<double>(jsonRes['forwardPE']),
          fullExchangeName: asT<String>(jsonRes['fullExchangeName']),
          gmtOffSetMilliseconds: asT<int>(jsonRes['gmtOffSetMilliseconds']),
          language: asT<String>(jsonRes['language']),
          longName: asT<String>(jsonRes['longName']),
          market: asT<String>(jsonRes['market']),
          marketCap: asT<int>(jsonRes['marketCap']),
          marketState: asT<String>(jsonRes['marketState']),
          messageBoardId: asT<String>(jsonRes['messageBoardId']),
          priceHint: asT<int>(jsonRes['priceHint']),
          priceToBook: asT<double>(jsonRes['priceToBook']),
          quoteSourceName: asT<String>(jsonRes['quoteSourceName']),
          quoteType: asT<String>(jsonRes['quoteType']),
          region: asT<String>(jsonRes['region']),
          regularMarketChange: asT<double>(jsonRes['regularMarketChange']),
          regularMarketChangePercent:
              asT<double>(jsonRes['regularMarketChangePercent']),
          regularMarketDayHigh: asT<double>(jsonRes['regularMarketDayHigh']),
          regularMarketDayLow: asT<double>(jsonRes['regularMarketDayLow']),
          regularMarketDayRange: asT<String>(jsonRes['regularMarketDayRange']),
          regularMarketOpen: asT<double>(jsonRes['regularMarketOpen']),
          regularMarketPreviousClose:
              asT<double>(jsonRes['regularMarketPreviousClose']),
          regularMarketPrice: asT<double>(jsonRes['regularMarketPrice']),
          regularMarketTime: asT<int>(jsonRes['regularMarketTime']),
          regularMarketVolume: asT<int>(jsonRes['regularMarketVolume']),
          sharesOutstanding: asT<int>(jsonRes['sharesOutstanding']),
          shortName: asT<String>(jsonRes['shortName']),
          sourceInterval: asT<int>(jsonRes['sourceInterval']),
          symbol: asT<String>(jsonRes['symbol']),
          tradeable: asT<bool>(jsonRes['tradeable']),
          trailingAnnualDividendRate:
              asT<double>(jsonRes['trailingAnnualDividendRate']),
          trailingAnnualDividendYield:
              asT<double>(jsonRes['trailingAnnualDividendYield']),
          trailingPE: asT<double>(jsonRes['trailingPE']),
          triggerable: asT<bool>(jsonRes['triggerable']),
          twoHundredDayAverage: asT<double>(jsonRes['twoHundredDayAverage']),
          twoHundredDayAverageChange:
              asT<double>(jsonRes['twoHundredDayAverageChange']),
          twoHundredDayAverageChangePercent:
              asT<double>(jsonRes['twoHundredDayAverageChangePercent']),
        );

  double ask;
  int askSize;
  int averageDailyVolume10Day;
  int averageDailyVolume3Month;
  double bid;
  int bidSize;
  double bookValue;
  String currency;
  int earningsTimestamp;
  int earningsTimestampEnd;
  int earningsTimestampStart;
  double epsForward;
  double epsTrailingTwelveMonths;
  bool esgPopulated;
  String exchange;
  int exchangeDataDelayedBy;
  String exchangeTimezoneName;
  String exchangeTimezoneShortName;
  double fiftyDayAverage;
  double fiftyDayAverageChange;
  double fiftyDayAverageChangePercent;
  double fiftyTwoWeekHigh;
  double fiftyTwoWeekHighChange;
  double fiftyTwoWeekHighChangePercent;
  double fiftyTwoWeekLow;
  double fiftyTwoWeekLowChange;
  double fiftyTwoWeekLowChangePercent;
  String fiftyTwoWeekRange;
  String financialCurrency;
  int firstTradeDateMilliseconds;
  double forwardPE;
  String fullExchangeName;
  int gmtOffSetMilliseconds;
  String language;
  String longName;
  String market;
  int marketCap;
  String marketState;
  String messageBoardId;
  int priceHint;
  double priceToBook;
  String quoteSourceName;
  String quoteType;
  String region;
  double regularMarketChange;
  double regularMarketChangePercent;
  double regularMarketDayHigh;
  double regularMarketDayLow;
  String regularMarketDayRange;
  double regularMarketOpen;
  double regularMarketPreviousClose;
  double regularMarketPrice;
  int regularMarketTime;
  int regularMarketVolume;
  int sharesOutstanding;
  String shortName;
  int sourceInterval;
  String symbol;
  bool tradeable;
  double trailingAnnualDividendRate;
  double trailingAnnualDividendYield;
  double trailingPE;
  bool triggerable;
  double twoHundredDayAverage;
  double twoHundredDayAverageChange;
  double twoHundredDayAverageChangePercent;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'ask': ask,
        'askSize': askSize,
        'averageDailyVolume10Day': averageDailyVolume10Day,
        'averageDailyVolume3Month': averageDailyVolume3Month,
        'bid': bid,
        'bidSize': bidSize,
        'bookValue': bookValue,
        'currency': currency,
        'earningsTimestamp': earningsTimestamp,
        'earningsTimestampEnd': earningsTimestampEnd,
        'earningsTimestampStart': earningsTimestampStart,
        'epsForward': epsForward,
        'epsTrailingTwelveMonths': epsTrailingTwelveMonths,
        'esgPopulated': esgPopulated,
        'exchange': exchange,
        'exchangeDataDelayedBy': exchangeDataDelayedBy,
        'exchangeTimezoneName': exchangeTimezoneName,
        'exchangeTimezoneShortName': exchangeTimezoneShortName,
        'fiftyDayAverage': fiftyDayAverage,
        'fiftyDayAverageChange': fiftyDayAverageChange,
        'fiftyDayAverageChangePercent': fiftyDayAverageChangePercent,
        'fiftyTwoWeekHigh': fiftyTwoWeekHigh,
        'fiftyTwoWeekHighChange': fiftyTwoWeekHighChange,
        'fiftyTwoWeekHighChangePercent': fiftyTwoWeekHighChangePercent,
        'fiftyTwoWeekLow': fiftyTwoWeekLow,
        'fiftyTwoWeekLowChange': fiftyTwoWeekLowChange,
        'fiftyTwoWeekLowChangePercent': fiftyTwoWeekLowChangePercent,
        'fiftyTwoWeekRange': fiftyTwoWeekRange,
        'financialCurrency': financialCurrency,
        'firstTradeDateMilliseconds': firstTradeDateMilliseconds,
        'forwardPE': forwardPE,
        'fullExchangeName': fullExchangeName,
        'gmtOffSetMilliseconds': gmtOffSetMilliseconds,
        'language': language,
        'longName': longName,
        'market': market,
        'marketCap': marketCap,
        'marketState': marketState,
        'messageBoardId': messageBoardId,
        'priceHint': priceHint,
        'priceToBook': priceToBook,
        'quoteSourceName': quoteSourceName,
        'quoteType': quoteType,
        'region': region,
        'regularMarketChange': regularMarketChange,
        'regularMarketChangePercent': regularMarketChangePercent,
        'regularMarketDayHigh': regularMarketDayHigh,
        'regularMarketDayLow': regularMarketDayLow,
        'regularMarketDayRange': regularMarketDayRange,
        'regularMarketOpen': regularMarketOpen,
        'regularMarketPreviousClose': regularMarketPreviousClose,
        'regularMarketPrice': regularMarketPrice,
        'regularMarketTime': regularMarketTime,
        'regularMarketVolume': regularMarketVolume,
        'sharesOutstanding': sharesOutstanding,
        'shortName': shortName,
        'sourceInterval': sourceInterval,
        'symbol': symbol,
        'tradeable': tradeable,
        'trailingAnnualDividendRate': trailingAnnualDividendRate,
        'trailingAnnualDividendYield': trailingAnnualDividendYield,
        'trailingPE': trailingPE,
        'triggerable': triggerable,
        'twoHundredDayAverage': twoHundredDayAverage,
        'twoHundredDayAverageChange': twoHundredDayAverageChange,
        'twoHundredDayAverageChangePercent': twoHundredDayAverageChangePercent,
      };
  @override
  String toString() {
    return jsonEncode(this);
  }

  @override
  List<Object> get columns => <Object>[
        symbol,
        shortName,
        regularMarketPrice.toStringAsFixed(2),
        regularMarketPreviousClose.toStringAsFixed(2),
        regularMarketChange.toStringAsFixed(2),
        regularMarketChangePercent.toStringAsFixed(2) + '%',
        regularMarketDayLow.toStringAsFixed(2),
        regularMarketDayHigh.toStringAsFixed(2),
        regularMarketVolume,
        averageDailyVolume3Month,
      ];

  Color get changeColor => regularMarketChangePercent == 0
      ? null
      : (regularMarketChangePercent > 0 ? Colors.green : Colors.red);
}
