import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/common/widgets/products/sortable/brand_products.dart';
import 'package:ecommerce_app/common/widgets/shimmers/shimmer.dart';
import 'package:ecommerce_app/features/shop/models/brand_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../util/constants/colors.dart';
import '../../../util/constants/sizes.dart';
import '../../../util/helpers/helper_functions.dart';
import '../custom_shapes/Containers/rounded_container.dart';
import 'brands_card.dart';

class EBrandShowCase extends StatelessWidget {
  const EBrandShowCase({
    super.key,
    required this.image,
    required this.brand,
  });
  final List<String> image;
  final BrandModel brand;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => BrandProducts(brand: brand)),
      child: ERoundedContainer(
        showBorder: true,
        borderColor: EColors.darkGrey,
        backGroundColor: Colors.transparent,
        padding: const EdgeInsets.all(ESizes.md),
        margin: const EdgeInsets.only(bottom: ESizes.spaceBtItems),
        child: Column(
          children: [
            /// --Brands with product count
            EBrandsCard(
              showBorder: false,
              brand: brand,
            ),

            /// --Brands top 3 product images
            Row(
                children: image
                    .map((image) => brandTopProductImageWidget(image, context))
                    .toList()),
          ],
        ),
      ),
    );
  }

  Widget brandTopProductImageWidget(String image, context) {
    return Expanded(
      child: ERoundedContainer(
        height: 100,
        margin: const EdgeInsets.all(ESizes.sm),
        padding: const EdgeInsets.all(ESizes.md),
        backGroundColor: EHelperFunctions.isDarkMode(context)
            ? EColors.darkerGrey
            : EColors.light,
        child: CachedNetworkImage(
          fit: BoxFit.contain,
          imageUrl: image,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              const EShimmerEffect(width: 100, height: 100),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}
