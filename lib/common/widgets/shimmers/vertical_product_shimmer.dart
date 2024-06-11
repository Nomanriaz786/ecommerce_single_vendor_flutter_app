import 'package:ecommerce_app/common/widgets/layout/grid_layout.dart';
import 'package:ecommerce_app/common/widgets/shimmers/shimmer.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:flutter/material.dart';

class EVerticalProductShimmer extends StatelessWidget {
  const EVerticalProductShimmer({super.key, this.itemCount = 4});
  final int itemCount;
  @override
  Widget build(BuildContext context) {
    return EGridLayout(
      itemCount: itemCount,
      itemBuilder: (_, __) {
        return const SizedBox(
          width: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// -Image
              EShimmerEffect(width: 180, height: 180),
              SizedBox(
                height: ESizes.spaceBtItems,
              ),

              /// -Text
              EShimmerEffect(width: 160, height: 15),
              SizedBox(
                height: ESizes.spaceBtItems / 2,
              ),
              EShimmerEffect(width: 110, height: 15),
            ],
          ),
        );
      },
    );
  }
}
