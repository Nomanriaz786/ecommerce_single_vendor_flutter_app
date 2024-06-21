import 'package:ecommerce_app/Admin_Panel/screen/addProducts/add_products.dart';
import 'package:ecommerce_app/Admin_Panel/screen/addProducts/edit_product.dart';
import 'package:ecommerce_app/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce_app/common/widgets/images/e_circular_image.dart';
import 'package:ecommerce_app/common/widgets/loaders/circular_loader.dart';
import 'package:ecommerce_app/features/shop/controllers/product/product_controller.dart';
import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DisplayProducts extends StatelessWidget {
  const DisplayProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = ProductController.instance;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: EColors.primary,
        onPressed: () => Get.to(() => const AddNewProductScreen()),
        child: const Icon(
          Icons.add,
          color: EColors.white,
        ),
      ),
      appBar: EAppBar(
        showBackArrow: true,
        title: Text(
          'All Products',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Obx(
            () => FutureBuilder(
              key: Key(productController.refreshData.value.toString()),
              future: productController.fetchAllProducts(),
              builder: (_, snapshot) {
                const loader = ECircularLoader();
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return loader;
                }
                if (!snapshot.hasData ||
                    snapshot.data == null ||
                    snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No Data Found'),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                }
                final products = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  itemBuilder: (_, index) {
                    final product = products[index];
                    return Card(
                      child: ListTile(
                        leading: ECircularImage(
                          isNetworkImage: true,
                          image: product.thumbnail,
                        ),
                        title: Text(
                          product.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                          '\$${product.price.toString()}',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Get.to(
                                    () => EditProductScreen(product: product));
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await productController
                                    .deleteProduct(product.id);
                                productController.refreshData;
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
