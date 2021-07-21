import 'iTick.dart';

class SplitTick extends ITick {
  SplitTick({
    this.beforeSplit,
    this.afterSplit,
    DateTime dateTime,
  }) : super(dateTime: dateTime);

  factory SplitTick.fromList(List<String> row) => SplitTick(
        dateTime: DateTime.parse(row[0]),
        afterSplit: double.parse(row[1]),
        beforeSplit: double.parse(row[2]),
      );
  final double beforeSplit;

  final double afterSplit;
}
