import 'package:ecommerce_app/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce_app/common/widgets/images/e_circular_image.dart';
import 'package:ecommerce_app/common/widgets/text/section_heading.dart';
import 'package:ecommerce_app/features/personalization/controllers/user_controller.dart';
import 'package:ecommerce_app/features/personalization/screens/profile/widgets/change_name.dart';
import 'package:ecommerce_app/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:ecommerce_app/util/constants/image_strings.dart';
import 'package:ecommerce_app/common/widgets/shimmers/shimmer.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: EAppBar(
        title:
            Text('Profile', style: Theme.of(context).textTheme.headlineSmall),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Obx(() {
                      final networkImage = controller.user.value.profilePicture;
                      final image =
                          networkImage.isNotEmpty ? networkImage : EImages.user;
                      return controller.imageLoading.value
                          ? const EShimmerEffect(
                              width: 80,
                              height: 80,
                              radius: 80,
                            )
                          : ECircularImage(
                              image: image,
                              isNetworkImage: true,
                              width: 80,
                              height: 80,
                            );
                    }),
                    TextButton(
                      onPressed: () => controller.uploadUserProfilePicture(),
                      child: const Text('Change your profile picture'),
                    ),
                    const SizedBox(
                      height: ESizes.spaceBtItems / 2,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: ESizes.spaceBtItems,
                    ),
                    const ESectionHeading(
                      title: 'Profile Information',
                      showActionButton: false,
                    ),
                    const SizedBox(
                      height: ESizes.spaceBtItems,
                    ),
                    EProfileMenu(
                      title: 'Name',
                      value: controller.user.value.fullName,
                      onPressed: () => Get.to(() => const ChangeName()),
                    ),
                    EProfileMenu(
                      title: 'Username',
                      value: controller.user.value.userName,
                      onPressed: () {},
                    ),
                    const SizedBox(
                      height: ESizes.spaceBtItems,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: ESizes.spaceBtItems,
                    ),
                    const ESectionHeading(
                      title: 'Personal Information',
                      showActionButton: false,
                    ),
                    const SizedBox(
                      height: ESizes.spaceBtItems,
                    ),
                    EProfileMenu(
                      title: 'User ID',
                      value: controller.user.value.id,
                      icon: Iconsax.copy,
                      onPressed: () {},
                    ),
                    EProfileMenu(
                      title: 'Email',
                      value: controller.user.value.email,
                      onPressed: () {},
                    ),
                    EProfileMenu(
                      title: 'Phone Number',
                      value: controller.user.value.phoneNumber,
                      onPressed: () {},
                    ),
                    EProfileMenu(
                      title: 'Gender',
                      value: 'Male',
                      onPressed: () {},
                    ),
                    EProfileMenu(
                      title: 'Date of Birth',
                      value: '01/01/2002',
                      onPressed: () {},
                    ),
                    const Divider(),
                    const SizedBox(
                      height: ESizes.spaceBtItems,
                    ),
                    TextButton(
                      onPressed: () => controller.deleteAccountWarningPopUp(),
                      child: const Text(
                        'Delete Account',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
