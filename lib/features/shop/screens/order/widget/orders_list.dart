import 'package:ecommerce_app/common/widgets/custom_shapes/Containers/rounded_container.dart';
import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:ecommerce_app/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class EOrdersList extends StatelessWidget {
  const EOrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return ListView.separated(
      shrinkWrap: true,
      itemCount: 8,
      separatorBuilder: (_, __) => const SizedBox(
        height: ESizes.spaceBtItems,
      ),
      itemBuilder: (_, index) => ERoundedContainer(
        showBorder: true,
        backGroundColor: dark ? EColors.dark : EColors.light,
        padding: const EdgeInsets.all(ESizes.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Row 1
            Row(
              children: [
                /// 1-Icon
                const Icon(Iconsax.ship),
                const SizedBox(
                  width: ESizes.spaceBtItems / 2,
                ),

                /// 2-Date & Status
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Processing',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .apply(color: EColors.primary, fontWeightDelta: 1),
                      ),
                      Text(
                        '07 Oct, 2020',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),

                /// 3-Icon
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Iconsax.arrow_right_34,
                    size: ESizes.iconSm,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: ESizes.spaceBtItems,
            ),

            /// Row 2
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      /// 1-Icon
                      const Icon(Iconsax.tag),
                      const SizedBox(
                        width: ESizes.spaceBtItems / 2,
                      ),

                      /// 2-Date & Status
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order',
                              style: Theme.of(context).textTheme.labelMedium),
                          Text(
                            '#374466',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      /// 1-Icon
                      const Icon(Iconsax.calendar),
                      const SizedBox(
                        width: ESizes.spaceBtItems / 2,
                      ),

                      /// 2-Date & Status
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Shipping',
                              style: Theme.of(context).textTheme.labelMedium),
                          Text(
                            '03-Feb-2022',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
