import 'package:ecommerce_app/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce_app/common/widgets/custom_shapes/Containers/rounded_container.dart';
import 'package:ecommerce_app/common/widgets/products/cart/coupon_widget.dart';
import 'package:ecommerce_app/common/widgets/success_screens/success_screen_1.dart';
import 'package:ecommerce_app/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:ecommerce_app/features/shop/screens/checkout/widgets/biiling_amount_section.dart';
import 'package:ecommerce_app/features/shop/screens/checkout/widgets/billing_address_section.dart';
import 'package:ecommerce_app/features/shop/screens/checkout/widgets/billing_payment_section.dart';
import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:ecommerce_app/util/constants/image_strings.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:ecommerce_app/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../bottom_navigation_bar.dart';

class CheckOutScreen extends StatelessWidget {
  const CheckOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: EAppBar(
        showBackArrow: true,
        title: Text(
          'Order Review',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            children: [
              /// Items in Cart
              const ECartItems(
                showAddRemoveButtons: false,
              ),
              const SizedBox(
                height: ESizes.spaceBtSections,
              ),

              /// Coupon TextField
              const ECouponWidget(),
              const SizedBox(
                height: ESizes.spaceBtSections,
              ),

              ///Billing Section
              ERoundedContainer(
                showBorder: true,
                padding: const EdgeInsets.all(ESizes.defaultSpace),
                backGroundColor: dark ? EColors.dark : EColors.white,
                child: const Column(
                  children: [
                    ///price total
                    EBillingAmountSection(),
                    SizedBox(
                      height: ESizes.spaceBtItems,
                    ),

                    ///divider
                    Divider(),
                    SizedBox(
                      height: ESizes.spaceBtItems,
                    ),

                    ///Payment methods
                    EBillingPaymentSection(),
                    SizedBox(
                      height: ESizes.spaceBtItems,
                    ),

                    ///Address
                    EBillingAddressSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      /// checkout button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(ESizes.defaultSpace),
        child: ElevatedButton(
          onPressed: () => Get.to(
            () => SuccessScreen(
              image: EImages.successfulPaymentIcon,
              title: 'Payment Success!',
              subtitle: 'Your Product is Shipped Soon',
              onPressed: () => Get.offAll(() => const BottomNavigation()),
            ),
          ),
          child: const Text('Checkout'),
        ),
      ),
    );
  }
}
