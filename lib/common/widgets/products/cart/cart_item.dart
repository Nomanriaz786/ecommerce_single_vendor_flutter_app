import 'package:ecommerce_app/common/widgets/images/e_rounded_images.dart';
import 'package:ecommerce_app/common/widgets/text/e_brand_title_text_with_verified_icon.dart';
import 'package:ecommerce_app/common/widgets/text/product_title_text.dart';
import 'package:ecommerce_app/features/shop/models/cart_item_model.dart';
import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:ecommerce_app/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class ECartItem extends StatelessWidget {
  const ECartItem({
    super.key,
    required this.cartItem,
  });
  final CartItemModel cartItem;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ///image
        ERoundedImage(
          imageUrl: cartItem.image ?? '',
          isNetworkImage: true,
          width: 80,
          height: 80,
          padding: const EdgeInsets.all(ESizes.sm),
          backGroundColor: EHelperFunctions.isDarkMode(context)
              ? EColors.darkerGrey
              : EColors.grey,
        ),

        ///title, brand
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(ESizes.defaultSpace),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EBrandTitleTextWithVerifiedIcon(
                    title: cartItem.brandName ?? ''),
                Flexible(
                  child: EProductTitleText(
                    title: cartItem.title,
                    maxLines: 1,
                  ),
                ),
                Text.rich(
                  TextSpan(
                      children: (cartItem.selectedVariation ?? {})
                          .entries
                          .map(
                            (e) => TextSpan(
                              children: [
                                TextSpan(
                                    text: ' ${e.key} ',
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                                TextSpan(
                                    text: ' ${e.value} ',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                              ],
                            ),
                          )
                          .toList()),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
