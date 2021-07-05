import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class NeverScrollableClampingScrollPhysics extends ClampingScrollPhysics
    with LessSpringScrollPhysics {
  const NeverScrollableClampingScrollPhysics()
      : super(parent: const NeverScrollableScrollPhysics());
}

/// reduce animation time
mixin LessSpringScrollPhysics on ScrollPhysics {
  @override
  SpringDescription get spring => SpringDescription.withDampingRatio(
        mass: 0.5,
        stiffness: 1000.0, // Increase this value as you wish.
        ratio: 1.1,
      );
}

class LessSpringClampingScrollPhysics extends ClampingScrollPhysics
    with LessSpringScrollPhysics {
  const LessSpringClampingScrollPhysics()
      : super(parent: const ClampingScrollPhysics());
}
