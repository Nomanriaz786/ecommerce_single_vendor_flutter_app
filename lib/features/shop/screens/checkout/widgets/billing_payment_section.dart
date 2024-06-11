import 'package:ecommerce_app/common/widgets/custom_shapes/Containers/rounded_container.dart';
import 'package:ecommerce_app/common/widgets/text/section_heading.dart';
import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:ecommerce_app/util/constants/image_strings.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:ecommerce_app/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class EBillingPaymentSection extends StatelessWidget {
  const EBillingPaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Column(
      children: [
        ESectionHeading(
          title: 'Payment Methods',
          buttonTitle: 'Change',
          onPressed: () {},
        ),
        const SizedBox(
          height: ESizes.spaceBtItems / 2,
        ),
        Row(
          children: [
            ERoundedContainer(
              width: 60,
              height: 35,
              backGroundColor: dark ? EColors.light : EColors.white,
              padding: const EdgeInsets.all(ESizes.sm),
              child: const Image(
                image: AssetImage(EImages.paypal),
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
