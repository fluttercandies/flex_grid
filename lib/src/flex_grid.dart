import 'dart:math';

import 'package:extended_sliver/extended_sliver.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';

import 'controller/drag_hold_controller.dart';
import 'controller/scroll_controller.dart';
import 'controller/scroll_physics.dart';
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
    this.headerHeight = 60,
    this.cellHeight = 60,
    this.rowBuilder,
    Key key,
  })  : assert(columnsCount != 0),
        assert(frozenedColumnsCount != null && frozenedColumnsCount >= 0),
        assert(frozenedRowsCount != null && frozenedRowsCount >= 0),
        assert(columnsCount - frozenedColumnsCount >= 0),
        assert(headerHeight > 0),
        assert(cellHeight > 0),
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
  final ScrollPhysics physics;
  final double headerHeight;
  final double cellHeight;

  @override
  _FlexGridState<T> createState() => _FlexGridState<T>();
}

class _FlexGridState<T> extends State<FlexGrid<T>> {
  SyncScrollController _horizontalController;
  DragHoldController _horizontalPageController;

  ScrollBehavior _configuration;
  ScrollPhysics _physics;
  Map<Type, GestureRecognizerFactory> _gestureRecognizers =
      const <Type, GestureRecognizerFactory>{};
  @override
  void initState() {
    super.initState();
    _horizontalController =
        widget.horizontalController ?? SyncScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updatePosition();
    _initGestureRecognizers();
    _findHorizontalPageController();
  }

  @override
  void didUpdateWidget(covariant FlexGrid<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.horizontalController != null &&
        widget.horizontalController != oldWidget.horizontalController) {
      _horizontalController = widget.horizontalController;
    }
    _updatePosition();
    _initGestureRecognizers();
    _findHorizontalPageController();
  }

  // Only call this from places that will definitely trigger a rebuild.
  void _updatePosition() {
    _configuration = ScrollConfiguration.of(context);
    _physics = _configuration.getScrollPhysics(context);
    if (widget.physics != null) {
      _physics = widget.physics.applyTo(_physics);
    }
  }

  void _initGestureRecognizers() {
    _gestureRecognizers = <Type, GestureRecognizerFactory>{
      HorizontalDragGestureRecognizer:
          GestureRecognizerFactoryWithHandlers<HorizontalDragGestureRecognizer>(
        () => HorizontalDragGestureRecognizer(),
        (HorizontalDragGestureRecognizer instance) {
          instance
            ..onDown = (DragDownDetails details) {
              _handleDragDown(
                details,
              );
            }
            ..onStart = (DragStartDetails details) {
              _handleDragStart(
                details,
              );
            }
            ..onUpdate = (DragUpdateDetails details) {
              _handleDragUpdate(
                details,
              );
            }
            ..onEnd = (DragEndDetails details) {
              _handleDragEnd(
                details,
              );
            }
            ..onCancel = () {
              _handleDragCancel();
            }
            ..minFlingDistance = _physics?.minFlingDistance
            ..minFlingVelocity = _physics?.minFlingVelocity
            ..maxFlingVelocity = _physics?.maxFlingVelocity;
        },
      ),
    };
  }

  void _findHorizontalPageController() {
    _horizontalPageController?.forceCancel();
    _horizontalPageController = null;
    final ScrollableState scrollableState =
        context.findAncestorStateOfType<ScrollableState>();
    if (scrollableState != null &&
        scrollableState.widget.axis == Axis.horizontal &&
        scrollableState.widget.controller is PageController) {
      _horizontalPageController = DragHoldController(scrollableState.position);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: _gestureRecognizers,
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
                  height: widget.cellHeight,
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
                                (int column) =>
                                    widget.headerBuilder(context, column)),
                          ),
                        ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int column) {
                            return widget.headerBuilder(
                              context,
                              column + widget.frozenedColumnsCount,
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
                              height: widget.cellHeight,
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
                                          (int column) => widget.cellBuilder(
                                            context,
                                            widget.source[row],
                                            row,
                                            column,
                                          ),
                                        ),
                                      ),
                                    ),
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int column) {
                                        return widget.cellBuilder(
                                          context,
                                          widget.source[row],
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
                  itemBuilder: (BuildContext context, T data, int row) {
                    return SizedBox(
                      width: boxConstraints.maxWidth,
                      height: widget.cellHeight,
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
                                    (int column) => widget.cellBuilder(
                                          context,
                                          widget.source[
                                              row + widget.frozenedRowsCount],
                                          row + widget.frozenedRowsCount,
                                          column,
                                        )),
                              ),
                            ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int column) {
                                return widget.cellBuilder(
                                  context,
                                  widget.source[row + widget.frozenedRowsCount],
                                  row + widget.frozenedRowsCount,
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

  void _handleDragDown(
    DragDownDetails details,
  ) {
    _horizontalPageController?.forceCancel();
    _horizontalController?.forceCancel();
    _horizontalController?.handleDragDown(details);
  }

  void _handleDragStart(DragStartDetails details) {
    _horizontalController?.handleDragStart(details);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _handleTabView(details);
    if (_horizontalPageController?.hasDrag ?? false) {
      _horizontalPageController.handleDragUpdate(details);
    } else {
      _horizontalController.handleDragUpdate(details);
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_horizontalPageController?.hasDrag ?? false) {
      _horizontalPageController.handleDragEnd(details);
    } else {
      _horizontalController.handleDragEnd(details);
    }
  }

  void _handleDragCancel() {
    _horizontalController?.handleDragCancel();
    _horizontalPageController?.handleDragCancel();
  }

  bool _handleTabView(DragUpdateDetails details) {
    if (_horizontalPageController != null) {
      final double delta = details.delta.dx;

      if ((delta < 0 &&
              _horizontalController.extentAfter == 0 &&
              _horizontalPageController.extentAfter != 0) ||
          (delta > 0 &&
              _horizontalController.extentBefore == 0 &&
              _horizontalPageController.extentBefore != 0)) {
        if (!_horizontalPageController.hasHold &&
            !_horizontalPageController.hasDrag) {
          _horizontalPageController.handleDragDown(null);
          _horizontalPageController.handleDragStart(DragStartDetails(
            globalPosition: details.globalPosition,
            localPosition: details.localPosition,
            sourceTimeStamp: details.sourceTimeStamp,
          ));
        }

        return true;
      }
    }

    return false;
  }
}
