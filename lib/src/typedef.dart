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
