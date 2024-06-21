import 'dart:io';

import 'package:ecommerce_app/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:ecommerce_app/util/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app/features/shop/controllers/brand_controller.dart';
import 'package:ecommerce_app/features/shop/models/brand_model.dart';

class EditBrands extends StatelessWidget {
  const EditBrands({super.key, required this.brand});
  final BrandModel brand;
  @override
  Widget build(BuildContext context) {
    final brandController = BrandController.instance;
    return Scaffold(
      appBar: EAppBar(
        showBackArrow: true,
        title: Text(
          'Update Brand',
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
                Text(
                  'Thumbnail',
                  style: Theme.of(context).textTheme.titleLarge,
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
                const SizedBox(
                  height: ESizes.spaceBtInputFields,
                ),
                Obx(
                  () => brandController.image.value == null
                      ? GestureDetector(
                          onTap: brandController.pickImage,
                          child: Image.network(
                            brand.image,
                            width: 100,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
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
                const SizedBox(height: ESizes.spaceBtInputFields * 2),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      brandController.updateBrand(brand.id, brand);
                      brandController.refreshData;
                    },
                    child: const Text('Update Brand'),
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
