import 'package:ecommerce_app/common/widgets/text/section_heading.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/features/shop/screens/product_details/widgets/bottom_add_to_cart.dart';
import 'package:ecommerce_app/features/shop/screens/product_details/widgets/product_attributes.dart';
import 'package:ecommerce_app/features/shop/screens/product_details/widgets/product_image_slider.dart';
import 'package:ecommerce_app/features/shop/screens/product_details/widgets/product_meta_data.dart';
import 'package:ecommerce_app/features/shop/screens/product_details/widgets/share_rating_widget.dart';
import 'package:ecommerce_app/features/shop/screens/product_rewiews/product_reviews.dart';
import 'package:ecommerce_app/util/constants/enums.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:ecommerce_app/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.product});
  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    EHelperFunctions.isDarkMode(context);
    return Scaffold(
      bottomNavigationBar: const EBottomAddToCart(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// 1-Product Image Slider
            EProductImageSlider(product: product),

            /// 2-Product Detail
            Padding(
              padding: const EdgeInsets.only(
                  left: ESizes.defaultSpace,
                  bottom: ESizes.defaultSpace,
                  right: ESizes.defaultSpace),
              child: Column(
                children: [
                  /// Share & Rating
                  const EProductShareRatingWidget(),

                  /// title, price, stock, brand
                  EProductMetaData(product: product),
                  const SizedBox(
                    height: ESizes.spaceBtItems,
                  ),

                  ///Attributes
                  if (product.productType == ProductType.variable.toString())
                    EProductAttributes(product: product),
                  if (product.productType == ProductType.variable.toString())
                    const SizedBox(
                      height: ESizes.spaceBtSections,
                    ),

                  ///checkout button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {}, child: const Text('Checkout')),
                  ),
                  const SizedBox(
                    height: ESizes.spaceBtSections,
                  ),

                  ///Description
                  const ESectionHeading(
                    title: 'Description',
                    showActionButton: false,
                  ),
                  const SizedBox(
                    height: ESizes.spaceBtItems,
                  ),
                  ReadMoreText(
                    product.description!,
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'show more',
                    trimExpandedText: 'less',
                    moreStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800),
                    lessStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800),
                  ),

                  ///Reviews
                  const Divider(),
                  const SizedBox(
                    height: ESizes.spaceBtItems,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const ESectionHeading(
                        title: 'Reviews (199)',
                        showActionButton: false,
                      ),
                      IconButton(
                          onPressed: () =>
                              Get.to(() => const ProductReviewsScreen()),
                          icon: const Icon(Iconsax.arrow_right_3))
                    ],
                  ),
                  const SizedBox(
                    height: ESizes.spaceBtSections,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
