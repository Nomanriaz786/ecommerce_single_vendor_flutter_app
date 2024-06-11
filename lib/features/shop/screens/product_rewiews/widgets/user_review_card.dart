import 'package:ecommerce_app/common/widgets/custom_shapes/Containers/rounded_container.dart';
import 'package:ecommerce_app/common/widgets/products/rating/rating_bar_indicator.dart';
import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:ecommerce_app/util/constants/image_strings.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:ecommerce_app/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class EUserReviewCard extends StatelessWidget {
  const EUserReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage(EImages.userProfileImage1),
                ),
                const SizedBox(
                  width: ESizes.spaceBtItems,
                ),
                Text(
                  'Noman Riaz',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        const SizedBox(
          height: ESizes.spaceBtItems,
        ),

        /// Review
        Row(
          children: [
            const ERatingBarIndicator(value: 4.0),
            const SizedBox(
              width: ESizes.spaceBtItems,
            ),
            Text(
              '12 Nov, 2020',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(
          height: ESizes.spaceBtItems,
        ),
        const ReadMoreText(
          'I’ve been using E-store for a while now, and it’s my go-to app for affordable finds. The variety of products is impressive, and the prices are unbeatable. Shipping times can be a bit long, but considering the savings, it’s worth it!',
          trimLines: 2,
          trimMode: TrimMode.Line,
          trimCollapsedText: ' show more',
          trimExpandedText: ' show less',
          moreStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: EColors.primary),
          lessStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: EColors.primary),
        ),
        const SizedBox(
          height: ESizes.spaceBtItems,
        ),
        ERoundedContainer(
          backGroundColor: dark ? EColors.darkerGrey : EColors.grey,
          child: Padding(
            padding: const EdgeInsets.all(ESizes.md),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Ecommerce Store",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '12 Nov, 2020',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(
                  height: ESizes.spaceBtItems,
                ),
                const ReadMoreText(
                  'I’ve been using E-store for a while now, and it’s my go-to app for affordable finds. The variety of products is impressive, and the prices are unbeatable. Shipping times can be a bit long, but considering the savings, it’s worth it!',
                  trimLines: 2,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: ' show more',
                  trimExpandedText: ' show less',
                  moreStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: EColors.primary),
                  lessStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: EColors.primary),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: ESizes.spaceBtSections,
        )
      ],
    );
  }
}
