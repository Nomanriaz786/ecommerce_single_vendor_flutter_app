import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce_app/features/personalization/controllers/user_controller.dart';
import 'package:ecommerce_app/features/personalization/models/user_model.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:ecommerce_app/util/validators/validator.dart';
import 'package:iconsax/iconsax.dart';

class EditUserScreen extends StatelessWidget {
  const EditUserScreen({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.put(UserController());
    userController.loadUser(user);
    return Scaffold(
      appBar: EAppBar(
        showBackArrow: true,
        title: Text(
          'Edit User',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ESizes.defaultSpace),
        child: Form(
          key: userController.userFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User Details',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: ESizes.spaceBtInputFields),
              TextFormField(
                controller: userController.firstName,
                validator: (value) =>
                    EValidator.validateEmptyText('First Name', value),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.user),
                  labelText: 'First Name',
                ),
              ),
              const SizedBox(height: ESizes.spaceBtInputFields),
              TextFormField(
                controller: userController.lastName,
                validator: (value) =>
                    EValidator.validateEmptyText('Last Name', value),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.user),
                  labelText: 'Last Name',
                ),
              ),
              const SizedBox(height: ESizes.spaceBtInputFields),
              TextFormField(
                controller: userController.email,
                validator: (value) => EValidator.validateEmail(value),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: ESizes.spaceBtInputFields),
              TextFormField(
                controller: userController.phoneNumber,
                validator: (value) =>
                    EValidator.validateEmptyText('Phone Number', value),
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  labelText: 'Phone Number',
                ),
              ),
              const SizedBox(height: ESizes.spaceBtInputFields),
              const SizedBox(height: ESizes.spaceBtInputFields),
              Text(
                'Roles',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              GetBuilder<UserController>(
                builder: (controller) => Wrap(
                  spacing: 8.0,
                  children: userController.availableRoles.map((role) {
                    return ChoiceChip(
                      label: Text(role),
                      selected: controller.selectedRoles.contains(role),
                      onSelected: (isSelected) {
                        if (isSelected) {
                          controller.selectedRoles.add(role);
                        } else {
                          controller.selectedRoles.remove(role);
                        }
                        controller.update(); // Force a rebuild
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: ESizes.spaceBtInputFields * 2),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    userController.updateUser(user.id, user);
                    userController.refreshData();
                  },
                  child: const Text('Update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
