import 'package:ecommerce_app/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:ecommerce_app/util/constants/image_strings.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:ecommerce_app/util/constants/text_strings.dart';
import 'package:ecommerce_app/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// title
              Text(
                ETextStrings.signUpTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: ESizes.spaceBtSections,
              ),

              /// Form
              ESignUpForm(dark: dark),
              const SizedBox(
                height: ESizes.spaceBtSections,
              ),

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
                      onPressed: () {},
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
