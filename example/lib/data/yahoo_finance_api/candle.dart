import 'iTick.dart';

class Candle extends ITick {
  Candle({
    this.open,
    this.high,
    this.low,
    this.close,
    this.volume,
    this.adjustedClose,
    DateTime dateTime,
  }) : super(
          dateTime: dateTime,
        );
  factory Candle.fromList(List<String> row) => Candle(
        dateTime: DateTime.parse(row[0]),
        open: double.parse(row[1]),
        high: double.parse(row[2]),
        low: double.parse(row[3]),
        close: double.parse(row[4]),
        adjustedClose: double.parse(row[5]),
        volume: int.parse(row[6]),
      );
  double open;

  double high;

  double low;

  double close;

  int volume;

  double adjustedClose;
}
