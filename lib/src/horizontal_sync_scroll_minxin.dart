import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'controller/scroll_controller.dart';

mixin HorizontalSyncScrollMinxin {
  Map<Type, GestureRecognizerFactory>? _gestureRecognizers;
  Map<Type, GestureRecognizerFactory>? get gestureRecognizers =>
      _gestureRecognizers;
  SyncControllerMixin? get horizontalController;
  SyncControllerMixin? get outerHorizontalSyncController;
  ScrollPhysics? get physics;

  void initGestureRecognizers() {
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
            ..minFlingDistance = physics?.minFlingDistance
            ..minFlingVelocity = physics?.minFlingVelocity
            ..maxFlingVelocity = physics?.maxFlingVelocity;
        },
      ),
    };
  }

  void _handleDragDown(
    DragDownDetails details,
  ) {
    outerHorizontalSyncController?.forceCancel();
    horizontalController?.forceCancel();
    horizontalController?.handleDragDown(details);
  }

  void _handleDragStart(DragStartDetails details) {
    horizontalController?.handleDragStart(details);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _handleTabView(details);
    if (outerHorizontalSyncController?.hasDrag ?? false) {
      outerHorizontalSyncController!.handleDragUpdate(details);
    } else {
      horizontalController!.handleDragUpdate(details);
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (outerHorizontalSyncController?.hasDrag ?? false) {
      outerHorizontalSyncController!.handleDragEnd(details);
    } else {
      horizontalController!.handleDragEnd(details);
    }
  }

  void _handleDragCancel() {
    horizontalController?.handleDragCancel();
    outerHorizontalSyncController?.handleDragCancel();
  }

  bool _handleTabView(DragUpdateDetails details) {
    if (outerHorizontalSyncController != null) {
      final double delta = details.delta.dx;

      if ((delta < 0 &&
              horizontalController!.extentAfter == 0 &&
              outerHorizontalSyncController!.extentAfter != 0) ||
          (delta > 0 &&
              horizontalController!.extentBefore == 0 &&
              outerHorizontalSyncController!.extentBefore != 0)) {
        if (!outerHorizontalSyncController!.hasHold &&
            !outerHorizontalSyncController!.hasDrag) {
          outerHorizontalSyncController!.handleDragDown(null);
          outerHorizontalSyncController!.handleDragStart(DragStartDetails(
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

  RawGestureDetector buildGestureDetector({required Widget child}) {
    return RawGestureDetector(
      gestures: gestureRecognizers!,
      child: child,
    );
  }
}
