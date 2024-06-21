import 'dart:io';

import 'package:ecommerce_app/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:ecommerce_app/util/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app/features/shop/controllers/brand_controller.dart';

class AddNewBrandScreen extends StatelessWidget {
  const AddNewBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brandController = BrandController.instance;
    return Scaffold(
      appBar: EAppBar(
        showBackArrow: true,
        title: Text(
          'Add New Brand',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Form(
            key: brandController.brandFormKey,
            child: Column(
              children: [
                TextFormField(
                  controller: brandController.name,
                  validator: (value) =>
                      EValidator.validateEmptyText('Name', value),
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.user), labelText: 'Name'),
                ),
                const SizedBox(
                  height: ESizes.spaceBtInputFields,
                ),
                TextFormField(
                  controller: brandController.productCount,
                  validator: (value) =>
                      EValidator.validateEmptyText('Product Count', value),
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.box),
                      labelText: 'Product Count'),
                ),
                const SizedBox(height: ESizes.spaceBtInputFields),
                Obx(
                  () => SwitchListTile(
                    title: Text(
                      'Featured',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    value: brandController.isFeatured.value,
                    onChanged: (bool value) {
                      brandController.isFeatured.value = value;
                    },
                    secondary: const Icon(Iconsax.star),
                  ),
                ),
                const SizedBox(height: ESizes.spaceBtInputFields),
                Text(
                  'Thumbnail',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: ESizes.spaceBtInputFields,
                ),
                Obx(
                  () => brandController.image.value == null
                      ? IconButton(
                          icon: const Icon(Iconsax.image),
                          onPressed: brandController.pickImage,
                          iconSize: 50,
                        )
                      : GestureDetector(
                          onTap: brandController.pickImage,
                          child: Image.file(
                            File(brandController.image.value!.path),
                            width: 100,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                        ),
                ),
                const SizedBox(
                  height: ESizes.spaceBtInputFields * 2,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      brandController.addNewBrand();
                    },
                    child: const Text('Add Brand'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
