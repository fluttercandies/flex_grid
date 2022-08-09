import 'dart:math';

import 'package:extended_sliver/extended_sliver.dart';
import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';

import 'style/style.dart';
import 'typedef.dart';

class FlexGrid<T> extends StatefulWidget {
  const FlexGrid({
    required this.headerBuilder,
    required this.cellBuilder,
    required this.source,
    required this.columnsCount,
    this.frozenedColumnsCount = 0,
    this.frozenedRowsCount = 0,
    this.horizontalController,
    this.controller,
    this.physics,
    this.rowWrapper,
    this.highPerformance = false,
    this.headerStyle,
    this.cellStyle,
    //this.prototypeCell,
    this.indicatorBuilder,
    this.extendedListDelegate,
    this.headersBuilder,
    Key? key,
    this.link = false,
  })  : assert(columnsCount != 0),
        // ignore: unnecessary_null_comparison
        assert(frozenedColumnsCount != null && frozenedColumnsCount >= 0),
        // ignore: unnecessary_null_comparison
        assert(frozenedRowsCount != null && frozenedRowsCount >= 0),
        assert(columnsCount - frozenedColumnsCount >= 0),
        super(key: key);

  /// The count of forzened columns
  final int frozenedColumnsCount;

  /// The count of forzened rows
  final int frozenedRowsCount;

  /// The count of columns, it should big than 0.
  final int columnsCount;

  /// The builder to create cell
  final CellBuilder<T> cellBuilder;

  /// The builder to create header
  final HeaderBuilder headerBuilder;

  /// The data source of [FlexGrid]
  final LoadingMoreBase<T> source;

  /// Decorate row widget in this call back.
  final RowWrapper<T>? rowWrapper;

  /// The [ScrollController] on vertical direction
  final ScrollController? controller;

  /// The controller for horizontal direction
  final SyncControllerMixin? horizontalController;

  /// The physics on both horizontal and vertical direction
  final ScrollPhysics? physics;

  /// If true, forces the children to have the given extent(Cell height/width) in the scroll
  /// direction.
  final bool highPerformance;

  /// Defines the main axis extent of all of this sliver's children.
  ///
  /// The [prototypeCell] is laid out before the rest of the sliver's children
  /// and its size along the main axis fixes the size of each child. The
  /// [prototypeCell] is essentially [Offstage]: it is not painted and it
  /// cannot respond to input.
  //final Widget prototypeCell;

  /// An immutable style describing how to create header
  /// Default is [CellStyle.header()]
  final CellStyle? headerStyle;

  /// An immutable style describing how to create cell
  /// Default is [CellStyle.cell()]
  final CellStyle? cellStyle;

  /// Widget builder for different loading state
  final LoadingMoreIndicatorBuilder? indicatorBuilder;

  /// A delegate that provides extensions within the [FlexGrid].
  final ExtendedListDelegate? extendedListDelegate;

  /// The builder to custom the headers of [FlexGrid]
  final HeadersBuilder? headersBuilder;

  /// if link is true and current over scroll,
  /// it will check and scroll parent [ExtendedTabView].
  /// default is false
  final bool link;
  @override
  _FlexGridState<T> createState() => _FlexGridState<T>();
}

class _FlexGridState<T> extends State<FlexGrid<T>>
    with SyncScrollStateMinxin<FlexGrid<T>> {
  late SyncControllerMixin _horizontalController;
  late CellStyle _headerStyle;
  late CellStyle _cellStyle;
  @override
  SyncControllerMixin get syncController => _horizontalController;

  @override
  ScrollPhysics? get physics => widget.physics;

  @override
  void initState() {
    super.initState();
    _horizontalController =
        widget.horizontalController ?? SyncScrollController();
    _headerStyle = widget.headerStyle ?? CellStyle.header();
    _cellStyle = widget.cellStyle ?? CellStyle.cell();
  }

  @override
  void didChangeDependencies() {
    _updateAncestor();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant FlexGrid<T> oldWidget) {
    if (oldWidget.horizontalController != widget.horizontalController) {
      _horizontalController =
          widget.horizontalController ?? SyncScrollController();
    }

    _updateAncestor();
    updatePhysics();
    initGestureRecognizers();
    super.didUpdateWidget(oldWidget);
  }

  void _updateAncestor() {
    _horizontalController.unlinkParent();
    if (widget.link) {
      ExtendedTabBarView.linkParent(context, _horizontalController);
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildGestureDetector(
      child: LayoutBuilder(
        builder: (BuildContext b, BoxConstraints boxConstraints) {
          // headers
          final Widget header = SliverPinnedToBoxAdapter(
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
          );
          return LoadingMoreCustomScrollView(
            scrollDirection: Axis.vertical,
            physics: widget.physics,
            controller: widget.controller,
            slivers: <Widget>[
              if (widget.headersBuilder != null)
                ...widget.headersBuilder!(context, header)
              else
                header,

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
                            final T t = widget.source[row];
                            Widget rowWidget = SizedBox(
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
                                              t,
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
                                            t,
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
                            if (widget.rowWrapper != null) {
                              rowWidget = widget.rowWrapper!(
                                context,
                                t,
                                row,
                                rowWidget,
                              );
                            }

                            return rowWidget;
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
                    final T t = widget.source[row];
                    Widget rowWidget = SizedBox(
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

                    if (widget.rowWrapper != null) {
                      rowWidget = widget.rowWrapper!(
                        context,
                        t,
                        row,
                        rowWidget,
                      );
                    }

                    return rowWidget;
                  },
                  childCountBuilder: (int index) =>
                      widget.source.length - widget.frozenedRowsCount,
                  //childCount: widget.list.length - widget.frozenedRowsCount,
                  extendedListDelegate: widget.extendedListDelegate,
                  indicatorBuilder: widget.indicatorBuilder,
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

  @override
  Axis get scrollDirection => Axis.horizontal;

  @override
  TextDirection? get textDirection => Directionality.maybeOf(context);
}
