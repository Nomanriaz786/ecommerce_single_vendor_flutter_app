import 'package:ecommerce_app/features/authentication/controllers/signup/signup_controller.dart';
import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:ecommerce_app/util/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/util/constants/text_strings.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ESignUpForm extends StatelessWidget {
  const ESignUpForm({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          /// First Name & Last Name
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  expands: false,
                  controller: controller.firstName,
                  validator: (value) =>
                      EValidator.validateEmptyText('First Name', value),
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.user),
                      labelText: ETextStrings.firstName),
                ),
              ),
              const SizedBox(
                width: ESizes.spaceBtInputFields,
              ),
              Expanded(
                child: TextFormField(
                  controller: controller.lastName,
                  validator: (value) =>
                      EValidator.validateEmptyText('Last Name', value),
                  expands: false,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.user),
                      labelText: ETextStrings.lastName),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: ESizes.spaceBtInputFields,
          ),

          /// Username
          TextFormField(
            controller: controller.username,
            validator: (value) =>
                EValidator.validateEmptyText('User Name', value),
            decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.user_edit),
                labelText: ETextStrings.username),
          ),
          const SizedBox(
            height: ESizes.spaceBtInputFields,
          ),

          /// Email
          TextFormField(
            controller: controller.email,
            validator: (value) => EValidator.validateEmail(value),
            decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct),
                labelText: ETextStrings.email),
          ),
          const SizedBox(
            height: ESizes.spaceBtInputFields,
          ),

          /// Phone Number
          TextFormField(
            controller: controller.phone,
            validator: (value) => EValidator.validatePhoneNumber(value),
            decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.call),
                labelText: ETextStrings.phoneNo),
          ),
          const SizedBox(
            height: ESizes.spaceBtInputFields,
          ),

          /// Password
          Obx(
            () => TextFormField(
              controller: controller.password,
              validator: (value) => EValidator.validatePassword(value),
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value =
                        !controller.hidePassword.value,
                    icon: Icon(controller.hidePassword.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye),
                  ),
                  labelText: ETextStrings.password),
            ),
          ),
          const SizedBox(
            height: ESizes.spaceBtSections,
          ),

          /// Privacy and Policy
          Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Obx(
                  () => Checkbox(
                    value: controller.privacyPolicy.value,
                    onChanged: (value) => controller.privacyPolicy.value =
                        !controller.privacyPolicy.value,
                  ),
                ),
              ),
              const SizedBox(
                width: ESizes.spaceBtItems,
              ),
              Expanded(
                child: Text.rich(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: ETextStrings.iAgreeTo,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: ETextStrings.privacyPolicy,
                        style: Theme.of(context).textTheme.bodyMedium!.apply(
                              color: dark ? EColors.white : EColors.primary,
                              decoration: TextDecoration.underline,
                              decorationColor:
                                  dark ? EColors.white : EColors.primary,
                            ),
                      ),
                      TextSpan(
                          text: ETextStrings.and,
                          style: Theme.of(context).textTheme.bodySmall),
                      TextSpan(
                        text: ETextStrings.termsOfUse,
                        style: Theme.of(context).textTheme.bodyMedium!.apply(
                              color: dark ? EColors.white : EColors.primary,
                              decoration: TextDecoration.underline,
                              decorationColor:
                                  dark ? EColors.white : EColors.primary,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: ESizes.spaceBtSections,
          ),

          /// Sign Up Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.signup(),
              child: const Text(ETextStrings.createAccount),
            ),
          ),
        ],
      ),
    );
  }
}
