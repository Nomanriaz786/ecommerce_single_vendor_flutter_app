import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:ecommerce_app/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/custom_shapes/Containers/rounded_container.dart';

class ESingleAddress extends StatelessWidget {
  const ESingleAddress({
    super.key,
    required this.selectedAddress,
  });
  final bool selectedAddress;

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return ERoundedContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(ESizes.md),
      showBorder: true,
      backGroundColor: selectedAddress
          ? EColors.primary.withOpacity(0.5)
          : Colors.transparent,
      borderColor: selectedAddress
          ? Colors.transparent
          : dark
              ? EColors.darkGrey
              : EColors.grey,
      margin: const EdgeInsets.only(bottom: ESizes.spaceBtItems),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 5,
            child: Icon(
              selectedAddress ? Iconsax.tick_circle5 : null,
              color: selectedAddress
                  ? dark
                      ? EColors.light
                      : EColors.dark
                  : null,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Noman Riaz',
                style: Theme.of(context).textTheme.titleLarge,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(
                height: ESizes.sm / 2,
              ),
              const Text(
                '03003434432',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(
                height: ESizes.sm / 2,
              ),
              const Text(
                'chak no 9/3.R,Haroonabad,Bahawalnagar',
                softWrap: true,
              ),
              const SizedBox(
                height: ESizes.sm / 2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
