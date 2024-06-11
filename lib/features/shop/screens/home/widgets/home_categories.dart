import 'package:ecommerce_app/common/widgets/image_text/vertical_image_text.dart';
import 'package:ecommerce_app/common/widgets/shimmers/category_shimmer.dart';
import 'package:ecommerce_app/common/widgets/text/section_heading.dart';
import 'package:ecommerce_app/features/shop/controllers/category_controller.dart';
import 'package:ecommerce_app/features/shop/screens/subcategories/sub_categories.dart';
import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EHomeCategories extends StatelessWidget {
  const EHomeCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());
    return Padding(
      padding: const EdgeInsets.all(ESizes.defaultSpace),
      child: Column(
        children: [
          const ESectionHeading(
            title: 'Popular Categories',
            showActionButton: false,
            textColor: EColors.white,
          ),
          const SizedBox(
            height: ESizes.spaceBtItems,
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return const ECategoryShimmer();
            }
            if (controller.featuredCategories.isEmpty) {
              return Center(
                child: Text(
                  'No Data Found',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .apply(color: EColors.white),
                ),
              );
            }
            return SizedBox(
              height: 80,
              child: ListView.builder(
                itemCount: controller.featuredCategories.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) {
                  final category = controller.featuredCategories[index];
                  return EVerticalImageText(
                    title: category.name,
                    image: category.image,
                    onTap: () => Get.to(() => const SubCategoriesScreen()),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
