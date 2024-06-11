import 'package:ecommerce_app/common/widgets/shimmers/shimmer.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:flutter/material.dart';

class ECategoryShimmer extends StatelessWidget {
  const ECategoryShimmer({super.key, this.itemCount = 6});
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
          itemCount: itemCount,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          separatorBuilder: (_, __) => const SizedBox(
                width: ESizes.spaceBtItems,
              ),
          itemBuilder: (_, __) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Images
                EShimmerEffect(
                  width: 55,
                  height: 55,
                  radius: 55,
                ),
                SizedBox(
                  height: ESizes.spaceBtItems / 2,
                ),
                EShimmerEffect(width: 55, height: 8),
              ],
            );
          }),
    );
  }
}
