import 'dart:math';

import 'package:extended_sliver/extended_sliver.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'controller/scroll_controller.dart';
import 'controller/scroll_physics.dart';
import 'horizontal_sync_scroll_minxin.dart';
import 'style/style.dart';
import 'typedef.dart';

class FlexGrid<T> extends StatefulWidget {
  const FlexGrid({
    @required this.headerBuilder,
    @required this.cellBuilder,
    @required this.source,
    @required this.columnsCount,
    this.frozenedColumnsCount = 0,
    this.frozenedRowsCount = 0,
    this.rebuildCustomScrollView = false,
    this.horizontalController,
    this.controller,
    this.physics,
    this.rowBuilder,
    this.horizontalSyncController,
    this.highPerformance = false,
    this.headerStyle,
    this.cellStyle,
    Key key,
  })  : assert(columnsCount != 0),
        assert(frozenedColumnsCount != null && frozenedColumnsCount >= 0),
        assert(frozenedRowsCount != null && frozenedRowsCount >= 0),
        assert(columnsCount - frozenedColumnsCount >= 0),
        assert(!(frozenedColumnsCount > 0 && rowBuilder != null)),
        super(key: key);

  /// The count of forzened columns
  final int frozenedColumnsCount;

  /// The count of forzened rows
  final int frozenedRowsCount;

  final int columnsCount;

  final CellBuilder<T> cellBuilder;
  final RowBuilder<T> rowBuilder;
  final HeaderBuilder headerBuilder;
  final LoadingMoreBase<T> source;

  /// in the case : loadingmore sliverlist in NestedScrollView, you should rebuild CustomScrollView,
  /// so that viewport can be computed again.
  final bool rebuildCustomScrollView;

  final SyncScrollController horizontalController;
  final ScrollController controller;
  final SyncControllerMixin horizontalSyncController;

  final ScrollPhysics physics;
  final bool highPerformance;

  final CellStyle headerStyle;
  final CellStyle cellStyle;
  @override
  _FlexGridState<T> createState() => _FlexGridState<T>();
}

