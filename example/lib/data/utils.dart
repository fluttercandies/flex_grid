import 'dart:convert';
import 'dart:developer';

import 'package:flex_grid/flex_grid.dart';
import 'package:flutter/material.dart';

void tryCatch(Function f) {
  try {
    f.call();
  } catch (e, stack) {
    log('$e');
    log('$stack');
  }
}

class FFConvert {
  FFConvert._();

  static T? Function<T>(dynamic value) convert = <T>(dynamic value) {
    if (value == null) {
      return null;
    }
    return json.decode(value.toString()) as T?;
  };
}

T? asT<T>(dynamic value, [T? defaultValue]) {
  if (value is T) {
    return value;
  }
  try {
    if (value != null) {
      final String valueS = value.toString();
      if ('' is T) {
        return valueS as T;
      } else if (0 is T) {
        return int.parse(valueS) as T;
      } else if (0.0 is T) {
        return double.parse(valueS) as T;
      } else if (false is T) {
        if (valueS == '0' || valueS == '1') {
          return (valueS == '1') as T;
        }
        return (valueS == 'true') as T;
      } else {
        return FFConvert.convert<T>(value);
      }
    }
  } catch (e, stackTrace) {
    log('asT<$T>', error: e, stackTrace: stackTrace);
    return defaultValue;
  }

  return defaultValue;
}

class MyCellStyle extends CellStyle {
  MyCellStyle({
    Alignment alignment = Alignment.center,
    EdgeInsetsGeometry? padding,
    Color? color,
    Decoration? decoration,
    double height = 60,
    double width = 100,
    this.frozenedColumnsCount = 0,
    this.frozenedRowsCount = 0,
  }) : super(
          alignment: alignment,
          padding: padding,
          color: color,
          decoration: decoration,
          height: height,
          width: width,
        );

  final int frozenedColumnsCount;
  final int frozenedRowsCount;
  @override
  Widget apply(
    Widget child,
    int row,
    int column, {
    CellStyleType type = CellStyleType.cell,
  }) {
    Color backgroundColor = Colors.white;

    switch (type) {
      case CellStyleType.header:
        backgroundColor =
            column < frozenedColumnsCount ? Colors.yellow : Colors.lightGreen;
        break;
      case CellStyleType.cell:
        backgroundColor = row < frozenedRowsCount
            ? Colors.purple
            : (column < frozenedColumnsCount ? Colors.yellow : Colors.white);
        break;
      case CellStyleType.footer:
        backgroundColor =
            column < frozenedColumnsCount ? Colors.yellow : Colors.lightGreen;
        break;
      default:
        backgroundColor = Colors.white;
    }

    return Container(
      child: child,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          top: type == CellStyleType.footer
              ? BorderSide(
                  color: Colors.grey.withOpacity(0.5),
                )
              : BorderSide.none,
          bottom: type != CellStyleType.footer
              ? BorderSide(
                  color: Colors.grey.withOpacity(0.5),
                )
              : BorderSide.none,
          right: BorderSide(
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
      ),
      alignment: alignment,
      width: getWidth(column: column),
      height: getHeight(row: row),
    );
  }
}
