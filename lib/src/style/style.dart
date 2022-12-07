import 'package:flutter/material.dart';

/// An immutable style describing how to create header/cell
class CellStyle {
  const CellStyle({
    this.alignment = Alignment.center,
    this.padding,
    this.color,
    this.decoration,
    this.height = 60,
    this.width = 100,
  }) : assert(
            color == null || decoration == null,
            'Cannot provide both a color and a decoration\n'
            'To provide both, use "decoration: BoxDecoration(color: color)".');

  factory CellStyle.header() => CellStyle(
        decoration: BoxDecoration(
          color: Colors.lightGreen,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.5),
            ),
            right: BorderSide(
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
        ),
      );
  factory CellStyle.cell() => CellStyle(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.5),
            ),
            right: BorderSide(
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
        ),
      );

  factory CellStyle.footer() => CellStyle(
        decoration: BoxDecoration(
          color: Colors.lightGreen,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.5),
            ),
            right: BorderSide(
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
        ),
      );

  final double height;
  final double width;

  final Alignment alignment;

  /// Empty space to inscribe inside the [decoration]. The [child], if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration];
  /// see [Decoration.padding].
  final EdgeInsetsGeometry? padding;

  /// The color to paint behind the [child].
  ///
  /// This property should be preferred when the background is a simple color.
  /// For other cases, such as gradients or images, use the [decoration]
  /// property.
  ///
  /// If the [decoration] is used, this property must be null. A background
  /// color may still be painted by the [decoration] even if this property is
  /// null.
  final Color? color;

  /// The decoration to paint behind the [child].
  ///
  /// Use the [color] property to specify a simple solid color.
  ///
  /// The [child] is not clipped to the decoration. To clip a child to the shape
  /// of a particular [ShapeDecoration], consider using a [ClipPath] widget.
  final Decoration? decoration;

  Widget apply(
    Widget child,
    // -1 header,
    // -2 footer,
    int row,
    int column, {
    CellStyleType type = CellStyleType.cell,
  }) {
    return Container(
      child: child,
      color: color,
      padding: padding,
      decoration: decoration,
      alignment: alignment,
      height: getHeight(row: row),
      width: getWidth(column: column),
    );
  }

  double getHeight({required int row}) => height;
  double getWidth({required int column}) => width;
}

enum CellStyleType {
  header,
  cell,
  footer,
}
