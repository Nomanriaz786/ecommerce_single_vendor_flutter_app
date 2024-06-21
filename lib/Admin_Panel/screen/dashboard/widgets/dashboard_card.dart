import 'package:ecommerce_app/common/widgets/custom_shapes/Containers/rounded_container.dart';
import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:ecommerce_app/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.onTap,
  });
  final String title;
  final String value;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return ERoundedContainer(
      backGroundColor: dark ? EColors.light : EColors.dark,
      child: InkWell(
        // Wrap in InkWell for tap functionality
        onTap: onTap,
        borderRadius: BorderRadius.circular(ESizes.borderRadiusLg),
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30,
                color: dark ? EColors.dark : EColors.light,
              ),
              const SizedBox(height: ESizes.sm),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium!.apply(
                      color: dark ? EColors.dark : EColors.light,
                    ),
              ),
              const SizedBox(height: ESizes.sm),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: EColors.secondary, // Use your color constants
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
