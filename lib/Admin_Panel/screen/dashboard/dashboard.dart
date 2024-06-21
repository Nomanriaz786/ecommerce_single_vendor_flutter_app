import 'package:ecommerce_app/Admin_Panel/controller/dashboard_controller.dart';
import 'package:ecommerce_app/Admin_Panel/screen/addBrands/display_brands.dart';
import 'package:ecommerce_app/Admin_Panel/screen/addCategories/display_categories.dart';
import 'package:ecommerce_app/Admin_Panel/screen/addProducts/display_products.dart';
import 'package:ecommerce_app/Admin_Panel/screen/dashboard/widgets/dashboard_card.dart';
import 'package:ecommerce_app/Admin_Panel/screen/manage_users/display_all_users.dart';
import 'package:ecommerce_app/bottom_navigation_bar.dart';
import 'package:ecommerce_app/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.put(DashboardController());
    return Scaffold(
      appBar: EAppBar(
        title: Text(
          'Admin Dashboard',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(ESizes.defaultSpace),
        child: Obx(
          () => Column(
            children: [
              Expanded(
                // Use Expanded to fill available space
                child: GridView.count(
                  crossAxisCount: 2, // Two columns
                  crossAxisSpacing: ESizes.defaultSpace,
                  mainAxisSpacing: ESizes.defaultSpace,
                  children: [
                    DashboardCard(
                      title: 'Users',
                      value: '${dashboardController.noOfUsers}',
                      icon: Iconsax.user,
                      onTap: () => Get.to(() => const DisplayUsersScreen()),
                    ),
                    DashboardCard(
                      title: 'Brands',
                      value: '${dashboardController.noOfBrands}',
                      icon: Iconsax.tag,
                      onTap: () => Get.to(() => const DisplayBrands()),
                    ),
                    DashboardCard(
                      title: 'Categories',
                      value: '${dashboardController.noOfCategories}',
                      icon: Iconsax.category,
                      onTap: () => Get.to(() => const DisplayCategories()),
                    ),
                    DashboardCard(
                      title: 'Products',
                      value: '${dashboardController.noOfProducts}',
                      icon: Iconsax.shop,
                      onTap: () => Get.to(() => const DisplayProducts()),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: ESizes.defaultSpace),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        EColors.primary, // Use your color constants
                    padding: const EdgeInsets.symmetric(vertical: ESizes.sm),
                  ),
                  onPressed: () => Get.to(() => const BottomNavigation()),
                  child: const Text(
                    'User Side',
                    style: TextStyle(fontSize: ESizes.md),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
