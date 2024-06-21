import 'package:ecommerce_app/common/widgets/custom_shapes/Containers/rounded_container.dart';
import 'package:ecommerce_app/common/widgets/text/section_heading.dart';
import 'package:ecommerce_app/features/shop/controllers/product/checkout_controller.dart';
import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:ecommerce_app/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EBillingPaymentSection extends StatelessWidget {
  const EBillingPaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final checkoutController = CheckoutController.instance;
    final dark = EHelperFunctions.isDarkMode(context);
    return Column(
      children: [
        ESectionHeading(
          title: 'Payment Methods',
          buttonTitle: 'Change',
          onPressed: () => checkoutController.selectPaymentMethod(context),
        ),
        const SizedBox(
          height: ESizes.spaceBtItems / 2,
        ),
        Obx(
          () => Row(
            children: [
              ERoundedContainer(
                width: 60,
                height: 35,
                backGroundColor: dark ? EColors.light : EColors.white,
                padding: const EdgeInsets.all(ESizes.sm),
                child: Image(
                  image: AssetImage(
                      checkoutController.selectedPaymentMethod.value.image),
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                checkoutController.selectedPaymentMethod.value.name,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
