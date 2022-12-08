// ignore_for_file: unnecessary_null_comparison

import 'dart:math';

import 'package:extended_sliver/extended_sliver.dart';
import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';

import 'style/style.dart';
import 'typedef.dart';

class FlexGrid<T> extends StatefulWidget {
  const FlexGrid({
    this.headerBuilder,
    required this.cellBuilder,
    required this.source,
    required this.columnsCount,
    this.frozenedColumnsCount = 0,
    this.frozenedRowsCount = 0,
    this.horizontalController,
    this.controller,
    this.physics,
    this.rowWrapper,
    this.headerStyle,
    this.cellStyle,
    //this.prototypeCell,
    this.indicatorBuilder,
    this.extendedListDelegate,
    this.headersBuilder,
    Key? key,
    this.link = false,
    this.horizontalPhysics,
    this.horizontalHighPerformance = false,
    this.verticalHighPerformance = false,
    this.showGlowLeading = false,
    this.showGlowTrailing = true,
    this.frozenedTrailingColumnsCount = 0,
    this.showHorizontalGlowLeading = false,
    this.showHorizontalGlowTrailing = false,
    this.footerBuilder,
    this.footerStyle,
    this.sliverHeadersBuilder,
  })  : assert(columnsCount != 0),
        assert(frozenedColumnsCount != null && frozenedColumnsCount >= 0),
        assert(frozenedRowsCount != null && frozenedRowsCount >= 0),
        assert(frozenedTrailingColumnsCount != null &&
            frozenedTrailingColumnsCount >= 0),
        assert(columnsCount -
                frozenedColumnsCount -
                frozenedTrailingColumnsCount >=
            0),
        super(key: key);

  /// The count of forzened columns at leading
  final int frozenedColumnsCount;

  /// The count of forzened rows at leading
  final int frozenedRowsCount;

  /// The count of columns, it should big than 0.
  final int columnsCount;

  /// The builder to create cell
  final CellBuilder<T> cellBuilder;

  /// The builder to create header
  final HeaderBuilder? headerBuilder;

  /// The data source of [FlexGrid]
  final LoadingMoreBase<T> source;

  /// Decorate row widget in this call back.
  final RowWrapper<T>? rowWrapper;

  /// The [ScrollController] on vertical direction
  final ScrollController? controller;

  /// The controller for horizontal direction
  final LinkScrollController? horizontalController;

  /// The physics vertical direction
  final ScrollPhysics? physics;

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

  /// The physics on both horizontal direction
  final ScrollPhysics? horizontalPhysics;

  /// If true, forces the horizontal children to have the given extent(Cell width) in the scroll
  /// horizontal direction, it will use ListView.builder(extent: cellwidth)
  /// but it's jank when scroll, see issue https://github.com/flutter/flutter/issues/116765
  ///
  /// default: use SingleChildScrollView

  final bool horizontalHighPerformance;

  /// If true, forces the vertical children to have the given extent(Cell height) in the scroll
  /// vertical direction.
  final bool verticalHighPerformance;

  /// Whether to show the overscroll glow on the side with negative scroll
  /// offsets.
  final bool showGlowLeading;

  /// Whether to show the overscroll glow on the side with positive scroll
  /// offsets.
  final bool showGlowTrailing;

  /// The count of forzened columns at trailing
  final int frozenedTrailingColumnsCount;

  /// Whether to show the overscroll glow on the side with negative scroll
  /// offsets in horizontal.
  final bool showHorizontalGlowLeading;

  /// Whether to show the overscroll glow on the side with positive scroll
  /// offsets in horizontal.
  final bool showHorizontalGlowTrailing;

  /// The builder to create footer
  final FooterBuilder? footerBuilder;

  /// An immutable style describing how to create footer
  /// Default is [CellStyle.footer()]
  final CellStyle? footerStyle;

  /// The builder to custom the sliver headers of [FlexGrid]
  final SliverHeadersBuilder? sliverHeadersBuilder;

  @override
  _FlexGridState<T> createState() => _FlexGridState<T>();
}

class _FlexGridState<T> extends LinkScrollState<FlexGrid<T>> {
  late LinkScrollControllerMixin _horizontalController;
  late CellStyle _headerStyle;
  late CellStyle _cellStyle;
  late CellStyle _footerStyle;
  @override
  ScrollPhysics? get physics => widget.horizontalPhysics;

  @override
  void initState() {
    super.initState();
    _horizontalController =
        widget.horizontalController ?? LinkScrollController();
    _headerStyle = widget.headerStyle ?? CellStyle.header();
    _cellStyle = widget.cellStyle ?? CellStyle.cell();
    _footerStyle = widget.footerStyle ?? CellStyle.footer();
  }

