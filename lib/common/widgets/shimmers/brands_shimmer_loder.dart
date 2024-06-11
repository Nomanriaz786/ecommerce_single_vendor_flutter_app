import 'package:ecommerce_app/common/widgets/layout/grid_layout.dart';
import 'package:ecommerce_app/common/widgets/shimmers/shimmer.dart';
import 'package:flutter/material.dart';

class EBrandsShimmerLoader extends StatelessWidget {
  const EBrandsShimmerLoader({super.key, this.itemCount = 4});
  final int itemCount;
  @override
  Widget build(BuildContext context) {
    return EGridLayout(
        itemCount: itemCount,
        mainAxisExtent: 80,
        itemBuilder: (_, index) {
          return const EShimmerEffect(width: 300, height: 80);
        });
  }
}
