import 'dart:io';
import 'package:ecommerce_app/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce_app/features/shop/controllers/product/product_controller.dart';
import 'package:ecommerce_app/features/shop/models/brand_model.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:ecommerce_app/util/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AddNewProductScreen extends StatelessWidget {
  const AddNewProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.put(ProductController());
    return Scaffold(
      appBar: EAppBar(
        showBackArrow: true,
        title: Text(
          'Add New Product',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ESizes.defaultSpace),
        child: Form(
          key: productController.productFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Product Details',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: ESizes.spaceBtInputFields),
              TextFormField(
                controller: productController.title,
                validator: (value) =>
                    EValidator.validateEmptyText('Title', value),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.tag),
                  labelText: 'Title',
                ),
              ),
              const SizedBox(height: ESizes.spaceBtInputFields),
              TextFormField(
                controller: productController.description,
                validator: (value) =>
                    EValidator.validateEmptyText('Description', value),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.text),
                  labelText: 'Description',
                ),
              ),
              const SizedBox(height: ESizes.spaceBtInputFields),
              TextFormField(
                controller: productController.price,
                validator: (value) =>
                    EValidator.validateEmptyText('Price', value),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.money),
                  labelText: 'Price',
                ),
              ),
              const SizedBox(height: ESizes.spaceBtInputFields),
              TextFormField(
                controller: productController.salePrice,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.discount),
                  labelText: 'Sale Price',
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final salePrice = double.tryParse(value);
                    final price = double.tryParse(productController.price.text);
                    if (salePrice != null &&
                        price != null &&
                        salePrice >= price) {
                      return 'Sale Price should be less than Price';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: ESizes.spaceBtInputFields),
              TextFormField(
                controller: productController.stock,
                validator: (value) =>
                    EValidator.validateEmptyText('Stock', value),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.box),
                  labelText: 'Stock',
                ),
              ),
              const SizedBox(height: ESizes.spaceBtInputFields),
              TextFormField(
                controller: productController.productType,
                validator: (value) =>
                    EValidator.validateEmptyText('Product Type', value),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.box),
                  labelText: 'Product Type',
                ),
              ),
              const SizedBox(
                height: ESizes.spaceBtInputFields,
              ),
              // Brand Selection Dropdown
              FutureBuilder<List<BrandModel>>(
                future: productController.fetchBrands(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return Obx(
                      () => DropdownButtonFormField<BrandModel>(
                        // Change to BrandModel
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.branding_watermark),
                          labelText: 'Brand',
                        ),
                        value: productController.selectedBrand.value,
                        items: snapshot.data!.map((brand) {
                          return DropdownMenuItem<BrandModel>(
                            // Change to BrandModel
                            value: brand,
                            child: Text(brand.name),
                          );
                        }).toList(),
                        onChanged: (BrandModel? newValue) {
                          // Change to BrandModel?
                          productController.selectedBrand.value = newValue;
                        },
                        validator: (value) => EValidator.validateEmptyText(
                            'Brand', value as String?),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              const SizedBox(height: ESizes.spaceBtInputFields), // Add spacing

              // Category Selection Dropdown
              Obx(
                () => DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.category),
                    labelText: 'Category',
                  ),
                  value: productController.selectedCategory.value.isNotEmpty
                      ? productController.selectedCategory.value
                      : null,
                  items: productController.categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    productController.selectedCategory.value = newValue ?? '';
                  },
                  validator: (value) =>
                      EValidator.validateEmptyText('Category', value),
                ),
              ),
              const SizedBox(height: ESizes.spaceBtInputFields),
              Obx(
                () => SwitchListTile(
                  title: Text(
                    'Featured',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  value: productController.isFeatured.value,
                  onChanged: (bool value) {
                    productController.isFeatured.value = value;
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
                () => productController.thumbnail.value == null
                    ? IconButton(
                        icon: const Icon(Iconsax.image),
                        onPressed: productController.pickImage,
                        iconSize: 50,
                      )
                    : GestureDetector(
                        onTap: productController.pickImage,
                        child: Image.file(
                          File(productController.thumbnail.value!.path),
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
                    productController.addNewProduct();
                  },
                  child: const Text('Add Product'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
