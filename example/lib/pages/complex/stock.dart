import 'dart:async';
import 'dart:ui';

import 'package:example/data/stock_repository.dart';
import 'package:example/widget/pull_to_refresh_header.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
@FFArgumentImport()
import 'package:flex_grid/flex_grid.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

const double leftRightMargin = 15;

@FFRoute(
  name: 'fluttercandies://StockList',
  routeName: 'StockList',
  description: 'StockList',
  exts: <String, dynamic>{
    'group': 'Complex',
    'order': 1,
  },
)
class StockList extends StatefulWidget {
  const StockList({
    Key key,
  }) : super(key: key);
  @override
  _StockListState createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  StockRepository source = StockRepository();

  StockCellStyle cellStyle = StockCellStyle();
  final StreamController<bool> _showShaderontroller =
      StreamController<bool>.broadcast();
  SyncScrollController horizontalController = SyncScrollController();
  bool _showShader = true;
  @override
  void initState() {
    super.initState();
    horizontalController.addListener(() {
      final bool show = horizontalController.extentAfter != 0;
      if (_showShader != show) {
        _showShader = show;
        _showShaderontroller.add(_showShader);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Colors.grey.withOpacity(0.5);
    final double windowWidth = MediaQueryData.fromWindow(window).size.width;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
        ),
      ),
      margin: const EdgeInsets.all(15),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
              child: PullToRefreshNotification(
            maxDragOffset: maxDragOffset,
            onRefresh: () {
              return source.refresh(true);
            },
            child: FlexGrid<StockInfo>(
              horizontalController: horizontalController,
              frozenedColumnsCount: source.frozenedColumnsCount,
              columnsCount: StockRepository.cloumnNames.length,
              cellStyle: cellStyle,
              headerStyle: cellStyle,
              headersBuilder: (BuildContext b, Widget header) {
                return <Widget>[
                  header,
                  SliverToBoxAdapter(
                    child: PullToRefreshContainer(
                        (PullToRefreshScrollNotificationInfo info) {
                      return PullToRefreshHeader(
                        info,
                        source.lastRefreshTime,
                      );
                    }),
                  ),
                ];
              },
              physics: const AlwaysScrollableClampingScrollPhysics(),
              cellBuilder:
                  (BuildContext context, StockInfo data, int row, int column) {
                Widget rowWidget;
                if (column == 0) {
                  rowWidget = Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(data.name),
                      Text(
                        data.code,
                        style: TextStyle(
                          color: Colors.grey.withOpacity(0.8),
                        ),
                      ),
                    ],
                  );
                } else {
                  rowWidget = Selector<StockInfo, Color>(
                    selector: (BuildContext b, StockInfo vm) =>
                        vm.backgroundColor,
                    builder:
                        (BuildContext b, Color backgroundColor, Widget child) {
                      final Widget cell = Container(
                        child: Text(
                          data.columns[column].toString(),
                          style: TextStyle(color: data.getTextColor(column)),
                        ),
                      );

                      return AnimatedContainer(
                        width: cellStyle.width,
                        height: cellStyle.height,
                        child: cell,
                        color: backgroundColor,
                        alignment: cellStyle.alignment,
                        duration: const Duration(milliseconds: 200),
                      );
                    },
                  );
                }

                rowWidget = GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    data.showMenu = !data.showMenu;
                  },
                  child: rowWidget,
                );

                return rowWidget;
              },
              headerBuilder: (BuildContext context, int index) {
                return Text(StockRepository.cloumnNames[index]);
              },
              source: source,
              extendedListDelegate: ExtendedListDelegate(
                viewportBuilder: (int firstIndex, int lastIndex) {
                  source.updateViewport(firstIndex, lastIndex);
                },
              ),
              rowWrapper: (
                BuildContext context,
                StockInfo data,
                int row,
                Widget child,
              ) {
                return ChangeNotifierProvider<StockInfo>.value(
                    value: data,
                    child: Column(
                      children: <Widget>[
                        child,
                        Selector<StockInfo, bool>(
                          selector: (BuildContext b, StockInfo vm) =>
                              vm.showMenu,
                          builder:
                              (BuildContext b, bool showMenu, Widget child) {
                            return AnimatedContainer(
                              width: windowWidth,
                              height: showMenu ? cellStyle.height : 0,
                              child: Container(
                                color: Colors.grey.withOpacity(0.5),
                                child: Row(
                                  children: <Widget>[
                                    getButton('timelapse', Icons.timelapse),
                                    getButton('airplay', Icons.airplay),
                                    getButton('bedtime', Icons.bedtime),
                                  ],
                                ),
                              ),
                              color: data.backgroundColor,
                              alignment: cellStyle.alignment,
                              duration: const Duration(milliseconds: 200),
                            );
                          },
                        ),
                      ],
                    ));
              },
            ),
          )),
          Positioned(
            top: 0,
            right: 0,
            child: StreamBuilder<bool>(
              stream: _showShaderontroller.stream,
              initialData: true,
              builder: (BuildContext c, AsyncSnapshot<bool> snapshot) {
                if (!snapshot.data) {
                  return Container();
                }
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Colors.white.withOpacity(0.4),
                        Colors.white
                      ],
                      stops: const <double>[0.0, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  width: 60,
                  height: 60,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget getButton(String label, IconData icon) {
    return Expanded(
      child: TextButton.icon(
        onPressed: () {
          showToast(label);
        },
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}

class StockCellStyle extends CellStyle {
  @override
  Widget apply(Widget child, int row, int column,
      {CellStyleType type = CellStyleType.cell}) {
    return Container(
      child: child,
      width: width,
      height: height,
      alignment: alignment,
      color: Colors.white,
    );
  }
}
