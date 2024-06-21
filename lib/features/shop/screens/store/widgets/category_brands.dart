import 'package:ecommerce_app/common/widgets/brands/brand_show_case.dart';
import 'package:ecommerce_app/common/widgets/shimmers/list_tile_shimmer.dart';
import 'package:ecommerce_app/common/widgets/shimmers/boxes_shimmer.dart';
import 'package:ecommerce_app/features/shop/controllers/brand_controller.dart';
import 'package:ecommerce_app/features/shop/models/category_model.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';

import 'package:flutter/material.dart';

class CategoryBrands extends StatelessWidget {
  const CategoryBrands({super.key, required this.category});
  final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    final controller = BrandController.instance;
    return FutureBuilder(
        future: controller.getBrandsForCategory(category.id),
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
          final brands = snapshot.data!;
          return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: brands.length,
              itemBuilder: (_, index) {
                final brand = brands[index];
                return FutureBuilder(
                    future: controller.getBrandSpecificProducts(
                        brandId: brand.id, limit: 3),
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
                      return EBrandShowCase(
                          brand: brand,
                          image: products.map((e) => e.thumbnail).toList());
                    });
              });
        });
  }
}
