import 'package:ecommerce_app/common/styles/e_spacing_style.dart';
import 'package:ecommerce_app/features/authentication/controllers/login/login_controller.dart';
import 'package:ecommerce_app/features/authentication/screens/login/widgets/login_form.dart';
import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:ecommerce_app/util/constants/image_strings.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:ecommerce_app/util/constants/text_strings.dart';
import 'package:ecommerce_app/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final dark = EHelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: ESpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              /// logo , title , subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    height: 150,
                    image: AssetImage(
                        dark ? EImages.darkAppLogo : EImages.lightAppLogo),
                  ),
                  Text(
                    ETextStrings.loginTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: ESizes.sm,
                  ),
                  Text(
                    ETextStrings.loginSubTitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),

              /// Form
              const ELoginForm(),

              /// Divider
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Divider(
                      color: dark ? EColors.darkerGrey : EColors.dark,
                      thickness: 0.5,
                    ),
                  ),
                  Text(
                    ETextStrings.orSignInWith.capitalize!,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Flexible(
                    child: Divider(
                      color: dark ? EColors.darkerGrey : EColors.dark,
                      thickness: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: ESizes.spaceBtSections,
              ),

              /// Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: EColors.grey)),
                    child: IconButton(
                      onPressed: () => controller.signInWithGoogle(),
                      icon: const Image(
                        width: ESizes.iconMd,
                        height: ESizes.iconMd,
                        image: AssetImage(EImages.google),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: ESizes.spaceBtItems,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: EColors.grey)),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Image(
                        width: ESizes.iconMd,
                        height: ESizes.iconMd,
                        image: AssetImage(EImages.facebook),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
