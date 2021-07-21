import 'iTick.dart';

class DividendTick extends ITick {
  DividendTick({this.dividend, DateTime dateTime}) : super(dateTime: dateTime);
  factory DividendTick.fromList(List<String> row) => DividendTick(
        dateTime: DateTime.parse(row[0]),
        dividend: double.parse(row[1]),
      );
  final double dividend;
}
