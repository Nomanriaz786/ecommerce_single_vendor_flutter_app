import 'package:ecommerce_app/common/widgets/products/cart/add_remove_cart_button.dart';
import 'package:ecommerce_app/common/widgets/products/cart/cart_item.dart';
import 'package:ecommerce_app/common/widgets/text/product_price_text.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:flutter/material.dart';

class ECartItems extends StatelessWidget {
  const ECartItems({
    super.key,
    this.showAddRemoveButtons = true,
  });
  final bool showAddRemoveButtons;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 2,
      shrinkWrap: true,
      separatorBuilder: (_, __) => const SizedBox(
        height: ESizes.spaceBtSections,
      ),
      itemBuilder: (_, index) => Column(
        children: [
          ///cart item
          const ECartItem(),

          ///Add, remove button with price row
          if (showAddRemoveButtons)
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    /// extra space
                    SizedBox(
                      width: 100,
                    ),

                    ///Add, remove button
                    EProductQuantityWithAddRemoveButton(),
                  ],
                ),

                ///price of product
                EProductPriceText(price: '250'),
              ],
            ),
        ],
      ),
    );
  }
}
