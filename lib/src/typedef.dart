import 'package:flutter/material.dart';

typedef CellBuilder = Widget Function<T>(
  BuildContext context,
  T data,
  int row,
  int column,
);

typedef HeaderBuilder = Widget Function(
  BuildContext context,
  int index,
);
