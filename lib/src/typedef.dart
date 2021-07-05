import 'package:flutter/material.dart';

typedef CellBuilder<T> = Widget Function(
  BuildContext context,
  T data,
  int row,
  int column,
);

typedef RowBuilder<T> = Widget Function(
  BuildContext context,
  T data,
  int row,
);

typedef HeaderBuilder = Widget Function(
  BuildContext context,
  int index,
);
