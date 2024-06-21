import 'package:ecommerce_app/bottom_navigation_bar.dart';
import 'package:ecommerce_app/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce_app/common/widgets/loaders/animation_loader_widget.dart';
import 'package:ecommerce_app/features/shop/controllers/product/cart_controller.dart';
import 'package:ecommerce_app/features/shop/screens/checkout/checkout.dart';
import 'package:ecommerce_app/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:ecommerce_app/util/constants/image_strings.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    return Scaffold(
      appBar: EAppBar(
        showBackArrow: true,
        title: Text(
          'Cart',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          final emptyWidget = EAnimationOverlayWidget(
            text: 'Whoops cart is empty',
            animation: EImages.cartAnimation,
            showAction: true,
            actionText: 'Let\'s fill it',
            onActionPressed: () => Get.off(() => const BottomNavigation()),
          );
          if (cartController.cartItems.isEmpty) {
            return emptyWidget;
          } else {
            return const Padding(
              padding: EdgeInsets.all(ESizes.defaultSpace),

              ///items in cart
              child: ECartItems(),
            );
          }
        }),
      ),
      bottomNavigationBar: cartController.cartItems.isEmpty
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.all(ESizes.defaultSpace),
              child: ElevatedButton(
                onPressed: () => Get.to(() => const CheckOutScreen()),
                child: Obx(() =>
                    Text('Checkout \$${cartController.totalCartPrice.value}')),
              ),
            ),
    );
  }
}
