import 'package:ecommerce_app/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce_app/common/widgets/brands/brands_card.dart';
import 'package:ecommerce_app/common/widgets/layout/grid_layout.dart';
import 'package:ecommerce_app/common/widgets/products/sortable/brand_products.dart';
import 'package:ecommerce_app/common/widgets/shimmers/brands_shimmer_loder.dart';
import 'package:ecommerce_app/common/widgets/text/section_heading.dart';
import 'package:ecommerce_app/features/shop/controllers/brand_controller.dart';
import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllBrandsScreen extends StatelessWidget {
  const AllBrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brandController = BrandController.instance;
    return Scaffold(
      appBar: EAppBar(
        title: Text(
          'Brand',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            children: [
              ///Heading
              ESectionHeading(
                title: 'Brands',
                showActionButton: true,
                onPressed: () => Get.to(() => const AllBrandsScreen()),
              ),
              const SizedBox(
                height: ESizes.spaceBtItems,
              ),

              ///Brand card
              Obx(() {
                if (brandController.isLoading.value) {
                  return const EBrandsShimmerLoader();
                }
                if (brandController.allBrands.isEmpty) {
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
                    itemCount: brandController.allBrands.length,
                    mainAxisExtent: 80,
                    itemBuilder: (_, index) {
                      final brand = brandController.allBrands[index];
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
      ),
    );
  }
}
