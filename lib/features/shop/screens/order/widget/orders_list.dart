import 'package:ecommerce_app/bottom_navigation_bar.dart';
import 'package:ecommerce_app/common/widgets/custom_shapes/Containers/rounded_container.dart';
import 'package:ecommerce_app/common/widgets/loaders/animation_loader_widget.dart';
import 'package:ecommerce_app/common/widgets/shimmers/list_tile_shimmer.dart';
import 'package:ecommerce_app/features/shop/controllers/product/order_controller.dart';
import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:ecommerce_app/util/constants/image_strings.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:ecommerce_app/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class EOrdersList extends StatelessWidget {
  const EOrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.put(OrderController());
    final dark = EHelperFunctions.isDarkMode(context);
    return FutureBuilder(
        future: orderController.fetchUserOrders(),
        builder: (_, snapshot) {
          const loader = EListTileShimmer();
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loader;
          }
          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return EAnimationOverlayWidget(
              text: 'Whoops! No Orders Yet!',
              animation: EImages.pencilAnimation,
              showAction: true,
              actionText: 'Let\'s fill it',
              onActionPressed: () => Get.to(() => const BottomNavigation()),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          final orders = snapshot.data!;
          return ListView.separated(
              shrinkWrap: true,
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(
                    height: ESizes.spaceBtItems,
                  ),
              itemBuilder: (_, index) {
                final order = orders[index];
                return ERoundedContainer(
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
                                  order.orderStatusText,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .apply(
                                          color: EColors.primary,
                                          fontWeightDelta: 1),
                                ),
                                Text(
                                  order.formattedOrderDate,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium),
                                    Text(
                                      order.id,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium),
                                    Text(
                                      order.formattedDeliveryDate,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
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
                );
              });
        });
  }
}
