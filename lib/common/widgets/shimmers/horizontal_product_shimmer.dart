import 'package:ecommerce_app/common/widgets/shimmers/shimmer.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:flutter/material.dart';

class EHorizontalProductShimmer extends StatelessWidget {
  const EHorizontalProductShimmer({super.key, this.itemCount = 4});
  final int itemCount;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.all(ESizes.spaceBtSections),
      child: ListView.separated(
        itemCount: itemCount,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(
          width: ESizes.spaceBtItems,
        ),
        itemBuilder: (_, __) => const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// -Image
            EShimmerEffect(width: 120, height: 120),
            SizedBox(
              width: ESizes.spaceBtItems,
            ),

            /// -Text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                EShimmerEffect(width: 172, height: 30),
                SizedBox(
                  height: ESizes.spaceBtItems,
                ),
                EShimmerEffect(width: 70, height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
