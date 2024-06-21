import 'package:ecommerce_app/common/widgets/custom_shapes/Containers/rounded_container.dart';
import 'package:ecommerce_app/common/widgets/images/e_circular_image.dart';
import 'package:ecommerce_app/common/widgets/text/e_brand_title_text_with_verified_icon.dart';
import 'package:ecommerce_app/common/widgets/text/product_price_text.dart';
import 'package:ecommerce_app/common/widgets/text/product_title_text.dart';
import 'package:ecommerce_app/features/shop/controllers/product/product_controller.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:ecommerce_app/util/constants/enums.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:ecommerce_app/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class EProductMetaData extends StatelessWidget {
  const EProductMetaData({super.key, required this.product});
  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    final salePercentage =
        controller.calculateSalePercentage(product.price, product.salePrice);
    final dark = EHelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Price & Sale Price
        Row(
          children: [
            ///sales tag
            ERoundedContainer(
              radius: ESizes.sm,
              backGroundColor: EColors.secondary.withOpacity(0.8),
              padding: const EdgeInsets.symmetric(
                  horizontal: ESizes.sm, vertical: ESizes.xs),
              child: Text(
                '$salePercentage',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .apply(color: EColors.black),
              ),
            ),

            /// Price
            const SizedBox(
              width: ESizes.spaceBtItems,
            ),
            if (product.productType == ProductType.single.toString() &&
                product.salePrice > 0)
              Text(
                '\$${product.price}',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .apply(decoration: TextDecoration.lineThrough),
              ),
            if (product.productType == ProductType.single.toString() &&
                product.salePrice > 0)
              const SizedBox(
                width: ESizes.spaceBtItems,
              ),
            EProductPriceText(
              price: controller.getProductPrice(product),
              isLarge: true,
            ),
          ],
        ),
        const SizedBox(
          height: ESizes.spaceBtItems / 1.5,
        ),

        /// title
        EProductTitleText(
          title: product.title,
        ),
        const SizedBox(
          height: ESizes.spaceBtItems / 1.5,
        ),

        /// stock status
        Row(
          children: [
            const EProductTitleText(
              title: 'Status :',
            ),
            const SizedBox(
              width: ESizes.spaceBtItems,
            ),
            Text(
              controller.getProductStockStatus(product.stock),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),

        const SizedBox(
          height: ESizes.spaceBtItems / 1.5,
        ),

        /// brand
        if (product.brand != null)
          Row(
            children: [
              ECircularImage(
                image: product.brand!.image,
                isNetworkImage: true,
                width: 32,
                height: 32,
                overlayColor: dark ? EColors.white : EColors.black,
              ),
              EBrandTitleTextWithVerifiedIcon(
                title: product.brand!.name,
                brandTextSizes: TextSizes.medium,
              ),
            ],
          )
      ],
    );
  }
}
