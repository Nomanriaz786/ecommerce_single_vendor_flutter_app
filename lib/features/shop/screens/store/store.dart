import 'package:ecommerce_app/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce_app/common/widgets/appbar/tabbar.dart';
import 'package:ecommerce_app/common/widgets/brands/brands_card.dart';
import 'package:ecommerce_app/common/widgets/custom_shapes/Containers/search_container.dart';
import 'package:ecommerce_app/common/widgets/layout/grid_layout.dart';
import 'package:ecommerce_app/common/widgets/products.cart/cart_menu_counter.dart';
import 'package:ecommerce_app/common/widgets/products/sortable/brand_products.dart';
import 'package:ecommerce_app/common/widgets/shimmers/brands_shimmer_loder.dart';
import 'package:ecommerce_app/common/widgets/text/section_heading.dart';
import 'package:ecommerce_app/features/shop/controllers/brand_controller.dart';
import 'package:ecommerce_app/features/shop/controllers/category_controller.dart';
import 'package:ecommerce_app/features/shop/screens/brands/all_brands.dart';
import 'package:ecommerce_app/features/shop/screens/store/widgets/category_tabbar.dart';
import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:ecommerce_app/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brandController = BrandController.instance;
    final categories = CategoryController.instance.allCategories;
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: EAppBar(
          title: Text(
            'Store',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          actions: [
            ECartCounterIcon(
              onPressed: () {},
            ),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (_, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                floating: true,
                expandedHeight: 440,
                backgroundColor: EHelperFunctions.isDarkMode(context)
                    ? EColors.dark
                    : EColors.white,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(ESizes.defaultSpace),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ///Search Bar
                      const SizedBox(
                        height: ESizes.spaceBtItems,
                      ),
                      const ESearchContainer(
                        text: 'Search in the Store',
                        showBorder: true,
                        showBackground: false,
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(
                        height: ESizes.spaceBtSections,
                      ),

                      ///Featured Brands
                      ESectionHeading(
                        title: 'Featured Brands',
                        showActionButton: true,
                        onPressed: () => Get.to(() => const AllBrandsScreen()),
                      ),
                      const SizedBox(
                        height: ESizes.spaceBtItems / 1.5,
                      ),

                      ///Brands Grid
                      Obx(() {
                        if (brandController.isLoading.value) {
                          return const EBrandsShimmerLoader();
                        }
                        if (brandController.featuredBrands.isEmpty) {
                          return Center(
                            child: Text(
                              'No Data found',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .apply(color: EColors.white),
                            ),
                          );
                        }
                        return EGridLayout(
                            itemCount: brandController.featuredBrands.length,
                            mainAxisExtent: 80,
                            itemBuilder: (_, index) {
                              final brand =
                                  brandController.featuredBrands[index];
                              return EBrandsCard(
                                brand: brand,
                                showBorder: true,
                                onTap: () => Get.to(() => BrandProducts(
                                      brand: brand,
                                    )),
                              );
                            });
                      }),
                    ],
                  ),
                ),
                bottom: ETabBar(
                  tabs: categories
                      .map((category) => Tab(
                            child: Text(category.name),
                          ))
                      .toList(),
                ),
              )
            ];
          },
          body: TabBarView(
            children: categories
                .map((category) => ECategoryTab(
                      category: category,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
