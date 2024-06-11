import 'package:ecommerce_app/common/widgets/custom_shapes/Containers/primary_header_container.dart';
import 'package:ecommerce_app/common/widgets/custom_shapes/Containers/search_container.dart';
import 'package:ecommerce_app/common/widgets/layout/grid_layout.dart';
import 'package:ecommerce_app/common/widgets/products/products_card/product_card_vertical.dart';
import 'package:ecommerce_app/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:ecommerce_app/common/widgets/text/section_heading.dart';
import 'package:ecommerce_app/features/shop/controllers/product/product_controller.dart';
import 'package:ecommerce_app/features/shop/screens/all_products/all_products_page.dart';
import 'package:ecommerce_app/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:ecommerce_app/features/shop/screens/home/widgets/home_categories.dart';
import 'package:ecommerce_app/features/shop/screens/home/widgets/home_promo_slider.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Header
            EPrimaryHeaderContainer(
              child: Column(
                children: [
                  /// AppBar
                  const EHomeAppBar(),
                  const SizedBox(
                    height: ESizes.spaceBtItems,
                  ),

                  /// SearchBar
                  ESearchContainer(
                    text: 'Search in Store',
                    onTap: () {},
                  ),
                  const SizedBox(
                    height: ESizes.spaceBtItems,
                  ),

                  /// Categories
                  const EHomeCategories(),
                ],
              ),
            ),

            ///Body --Carousel
            Padding(
              padding: const EdgeInsets.all(ESizes.defaultSpace),
              child: Column(
                children: [
                  const PromoSlider(),
                  const SizedBox(
                    height: ESizes.spaceBtSections,
                  ),
                  ESectionHeading(
                    title: 'Popular Products',
                    onPressed: () => Get.to(() => AllProductsPage(
                          title: 'Popular Products',
                          futureMethod: controller.fetchAllFeaturedProducts(),
                        )),
                  ),
                  const SizedBox(
                    height: ESizes.spaceBtSections,
                  ),
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const EVerticalProductShimmer();
                    }
                    if (controller.featuredProducts.isEmpty) {
                      return Center(
                          child: Text(
                        'No Data Found',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ));
                    }
                    return EGridLayout(
                      itemCount: controller.featuredProducts.length,
                      itemBuilder: (_, index) => EProductCardVertical(
                        product: controller.featuredProducts[index],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
