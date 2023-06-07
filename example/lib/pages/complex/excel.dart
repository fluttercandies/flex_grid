import 'dart:math';

import 'package:example/data/excel_source.dart';
import 'package:excel/excel.dart' as excel;
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flex_grid/flex_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

const double leftRightMargin = 15;

@FFRoute(
  name: 'fluttercandies://Excel',
  routeName: 'Excel',
  description: 'Excel',
  exts: <String, dynamic>{
    'group': 'Complex',
    'order': 0,
  },
)
class ExcelDemo extends StatefulWidget {
  const ExcelDemo({Key? key}) : super(key: key);

  @override
  _ExcelDemoState createState() => _ExcelDemoState();
}

class _ExcelDemoState extends State<ExcelDemo> {
  ExcelSource excelSource = ExcelSource();
  @override
  void initState() {
    super.initState();
    excelSource.init().whenComplete(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (excelSource.sheet == null) {
      return const IndicatorWidget(IndicatorStatus.fullScreenBusying);
    }
    final Color borderColor = Colors.grey.withOpacity(0.5);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
        ),
      ),
      margin: const EdgeInsets.all(15),
      child: FlexGrid<List<excel.Data?>>(
        frozenedColumnsCount: 1,
        columnsCount: excelSource.maxCols!,
        headerStyle: ExcelCellStyle(),
        cellStyle: ExcelCellStyle(),
        physics: const AlwaysScrollableClampingScrollPhysics(),
        horizontalHighPerformance: true,
        verticalHighPerformance: true,
        cellBuilder: (BuildContext context, List<excel.Data?> data, int row,
            int column) {
          String showText = data[column]!.value.toString();
          Color backgroundColor = column == 0
              ? Colors.yellow
              : (row % 2 == 0 ? Colors.grey.withOpacity(0.1) : Colors.white);

          Color textColor = Colors.black;
          Widget? widget;
          if (column == 1) {
            showText =
                DateFormat('yyyy/MM/dd').format(DateTime.parse(showText));
          } else if (column == 4) {
            double x = -2;
            double y = 0;

            final List<FlSpot> lineBarsData =
                showText.split(',').map((String e) {
              x += 2;

              y = max(y, double.tryParse(e)!);
              return FlSpot(x, double.tryParse(e)!);
            }).toList();

            widget = Padding(
              padding: const EdgeInsets.all(2.0),
              child: LineChart(
                LineChartData(
                  lineBarsData: <LineChartBarData>[
                    LineChartBarData(
                      spots: lineBarsData,
                    )
                  ],
                  titlesData: FlTitlesData(
                    show: false,
                  ),
                  lineTouchData: LineTouchData(
                    enabled: false,
                  ),
                  minX: 0,
                  maxX: x,
                  minY: 0,
                  maxY: y,
                ),
              ),
            );
          } else if (column == 5) {
            switch (showText) {
              case 'Red':
                backgroundColor = Colors.red;
                break;
              case 'Green':
                backgroundColor = Colors.green;
                break;
              case 'Black':
                backgroundColor = Colors.black;
                break;
              case 'White':
                backgroundColor = Colors.white;
                break;
              default:
            }
            textColor = backgroundColor.computeLuminance() < 0.5
                ? Colors.white
                : Colors.black;
          } else if (column == 6) {
            textColor = double.parse(showText) > 0 ? Colors.red : Colors.green;
          } else if (column == 7) {
            widget = RatingBar.builder(
              initialRating: double.parse(showText),
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
              itemBuilder: (BuildContext context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              itemSize: 12,
              onRatingUpdate: (double rating) {
                print(rating);
              },
            );
          } else if (column == 8) {
            widget = Checkbox(
              value: showText == 'true',
              onChanged: null,
            );
          } else if (column == 10) {
            showText = (double.parse(showText) * 100).toInt().toString() + '%';
          } else if (column == 11) {
            // minute 1/(24*60) = 1/1440 = 0.000694
            // hour 1/24 = 0.04167
            final double dateTime = double.parse(showText);
            final double time = dateTime - dateTime.toInt();

            final int minutes = ((time / 0.000694) % 60).toInt();
            final int hours = (time / 0.000694) ~/ 60;
            showText =
                '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
          }

          widget ??= Text(
            showText,
            style: TextStyle(color: textColor),
          );

          return Container(
            child: widget,
            width: 100,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border(
                bottom: BorderSide(
                  color: borderColor,
                ),
                right: column == excelSource.maxCols! - 1
                    ? BorderSide.none
                    : BorderSide(
                        color: borderColor,
                      ),
              ),
            ),
          );
        },
        headerBuilder: (BuildContext context, int index) {
          Widget header = Text(excelSource.headers![index]!.value.toString());

          if (index == 3) {
            header = StatefulBuilder(
              builder: (BuildContext b, StateSetter stateSetter) {
                IconData? icon;
                switch (excelSource.sortType) {
                  case SortType.none:
                    icon = Icons.sort;
                    break;
                  case SortType.ascending:
                    icon = Icons.arrow_drop_up;
                    break;
                  case SortType.descending:
                    icon = Icons.arrow_drop_down;
                    break;
                  default:
                }
                return SizedBox(
                  child: GestureDetector(
                    onTap: () {
                      stateSetter(() {
                        excelSource.sortHeader(index);
                      });
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(excelSource.headers![index]!.value.toString()),
                        const SizedBox(
                          width: 5,
                        ),
                        Icon(
                          icon,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          header = Container(
            width: 100,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.lightGreen,
              border: Border(
                bottom: BorderSide(
                  color: borderColor,
                ),
                right: index == excelSource.maxCols! - 1
                    ? BorderSide.none
                    : BorderSide(
                        color: borderColor,
                      ),
              ),
            ),
            child: header,
          );
          return header;
        },
        source: excelSource,
      ),
    );
  }
}

class ExcelCellStyle extends CellStyle {
  @override
  Widget apply(Widget child, int row, int column,
      {CellStyleType type = CellStyleType.cell}) {
    return child;
  }
}
