import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'controller/scroll_controller.dart';

mixin HorizontalSyncScrollMinxin {
  Map<Type, GestureRecognizerFactory> _gestureRecognizers;
  Map<Type, GestureRecognizerFactory> get gestureRecognizers =>
      _gestureRecognizers;
  SyncScrollController get horizontalController;
  SyncControllerMixin get horizontalSyncController;
  ScrollPhysics get physics;

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
    horizontalSyncController?.forceCancel();
    horizontalController?.forceCancel();
    horizontalController?.handleDragDown(details);
  }

  void _handleDragStart(DragStartDetails details) {
    horizontalController?.handleDragStart(details);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _handleTabView(details);
    if (horizontalSyncController?.hasDrag ?? false) {
      horizontalSyncController.handleDragUpdate(details);
    } else {
      horizontalController.handleDragUpdate(details);
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (horizontalSyncController?.hasDrag ?? false) {
      horizontalSyncController.handleDragEnd(details);
    } else {
      horizontalController.handleDragEnd(details);
    }
  }

  void _handleDragCancel() {
    horizontalController?.handleDragCancel();
    horizontalSyncController?.handleDragCancel();
  }

  bool _handleTabView(DragUpdateDetails details) {
    if (horizontalSyncController != null) {
      final double delta = details.delta.dx;

      if ((delta < 0 &&
              horizontalController.extentAfter == 0 &&
              horizontalSyncController.extentAfter != 0) ||
          (delta > 0 &&
              horizontalController.extentBefore == 0 &&
              horizontalSyncController.extentBefore != 0)) {
        if (!horizontalSyncController.hasHold &&
            !horizontalSyncController.hasDrag) {
          horizontalSyncController.handleDragDown(null);
          horizontalSyncController.handleDragStart(DragStartDetails(
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

  RawGestureDetector buildGestureDetector({@required Widget child}) {
    return RawGestureDetector(
      gestures: gestureRecognizers,
      child: child,
    );
  }
}
