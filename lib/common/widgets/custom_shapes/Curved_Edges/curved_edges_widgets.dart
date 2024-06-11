import 'package:ecommerce_app/common/widgets/custom_shapes/Curved_Edges/curved_edges.dart';
import 'package:flutter/material.dart';

class ECurvedEdgesWidgets extends StatelessWidget {
  const ECurvedEdgesWidgets({
    super.key,
    this.child,
  });
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ECustomCurvedEdges(),
      child: child,
    );
  }
}
