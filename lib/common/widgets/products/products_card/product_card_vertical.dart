import 'package:ecommerce_app/common/styles/shadow.dart';
import 'package:ecommerce_app/common/widgets/custom_shapes/Containers/rounded_container.dart';
import 'package:ecommerce_app/common/widgets/images/e_rounded_images.dart';
import 'package:ecommerce_app/common/widgets/products/favourite_icon/favourite_icon.dart';
import 'package:ecommerce_app/common/widgets/text/e_brand_title_text_with_verified_icon.dart';
import 'package:ecommerce_app/common/widgets/text/product_price_text.dart';
import 'package:ecommerce_app/common/widgets/text/product_title_text.dart';
import 'package:ecommerce_app/features/shop/controllers/product/product_controller.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/features/shop/screens/product_details/product_details.dart';
import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:ecommerce_app/util/constants/enums.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:ecommerce_app/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../features/shop/screens/store/widgets/add_to_cart_button.dart';

class EProductCardVertical extends StatelessWidget {
  const EProductCardVertical({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    final salePercentage =
        controller.calculateSalePercentage(product.price, product.salePrice);
    final dark = EHelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailsScreen(
            product: product,
          )),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [EShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(ESizes.productImageRadius),
          color: dark ? EColors.darkerGrey : EColors.white,
        ),
        child: Column(
          children: [
            ///Thumbnail, wishlist, discount tag
            Expanded(
              child: ERoundedContainer(
                width: 180,
                padding: const EdgeInsets.all(ESizes.sm),
                backGroundColor: dark ? EColors.dark : EColors.light,
                child: Stack(
                  children: [
                    ///Thumbnail
                    Center(
                      child: ERoundedImage(
                        imageUrl: product.thumbnail,
                        height: 180,
                        isNetworkImage: true,
                        applyImageRadius: true,
                      ),
                    ),
                    if (salePercentage != null)
                      Positioned(
                        top: 12,
                        child: ERoundedContainer(
                          radius: ESizes.sm,
                          backGroundColor: EColors.secondary.withOpacity(0.8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: ESizes.sm, vertical: ESizes.xs),
                          child: Text(
                            salePercentage,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .apply(color: EColors.black),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: EFavouriteIcon(
                        productId: product.id,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: ESizes.spaceBtItems / 2,
            ),

            ///Detail
            Padding(
              padding: const EdgeInsets.all(ESizes.sm),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EProductTitleText(
                      title: product.title,
                      smallSize: true,
                    ),
                    const SizedBox(
                      height: ESizes.spaceBtItems / 2,
                    ),
                    if (product.brand != null)
                      EBrandTitleTextWithVerifiedIcon(
                        title: product.brand!.name,
                      ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ///Price
                Flexible(
                  child: Column(
                    children: [
                      if (product.productType ==
                              ProductType.single.toString() &&
                          product.salePrice > 0)
                        Text(
                          '\$${product.price}',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .apply(decoration: TextDecoration.lineThrough),
                          textAlign: TextAlign.left,
                        ),

                      /// -Show sale price as main price if sale exist
                      Padding(
                        padding: const EdgeInsets.all(ESizes.sm),
                        child: EProductPriceText(
                          price: controller.getProductPrice(product),
                        ),
                      ),
                    ],
                  ),
                ),

                ///ADD to Cart
                ProductCardAddToCartButton(
                  product: product,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
