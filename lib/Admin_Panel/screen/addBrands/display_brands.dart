import 'package:ecommerce_app/Admin_Panel/screen/addBrands/edit_brands.dart';
import 'package:ecommerce_app/common/widgets/images/e_circular_image.dart';
import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:ecommerce_app/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app/Admin_Panel/screen/addBrands/add_brands.dart';
import 'package:ecommerce_app/features/shop/controllers/brand_controller.dart';
import 'package:ecommerce_app/common/widgets/loaders/circular_loader.dart';
import 'package:ecommerce_app/common/widgets/appbar/app_bar.dart';

class DisplayBrands extends StatelessWidget {
  const DisplayBrands({super.key});

  @override
  Widget build(BuildContext context) {
    final brandController = BrandController.instance;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: EColors.primary,
        onPressed: () => Get.to(() => const AddNewBrandScreen()),
        child: const Icon(
          Icons.add,
          color: EColors.white,
        ),
      ),
      appBar: EAppBar(
        showBackArrow: true,
        title: Text(
          'All Brands',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          // Wrap the FutureBuilder with Obx
          return FutureBuilder(
            key: Key(brandController.refreshData.value.toString()),
            future: brandController.getBrands(),
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

              final brands = snapshot.data!;

              return ListView.builder(
                itemCount: brands.length,
                itemBuilder: (context, index) {
                  final brand = brands[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        brand.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      subtitle: Text(
                        'ID: ${brand.id}',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      leading: ECircularImage(
                        isNetworkImage: true,
                        image: brand.image,
                        backgroundColor: EHelperFunctions.isDarkMode(context)
                            ? EColors.dark
                            : EColors.white,
                        overlayColor: EHelperFunctions.isDarkMode(context)
                            ? EColors.white
                            : EColors.dark,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                brandController.loadBrand(brand);
                                Get.to(() => EditBrands(brand: brand));
                              }),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await brandController.deleteBrand(brand.id);
                              brandController
                                  .refreshData; // Increment to trigger rebuild
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        }),
      ),
    );
  }
}
