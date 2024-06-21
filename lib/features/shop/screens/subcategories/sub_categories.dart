import 'package:ecommerce_app/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce_app/common/widgets/images/e_rounded_images.dart';
import 'package:ecommerce_app/common/widgets/products/products_card/product_card_horizontal.dart';
import 'package:ecommerce_app/common/widgets/shimmers/horizontal_product_shimmer.dart';
import 'package:ecommerce_app/common/widgets/text/section_heading.dart';
import 'package:ecommerce_app/features/shop/controllers/category_controller.dart';
import 'package:ecommerce_app/features/shop/models/category_model.dart';
import 'package:ecommerce_app/features/shop/screens/all_products/all_products_page.dart';
import 'package:ecommerce_app/util/constants/image_strings.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubCategoriesScreen extends StatelessWidget {
  const SubCategoriesScreen({super.key, required this.category});
  final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    final controller = CategoryController.instance;
    return Scaffold(
      appBar: EAppBar(
        title: Text(category.name),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            children: [
              /// -Banner
              const ERoundedImage(
                imageUrl: EImages.promoBanner3,
                applyImageRadius: true,
                width: double.infinity,
              ),
              const SizedBox(
                height: ESizes.spaceBtSections,
              ),

              /// -Sub-Categories
              FutureBuilder(
                  future: controller.getSubCategories(category.id),
                  builder: (context, snapshot) {
                    const loader = EHorizontalProductShimmer();
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
                    // -Record found
                    final subCategories = snapshot.data!;
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: subCategories.length,
                        itemBuilder: (_, index) {
                          final subCategory = subCategories[index];
                          return FutureBuilder(
                              future: controller.getCategoryProducts(
                                  categoryId: subCategory.id),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
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
                                // -Record found
                                final products = snapshot.data!;
                                return Column(
                                  children: [
                                    ESectionHeading(
                                      title: subCategory.name,
                                      onPressed: () => Get.to(
                                        () => AllProductsPage(
                                          title: category.name,
                                          futureMethod:
                                              controller.getCategoryProducts(
                                                  categoryId: category.id,
                                                  limit: -1),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: ESizes.spaceBtItems / 2,
                                    ),
                                    SizedBox(
                                      height: 120,
                                      child: ListView.separated(
                                        itemCount: products.length,
                                        scrollDirection: Axis.horizontal,
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(
                                          width: ESizes.spaceBtItems,
                                        ),
                                        itemBuilder: (context, index) =>
                                            EProductCardHorizontal(
                                                product: products[index]),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: ESizes.spaceBtSections,
                                    ),
                                  ],
                                );
                              });
                        });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
