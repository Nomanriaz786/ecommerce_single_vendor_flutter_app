import 'package:ecommerce_app/common/widgets/icons/circular_icon.dart';
import 'package:ecommerce_app/features/shop/controllers/product/cart_controller.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:ecommerce_app/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class EBottomAddToCart extends StatelessWidget {
  const EBottomAddToCart({super.key, required this.product});
  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    cartController.updateAlreadyAddedProductCount(product);
    final dark = EHelperFunctions.isDarkMode(context);
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: ESizes.spaceBtItems, vertical: ESizes.spaceBtItems / 2),
      decoration: BoxDecoration(
        color: dark ? EColors.darkerGrey : EColors.light,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(ESizes.cardRadiusMd),
          bottomRight: Radius.circular(ESizes.productImageRadius),
        ),
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ECircularIcon(
                  icon: Iconsax.minus,
                  backgroundColor: EColors.darkGrey,
                  color: EColors.white,
                  width: 40,
                  height: 40,
                  onPressed: () =>
                      cartController.productQuantityInCart.value <= 1
                          ? null
                          : cartController.productQuantityInCart.value -= 1,
                ),
                const SizedBox(
                  width: ESizes.spaceBtItems,
                ),
                Text(
                  cartController.productQuantityInCart.value.toString(),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(
                  width: ESizes.spaceBtItems,
                ),
                ECircularIcon(
                  icon: Iconsax.add,
                  backgroundColor: EColors.black,
                  color: EColors.white,
                  width: 40,
                  height: 40,
                  onPressed: () =>
                      cartController.productQuantityInCart.value += 1,
                ),
              ],
            ),
            ElevatedButton(
              onPressed: cartController.productQuantityInCart.value < 1
                  ? null
                  : () => cartController.addToCart(product),
              style: ElevatedButton.styleFrom(
                backgroundColor: cartController.productQuantityInCart.value > 1
                    ? EColors.black
                    : EColors.grey,
                padding: const EdgeInsets.all(ESizes.md),
                side: const BorderSide(color: EColors.black),
              ),
              child: Text(
                'Add to Cart',
                style: TextStyle(
                  color: cartController.productQuantityInCart.value < 1
                      ? EColors.black
                      : EColors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
