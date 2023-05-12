import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

const double maxDragOffset = 90;
double hideHeight = maxDragOffset / 2.3;
double refreshHeight = maxDragOffset / 1.5;

class PullToRefreshHeader extends StatelessWidget {
  const PullToRefreshHeader(this.info, this.lastRefreshTime, {this.color});
  final PullToRefreshScrollNotificationInfo? info;
  final DateTime? lastRefreshTime;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    if (info == null) {
      return Container();
    }
    String text = '';
    if (info!.mode == PullToRefreshIndicatorMode.armed) {
      text = 'Release to refresh';
    } else if (info!.mode == PullToRefreshIndicatorMode.refresh ||
        info!.mode == PullToRefreshIndicatorMode.snap) {
      text = 'Loading...';
    } else if (info!.mode == PullToRefreshIndicatorMode.done) {
      text = 'Refresh completed.';
    } else if (info!.mode == PullToRefreshIndicatorMode.drag) {
      text = 'Pull to refresh';
    } else if (info!.mode == PullToRefreshIndicatorMode.canceled) {
      text = 'Cancel refresh';
    }

    final TextStyle ts = const TextStyle(
      color: Colors.grey,
    ).copyWith(fontSize: 13);

    final double dragOffset = info?.dragOffset ?? 0.0;

    final DateTime time = lastRefreshTime ?? DateTime.now();
    final double top = -hideHeight + dragOffset;
    return Container(
      height: dragOffset,
      color: color ?? Colors.transparent,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0.0,
            right: 0.0,
            top: top,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  text,
                  style: ts,
                ),
                Text(
                  'Last updated:' + DateFormat('yyyy-MM-dd hh:mm').format(time),
                  style: ts.copyWith(fontSize: 12),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