  @override
  void didUpdateWidget(covariant FlexGrid<T> oldWidget) {
    if (oldWidget.horizontalController != widget.horizontalController) {
      _horizontalController =
          widget.horizontalController ?? LinkScrollController();
    }
    _headerStyle = widget.headerStyle ?? CellStyle.header();
    _cellStyle = widget.cellStyle ?? CellStyle.cell();
    _footerStyle = widget.footerStyle ?? CellStyle.footer();
    if (widget.physics != oldWidget.physics) {
      updatePhysics();
      initGestureRecognizers();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void linkParent<S extends StatefulWidget, T extends LinkScrollState<S>>() {
    super.linkParent<ExtendedTabBarView, ExtendedTabBarViewState>();
  }

  @override
  Widget build(BuildContext context) {
    return buildGestureDetector(
      child: LayoutBuilder(
        builder: (BuildContext b, BoxConstraints boxConstraints) {
          Widget list = widget.sliverHeadersBuilder != null
              ? LoadingMoreCustomScrollView(
                  slivers: <Widget>[
                    ...widget.sliverHeadersBuilder!(
                      context,
                      widget.headerBuilder != null
                          ? SliverPinnedToBoxAdapter(
                              child: _rowBuilder(
                                -1,
                                context,
                                boxConstraints,
                                _headerStyle,
                                CellStyleType.header,
                              ),
                            )
                          : null,
                    ),
                    if (widget.frozenedRowsCount > 0)
                      SliverPinnedToBoxAdapter(
                          child: _buildFrozenedRows(
                        context,
                        boxConstraints,
                      )),
                    LoadingMoreSliverList<T>(
                      SliverListConfig<T>(
                        sourceList: widget.source,
                        itemExtent: widget.verticalHighPerformance
                            ? _cellStyle.height
                            : null,
                        itemBuilder: (BuildContext context, T data, int row) {
                          return _rowBuilder(
                            row,
                            context,
                            boxConstraints,
                            _cellStyle,
                            CellStyleType.cell,
                          );
                        },
                        childCountBuilder: (int index) =>
                            widget.source.length - widget.frozenedRowsCount,
                        extendedListDelegate: widget.extendedListDelegate,
                        indicatorBuilder: widget.indicatorBuilder,
                        padding: EdgeInsets.zero,
                      ),
                    )
                  ],
                  scrollDirection: Axis.vertical,
                  physics: widget.physics,
                  controller: widget.controller,
                  showGlowLeading: widget.showGlowLeading,
                  showGlowTrailing: widget.showGlowTrailing,
                )
              : LoadingMoreList<T>(ListConfig<T>(
                  sourceList: widget.source,
                  itemExtent:
                      widget.verticalHighPerformance ? _cellStyle.height : null,
                  itemBuilder: (BuildContext context, T data, int row) {
                    return _rowBuilder(
                      row,
                      context,
                      boxConstraints,
                      _cellStyle,
                      CellStyleType.cell,
                    );
                  },
                  itemCountBuilder: (int index) =>
                      widget.source.length - widget.frozenedRowsCount,
                  extendedListDelegate: widget.extendedListDelegate,
                  indicatorBuilder: widget.indicatorBuilder,
                  scrollDirection: Axis.vertical,
                  physics: widget.physics,
                  controller: widget.controller,
                  showGlowLeading: widget.showGlowLeading,
                  showGlowTrailing: widget.showGlowTrailing,
                  padding: EdgeInsets.zero,
                ));

          if (widget.headerBuilder == null &&
              widget.footerBuilder == null &&
              widget.headersBuilder == null &&
              widget.frozenedRowsCount <= 0) {
            return list;
          }

          list = Column(
            children: <Widget>[
              if (widget.sliverHeadersBuilder == null) ...<Widget>[
                if (widget.headersBuilder != null)
                  ...widget.headersBuilder!(
                    context,
                    widget.headerBuilder != null
                        ? _rowBuilder(
                            -1,
                            context,
                            boxConstraints,
                            _headerStyle,
                            CellStyleType.header,
                          )
                        : null,
                  )
                else if (widget.headerBuilder != null)
                  _rowBuilder(
                    -1,
                    context,
                    boxConstraints,
                    _headerStyle,
                    CellStyleType.header,
                  ),

                // frozened rows
                if (widget.frozenedRowsCount > 0)
                  _buildFrozenedRows(context, boxConstraints),
              ],
              Expanded(child: list),
              if (widget.footerBuilder != null)
                _rowBuilder(
                  -2,
                  context,
                  boxConstraints,
                  _footerStyle,
                  CellStyleType.footer,
                ),
            ],
          );

          return list;
        },
      ),
    );
  }

  Widget _buildFrozenedRows(
      BuildContext context, BoxConstraints boxConstraints) {
    return StreamBuilder<LoadingMoreBase<T>>(
      stream: widget.source.rebuild,
      initialData: widget.source,
      builder:
          (BuildContext b, AsyncSnapshot<LoadingMoreBase<T>> asyncSnapshot) {
        if (widget.source.isEmpty) {
          return Container();
        }
        return Column(
          children: List<Widget>.generate(
            min(widget.frozenedRowsCount, widget.source.length),
            (int row) {
              return _rowBuilder(
                row,
                context,
                boxConstraints,
                _cellStyle,
                CellStyleType.cell,
                frozenedRows: true,
              );
            },
          ),
        );
      },
    );
  }

  Widget _rowBuilder(
    int row,
    BuildContext context,
    BoxConstraints boxConstraints,
    CellStyle style,
    CellStyleType type, {
    bool frozenedRows = false,
  }) {
    if (!frozenedRows) {
      row = row + widget.frozenedRowsCount;
    }

    Widget rowWidget = GlowNotificationWidget(
      widget.horizontalHighPerformance
          ? ListView.builder(
              padding: EdgeInsets.zero,
              itemBuilder: (BuildContext context, int column) {
                column = column + widget.frozenedColumnsCount;
                return _buildContent(
                  style,
                  type,
                  context,
                  row,
                  column,
                );
              },
              controller: _horizontalController,
              physics: _defaultHorizontalScrollPhysics
                  .applyTo(widget.horizontalPhysics),
              scrollDirection: Axis.horizontal,
              itemCount: widget.columnsCount -
                  widget.frozenedColumnsCount -
                  widget.frozenedTrailingColumnsCount,
              itemExtent: style.width,
              //scrollBehavior: _defaultHorizontalScrollBehavior,
            )
          : SingleChildScrollView(
              padding: EdgeInsets.zero,
              controller: _horizontalController,
              physics: _defaultHorizontalScrollPhysics
                  .applyTo(widget.horizontalPhysics),
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: List<Widget>.generate(
                      widget.columnsCount -
                          widget.frozenedColumnsCount -
                          widget.frozenedTrailingColumnsCount, (int column) {
                column = column + widget.frozenedColumnsCount;
                return _buildContent(
                  style,
                  type,
                  context,
                  row,
                  column,
                );
              })),
            ),
      showGlowLeading: widget.showHorizontalGlowLeading,
      showGlowTrailing: widget.showHorizontalGlowTrailing,
    );

    if (widget.frozenedColumnsCount > 0 ||
        widget.frozenedTrailingColumnsCount > 0) {
      rowWidget = Row(
        children: <Widget>[
          ...List<Widget>.generate(
            widget.frozenedColumnsCount,
            (int column) {
              return _buildContent(
                style,
                type,
                context,
                row,
                column,
              );
            },
          ),
          Expanded(child: rowWidget),
          ...List<Widget>.generate(widget.frozenedTrailingColumnsCount,
              (int column) {
            return _buildContent(
              style,
              type,
              context,
              row,
              widget.columnsCount -
                  widget.frozenedTrailingColumnsCount +
                  column,
            );
          }),
        ],
      );
    }

    rowWidget = SizedBox(
      width: boxConstraints.maxWidth,
      height: style.getHeight(row: row),
      child: rowWidget,
    );

    if (type == CellStyleType.cell && widget.rowWrapper != null) {
      rowWidget = widget.rowWrapper!(
        context,
        widget.source[row],
        row,
        rowWidget,
      );
    }

    // if (type == CellStyleType.header) {
    //   rowWidget = SliverPinnedToBoxAdapter(
    //     child: rowWidget,
    //   );
    // }
    return rowWidget;
  }

  Widget _buildContent(
    CellStyle style,
    CellStyleType type,
    BuildContext context,
    int row,
    int column,
  ) {
    Widget? content;
    switch (type) {
      case CellStyleType.cell:
        content = widget.cellBuilder(
          context,
          widget.source[row],
          row,
          column,
        );
        break;
      case CellStyleType.header:
        content = widget.headerBuilder?.call(
          context,
          column,
        );
        break;
      case CellStyleType.footer:
        content = widget.footerBuilder?.call(
          context,
          column,
        );
        break;
      default:
    }
    return style.apply(
      content ?? Container(),
      row,
      column,
      type: type,
    );
  }

  @override
  Axis get scrollDirection => Axis.horizontal;

  @override
  ScrollPhysics? getScrollPhysics() {
    final ScrollBehavior configuration = ScrollConfiguration.of(context);
    ScrollPhysics temp = configuration.getScrollPhysics(context);
    if (physics != null) {
      temp = physics!.applyTo(temp);
    }
    return temp.applyTo(_defaultHorizontalScrollPhysics);
  }

  @override
  LinkScrollControllerMixin get linkScrollController => _horizontalController;

  @override
  bool get link => widget.link;
}

NeverScrollableScrollPhysics _defaultHorizontalScrollPhysics =
    const NeverScrollableScrollPhysics();
