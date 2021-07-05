import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class NeverScrollableClampingScrollPhysics extends ClampingScrollPhysics {
  const NeverScrollableClampingScrollPhysics()
      : super(parent: const NeverScrollableScrollPhysics());

  @override
  SpringDescription get spring => SpringDescription.withDampingRatio(
        mass: 0.5,
        stiffness: 10000.0, // Increase this value as you wish.
        ratio: 1.1,
      );
}
