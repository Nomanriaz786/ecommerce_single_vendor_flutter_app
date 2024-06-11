// ignore_for_file: file_names

import 'package:ecommerce_app/common/widgets/shimmers/shimmer.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:flutter/material.dart';

class EListTileShimmer extends StatelessWidget {
  const EListTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            EShimmerEffect(
              width: 50,
              height: 50,
              radius: 50,
            ),
            SizedBox(
              width: ESizes.spaceBtItems,
            ),
            Column(
              children: [
                EShimmerEffect(
                  width: 100,
                  height: 15,
                ),
                SizedBox(
                  width: ESizes.spaceBtItems / 2,
                ),
                EShimmerEffect(width: 80, height: 12)
              ],
            )
          ],
        )
      ],
    );
  }
}
