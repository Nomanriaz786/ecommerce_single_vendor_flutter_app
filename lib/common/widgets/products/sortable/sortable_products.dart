import 'package:ecommerce_app/common/widgets/layout/grid_layout.dart';
import 'package:ecommerce_app/common/widgets/products/products_card/product_card_vertical.dart';
import 'package:ecommerce_app/features/shop/controllers/all_products_controller.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ESortableProducts extends StatelessWidget {
  const ESortableProducts({
    super.key,
    required this.products,
  });
  final List<ProductModel> products;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllProductsController());
    controller.assignProducts(products);
    return Column(
      children: [
        ///DropDown
        DropdownButtonFormField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Iconsax.sort),
          ),
          value: controller.selectedSortOption.value,
          onChanged: (value) {
            // -Sort Products
            controller.sortProducts(value!);
          },
          items: [
            "Name",
            "Higher Price",
            "Lower Price",
            "Newest",
            "Popularity",
            "Sale",
          ]
              .map(
                (option) => DropdownMenuItem(
                  value: option,
                  child: Text(option),
                ),
              )
              .toList(),
        ),
        const SizedBox(
          height: ESizes.spaceBtSections,
        ),

        ///Products
        Obx(
          () => EGridLayout(
            itemCount: controller.products.length,
            itemBuilder: (_, index) =>
                EProductCardVertical(product: controller.products[index]),
          ),
        ),
      ],
    );
  }
}
