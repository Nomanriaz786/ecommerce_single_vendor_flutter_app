import 'package:ecommerce_app/common/widgets/layout/grid_layout.dart';
import 'package:ecommerce_app/common/widgets/products/products_card/product_card_vertical.dart';
import 'package:ecommerce_app/common/widgets/shimmers/EListTielShimmer.dart';
import 'package:ecommerce_app/common/widgets/shimmers/boxes_shimmer.dart';
import 'package:ecommerce_app/common/widgets/text/section_heading.dart';
import 'package:ecommerce_app/features/shop/controllers/category_controller.dart';
import 'package:ecommerce_app/features/shop/models/category_model.dart';
import 'package:ecommerce_app/features/shop/screens/all_products/all_products_page.dart';
import 'package:ecommerce_app/features/shop/screens/store/widgets/category_brands.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../util/constants/sizes.dart';

class ECategoryTab extends StatelessWidget {
  const ECategoryTab({super.key, required this.category});
  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = CategoryController.instance;
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            children: [
              /// --Brands
              CategoryBrands(category: category),
              const SizedBox(
                height: ESizes.spaceBtItems,
              ),

              /// --Products
              FutureBuilder(
                  future:
                      controller.getCategoryProducts(categoryId: category.id),
                  builder: (context, snapshot) {
                    const loader = Column(
                      children: [
                        EListTileShimmer(),
                        SizedBox(
                          height: ESizes.spaceBtItems,
                        ),
                        EBoxesShimmer(),
                        SizedBox(
                          height: ESizes.spaceBtItems,
                        ),
                      ],
                    );
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return loader;
                    }
                    if (!snapshot.hasData ||
                        snapshot.data == null ||
                        snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No Data Found'),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Something went wrong'),
                      );
                    }
                    final products = snapshot.data!;
                    return Column(
                      children: [
                        ESectionHeading(
                          title: 'You might like',
                          onPressed: () => Get.to(
                            AllProductsPage(
                              title: category.name,
                              futureMethod: controller.getCategoryProducts(
                                  categoryId: category.id, limit: -1),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: ESizes.spaceBtItems,
                        ),
                        EGridLayout(
                          itemCount: products.length,
                          itemBuilder: (_, index) => EProductCardVertical(
                            product: products[index],
                          ),
                        ),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ],
    );
  }
}