class _FlexGridState<T> extends State<FlexGrid<T>>
    with HorizontalSyncScrollMinxin {
  SyncScrollController _horizontalController;
  SyncControllerMixin _horizontalSyncController;
  ScrollBehavior _configuration;
  ScrollPhysics _physics;
  CellStyle _headerStyle;
  CellStyle _cellStyle;
  @override
  SyncScrollController get horizontalController => _horizontalController;

  @override
  SyncControllerMixin get horizontalSyncController => _horizontalSyncController;

  @override
  ScrollPhysics get physics => _physics;

  @override
  void initState() {
    super.initState();
    _horizontalController =
        widget.horizontalController ?? SyncScrollController();
    _horizontalSyncController = widget.horizontalSyncController;
    _headerStyle = widget.headerStyle ?? CellStyle.header();
    _cellStyle = widget.cellStyle ?? CellStyle.cell();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updatePosition();
    initGestureRecognizers();
  }

  @override
  void didUpdateWidget(covariant FlexGrid<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.horizontalController != null &&
        widget.horizontalController != oldWidget.horizontalController) {
      _horizontalController = widget.horizontalController;
    }
    _headerStyle = widget.headerStyle ?? CellStyle.header();
    _cellStyle = widget.cellStyle ?? CellStyle.cell();
    _updatePosition();
    _horizontalSyncController = widget.horizontalController;
    initGestureRecognizers();
  }

  // Only call this from places that will definitely trigger a rebuild.
  void _updatePosition() {
    _configuration = ScrollConfiguration.of(context);
    _physics = _configuration.getScrollPhysics(context);
    if (widget.physics != null) {
      _physics = widget.physics.applyTo(_physics);
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildGestureDetector(
      child: LayoutBuilder(
        builder: (BuildContext b, BoxConstraints boxConstraints) {
          return LoadingMoreCustomScrollView(
            scrollDirection: Axis.vertical,
            rebuildCustomScrollView: true,
            physics: widget.physics,
            controller: widget.controller,
            slivers: <Widget>[
              // headers
              SliverPinnedToBoxAdapter(
                child: SizedBox(
                  width: boxConstraints.maxWidth,
                  height: _headerStyle.height,
                  child: CustomScrollView(
                    controller: _horizontalController,
                    physics: const NeverScrollableClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    slivers: <Widget>[
                      if (widget.frozenedColumnsCount > 0)
                        SliverPinnedToBoxAdapter(
                          child: Row(
                            children: List<Widget>.generate(
                              widget.frozenedColumnsCount,
                              (int column) => _headerStyle.apply(
                                widget.headerBuilder(context, column),
                                0,
                                column,
                                type: CellStyleType.header,
                              ),
                            ),
                          ),
                        ),
                      buildRow(
                        SliverChildBuilderDelegate(
                          (BuildContext context, int column) {
                            return _headerStyle.apply(
                              widget.headerBuilder(
                                context,
                                column + widget.frozenedColumnsCount,
                              ),
                              0,
                              column + widget.frozenedColumnsCount,
                              type: CellStyleType.header,
                            );
                          },
                          childCount:
                              widget.columnsCount - widget.frozenedColumnsCount,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // frozened rows
              if (widget.frozenedRowsCount > 0)
                SliverPinnedToBoxAdapter(
                  child: StreamBuilder<LoadingMoreBase<T>>(
                    stream: widget.source.rebuild,
                    initialData: widget.source,
                    builder: (BuildContext b,
                        AsyncSnapshot<LoadingMoreBase<T>> asyncSnapshot) {
                      if (widget.source.isEmpty) {
                        return Container();
                      }
                      return Column(
                        children: List<Widget>.generate(
                          min(widget.frozenedRowsCount, widget.source.length),
                          (int row) {
                            return SizedBox(
                              width: boxConstraints.maxWidth,
                              height: _cellStyle.height,
                              child: CustomScrollView(
                                controller: _horizontalController,
                                physics:
                                    const NeverScrollableClampingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                slivers: <Widget>[
                                  if (widget.frozenedColumnsCount > 0)
                                    SliverPinnedToBoxAdapter(
                                      child: Row(
                                        children: List<Widget>.generate(
                                          widget.frozenedColumnsCount,
                                          (int column) => _cellStyle.apply(
                                            widget.cellBuilder(
                                              context,
                                              widget.source[row],
                                              row,
                                              column,
                                            ),
                                            row,
                                            column,
                                          ),
                                        ),
                                      ),
                                    ),
                                  buildRow(
                                    SliverChildBuilderDelegate(
                                      (BuildContext context, int column) {
                                        return _cellStyle.apply(
                                          widget.cellBuilder(
                                            context,
                                            widget.source[row],
                                            row,
                                            column +
                                                widget.frozenedColumnsCount,
                                          ),
                                          row,
                                          column + widget.frozenedColumnsCount,
                                        );
                                      },
                                      childCount: widget.columnsCount -
                                          widget.frozenedColumnsCount,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),

              // cell
              LoadingMoreSliverList<T>(
                SliverListConfig<T>(
                  sourceList: widget.source,
                  itemExtent: widget.highPerformance ? _cellStyle.height : null,
                  itemBuilder: (BuildContext context, T data, int row) {
                    return SizedBox(
                      width: boxConstraints.maxWidth,
                      height: _cellStyle.height,
                      child: CustomScrollView(
                        controller: _horizontalController,
                        physics: const NeverScrollableClampingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        slivers: <Widget>[
                          if (widget.frozenedColumnsCount > 0)
                            SliverPinnedToBoxAdapter(
                              child: Row(
                                children: List<Widget>.generate(
                                  widget.frozenedColumnsCount,
                                  (int column) => _cellStyle.apply(
                                    widget.cellBuilder(
                                      context,
                                      widget.source[
                                          row + widget.frozenedRowsCount],
                                      row + widget.frozenedRowsCount,
                                      column,
                                    ),
                                    row + widget.frozenedRowsCount,
                                    column,
                                  ),
                                ),
                              ),
                            ),
                          buildRow(SliverChildBuilderDelegate(
                            (BuildContext context, int column) {
                              return _cellStyle.apply(
                                widget.cellBuilder(
                                  context,
                                  widget.source[row + widget.frozenedRowsCount],
                                  row + widget.frozenedRowsCount,
                                  column + widget.frozenedColumnsCount,
                                ),
                                row + widget.frozenedRowsCount,
                                column + widget.frozenedColumnsCount,
                              );
                            },
                            childCount: widget.columnsCount -
                                widget.frozenedColumnsCount,
                          )),
                        ],
                      ),
                    );
                  },
                  childCountBuilder: (int index) =>
                      widget.source.length - widget.frozenedRowsCount,
                  //childCount: widget.list.length - widget.frozenedRowsCount,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildRow(SliverChildBuilderDelegate delegate) {
    return widget.highPerformance
        ? SliverFixedExtentList(
            delegate: delegate, itemExtent: _cellStyle.width)
        : SliverList(delegate: delegate);
  }
}
