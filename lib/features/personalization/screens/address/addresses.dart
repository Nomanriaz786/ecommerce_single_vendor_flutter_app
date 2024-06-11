import 'package:ecommerce_app/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce_app/features/personalization/screens/address/add_new_address.dart';
import 'package:ecommerce_app/features/personalization/screens/address/widgets/single_address.dart';
import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserAddressScreen extends StatelessWidget {
  const UserAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: EColors.primary,
          onPressed: () => Get.to(() => const AddNewAddressScreen()),
          child: const Icon(
            Icons.add,
            color: EColors.white,
          ),
        ),
        appBar: EAppBar(
          showBackArrow: true,
          title:
              Text('Account', style: Theme.of(context).textTheme.headlineSmall),
        ),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(ESizes.defaultSpace),
            child: Column(
              children: [
                ESingleAddress(
                  selectedAddress: true,
                ),
                ESingleAddress(
                  selectedAddress: false,
                ),
              ],
            ),
          ),
        ));
  }
}
