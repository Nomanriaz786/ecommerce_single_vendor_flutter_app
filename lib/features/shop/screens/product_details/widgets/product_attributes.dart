import 'package:ecommerce_app/common/widgets/chips/choice_chips.dart';
import 'package:ecommerce_app/common/widgets/custom_shapes/Containers/rounded_container.dart';
import 'package:ecommerce_app/common/widgets/text/product_price_text.dart';
import 'package:ecommerce_app/common/widgets/text/product_title_text.dart';
import 'package:ecommerce_app/common/widgets/text/section_heading.dart';
import 'package:ecommerce_app/features/shop/controllers/product/variation_controller.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:ecommerce_app/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EProductAttributes extends StatelessWidget {
  const EProductAttributes({super.key, required this.product});
  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VariationController());
    final dark = EHelperFunctions.isDarkMode(context);
    return Obx(
      () => Column(
        children: [
          /// Selected attribute pricing & description
          if (controller.selectedVariation.value.id.isNotEmpty)
            ERoundedContainer(
              padding: const EdgeInsets.all(ESizes.md),
              backGroundColor: dark ? EColors.darkerGrey : EColors.grey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// title, price, stock status
                  Row(
                    children: [
                      const ESectionHeading(
                        title: 'Variation',
                        showActionButton: false,
                      ),
                      const SizedBox(
                        width: ESizes.spaceBtItems,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const EProductTitleText(
                                title: 'Price',
                                smallSize: true,
                              ),
                              const SizedBox(
                                width: ESizes.spaceBtItems,
                              ),

                              /// Actual Price
                              if (controller
                                      .selectedVariation.value.salesPrice >
                                  0)
                                Text(
                                  '\$${controller.selectedVariation.value.price}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .apply(
                                          decoration:
                                              TextDecoration.lineThrough),
                                ),
                              const SizedBox(
                                width: ESizes.spaceBtItems,
                              ),

                              /// Sale Price
                              EProductPriceText(
                                  price: controller.getVariationPrice()),
                              const SizedBox(
                                width: ESizes.spaceBtItems,
                              ),
                            ],
                          ),

                          /// stock
                          Row(
                            children: [
                              const EProductTitleText(
                                title: 'Stock',
                                smallSize: true,
                              ),
                              const SizedBox(
                                width: ESizes.spaceBtItems,
                              ),
                              Text(
                                controller.variationStockStatus.value,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  EProductTitleText(
                    title: controller.selectedVariation.value.description ?? '',
                    maxLines: 4,
                    smallSize: true,
                  ),
                ],
              ),
            ),
          const SizedBox(
            height: ESizes.spaceBtItems,
          ),

          ///Attributes
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: product.productAttributes!
                .map(
                  (attributes) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ESectionHeading(title: attributes.name ?? ''),
                      const SizedBox(
                        height: ESizes.spaceBtItems / 2,
                      ),
                      Obx(
                        () => Wrap(
                          spacing: 8,
                          children: attributes.values!.map((attributeValue) {
                            final isSelected = controller
                                    .selectedAttributes[attributes.name] ==
                                attributeValue;
                            final available = controller
                                .getAttributesAvailabilityInVariation(
                                    product.productVariations!,
                                    attributes.name!)
                                .contains(attributeValue);
                            return EChoiceChips(
                              text: attributeValue,
                              selected: isSelected,
                              onSelected: available
                                  ? (selected) {
                                      if (selected && available) {
                                        controller.onAttributeSelected(
                                            product,
                                            attributes.name ?? '',
                                            attributeValue);
                                      }
                                    }
                                  : null,
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
