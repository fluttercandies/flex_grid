import 'package:flutter/material.dart';

typedef CellBuilder<T> = Widget Function(
  BuildContext context,
  T data,
  int row,
  int column,
);

typedef RowWrapper<T> = Widget Function(
  BuildContext context,
  T data,
  int row,
//  SizedBox(
//     width: boxConstraints.maxWidth,
//     height: _cellStyle.height,
//     child: CustomScrollView(scrollDirection: Axis.horizontal,),
//   )
// child must has height
  Widget child,
);

typedef HeaderBuilder = Widget Function(
  BuildContext context,
  int index,
);

typedef HeadersBuilder = List<Widget> Function(
  BuildContext context,
  Widget header,
);
