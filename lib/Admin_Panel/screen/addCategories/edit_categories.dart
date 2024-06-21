import 'dart:io';

import 'package:ecommerce_app/features/shop/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app/features/shop/controllers/category_controller.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:ecommerce_app/util/validators/validator.dart';
import 'package:ecommerce_app/common/widgets/appbar/app_bar.dart';
import 'package:iconsax/iconsax.dart';

class EditCategories extends StatelessWidget {
  const EditCategories({super.key, required this.category});
  final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    final categoryController = CategoryController.instance;
    return Scaffold(
      appBar: EAppBar(
        showBackArrow: true,
        title: Text(
          'Update Category',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ESizes.defaultSpace),
        child: Form(
          key: categoryController.categoryFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: categoryController.name,
                validator: (value) =>
                    EValidator.validateEmptyText('Category Name', value),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.category),
                  labelText: 'Category Name',
                ),
              ),
              const SizedBox(height: ESizes.spaceBtInputFields),
              Obx(
                () => SwitchListTile(
                  title: Text(
                    'Featured',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  value: categoryController.isFeatured.value,
                  onChanged: (bool value) {
                    categoryController.isFeatured.value = value;
                  },
                  secondary: const Icon(Iconsax.star),
                ),
              ),
              const SizedBox(height: ESizes.spaceBtInputFields),
              Text(
                'Thumbnail',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: ESizes.spaceBtInputFields),
              Obx(
                () => categoryController.image.value == null
                    ? GestureDetector(
                        onTap: categoryController.pickImage,
                        child: Image.network(
                          category.image,
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      )
                    : GestureDetector(
                        onTap: categoryController.pickImage,
                        child: Image.file(
                          File(categoryController.image.value!.path),
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
                    categoryController.updateCategory(category.id, category);
                  },
                  child: const Text('Update Category'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
