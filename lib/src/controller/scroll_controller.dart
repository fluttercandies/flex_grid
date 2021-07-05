import 'package:flutter/material.dart';
import 'drag_hold_controller.dart';

/// Sync
class SyncScrollController extends ScrollController with SyncController {
  /// Creates a scroll controller that continually updates its
  /// [initialScrollOffset] to match the last scroll notification it received.
  SyncScrollController({
    double initialScrollOffset = 0.0,
    bool keepScrollOffset = true,
    String debugLabel,
  }) : super(
            initialScrollOffset: initialScrollOffset,
            keepScrollOffset: keepScrollOffset,
            debugLabel: debugLabel);
}

class SyncPageController extends PageController with SyncController {
  /// Creates a page controller.
  ///
  /// The [initialPage], [keepPage], and [viewportFraction] arguments must not be null.
  SyncPageController({
    int initialPage = 0,
    bool keepPage = true,
    double viewportFraction = 1.0,
  }) : super(
          initialPage: initialPage,
          keepPage: keepPage,
          viewportFraction: viewportFraction,
        );
}

/// The mixin for [ScrollController] to sync pixels for all of positions
mixin SyncController on ScrollController {
  final Map<ScrollPosition, DragHoldController> _positionToListener =
      <ScrollPosition, DragHoldController>{};

  @override
  void attach(ScrollPosition position) {
    super.attach(position);
    assert(!_positionToListener.containsKey(position));
    if (_positionToListener.isNotEmpty) {
      final double pixels = _positionToListener.keys.first.pixels;
      if (position.pixels != pixels) {
        position.correctPixels(pixels);
      }
    }
    _positionToListener[position] = DragHoldController(position);
  }

  @override
  void detach(ScrollPosition position) {
    super.detach(position);
    assert(_positionToListener.containsKey(position));
    _positionToListener[position].forceCancel();
    _positionToListener.remove(position);
  }

  @override
  void dispose() {
    for (final DragHoldController item in _positionToListener.values) {
      item.forceCancel();
    }
    super.dispose();
  }

  void handleDragDown(DragDownDetails details) {
    for (final DragHoldController item in _positionToListener.values) {
      item.handleDragDown(details);
    }
  }

  void handleDragStart(DragStartDetails details) {
    for (final DragHoldController item in _positionToListener.values) {
      item.handleDragStart(details);
    }
  }

  void handleDragUpdate(DragUpdateDetails details) {
    for (final DragHoldController item in _positionToListener.values) {
      item.handleDragUpdate(details);
    }
  }

  void handleDragEnd(DragEndDetails details) {
    for (final DragHoldController item in _positionToListener.values) {
      item.handleDragEnd(details);
    }
  }

  void handleDragCancel() {
    for (final DragHoldController item in _positionToListener.values) {
      item.handleDragCancel();
    }
  }

  void forceCancel() {
    for (final DragHoldController item in _positionToListener.values) {
      item.forceCancel();
    }
  }

  double get extentAfter => _positionToListener.keys.isEmpty
      ? 0
      : _positionToListener.keys.first.extentAfter;
  double get extentBefore => _positionToListener.keys.isEmpty
      ? 0
      : _positionToListener.keys.first.extentBefore;
  ScrollPosition get scrollPosition =>
      _positionToListener.keys.isEmpty ? null : _positionToListener.keys.first;

  bool get hasDrag => _positionToListener.values
      .any((DragHoldController element) => element.hasDrag);
  bool get hasHold => _positionToListener.values
      .any((DragHoldController element) => element.hasHold);
}
