import 'package:ecommerce_app/common/widgets/text/section_heading.dart';
import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:flutter/material.dart';

class EBillingAddressSection extends StatelessWidget {
  const EBillingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ESectionHeading(
          title: 'Shipping Address',
          buttonTitle: 'Change',
          onPressed: () {},
        ),
        Text(
          'Noman Riaz',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(
          height: ESizes.spaceBtItems / 2,
        ),
        Row(
          children: [
            const Icon(
              Icons.phone,
              color: EColors.grey,
              size: 16,
            ),
            const SizedBox(
              width: ESizes.spaceBtItems,
            ),
            Text(
              '03003434432',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(
          height: ESizes.spaceBtItems / 2,
        ),
        Row(
          children: [
            const Icon(
              Icons.location_history,
              color: EColors.grey,
              size: 16,
            ),
            const SizedBox(
              width: ESizes.spaceBtItems,
            ),
            Expanded(
              child: Text(
                'chak no 9/3.R, haroon bad,Bahawalnagar',
                style: Theme.of(context).textTheme.bodyMedium,
                softWrap: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
