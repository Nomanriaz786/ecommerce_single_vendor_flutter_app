import 'package:ecommerce_app/Admin_Panel/screen/addCategories/edit_categories.dart';
import 'package:ecommerce_app/common/widgets/images/e_circular_image.dart';
import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:ecommerce_app/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app/Admin_Panel/screen/addCategories/add_categories.dart';
import 'package:ecommerce_app/features/shop/controllers/category_controller.dart';
import 'package:ecommerce_app/common/widgets/loaders/circular_loader.dart';
import 'package:ecommerce_app/common/widgets/appbar/app_bar.dart';

class DisplayCategories extends StatelessWidget {
  const DisplayCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = CategoryController.instance;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: EColors.primary,
        onPressed: () => Get.to(() => const AddNewCategoryScreen()),
        child: const Icon(
          Icons.add,
          color: EColors.white,
        ),
      ),
      appBar: EAppBar(
        showBackArrow: true,
        title: Text(
          'All Categories',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => FutureBuilder(
            key: Key(categoryController.refreshData.value.toString()),
            future: categoryController.getCategories(),
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

              final categories = snapshot.data!;

              return ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        category.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      subtitle: Text(
                        'ID: ${category.id}',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      leading: ECircularImage(
                        isNetworkImage: true,
                        image: category.image,
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
                                categoryController.loadCategory(category);
                                Get.to(
                                    () => EditCategories(category: category));
                              }),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await categoryController
                                  .deleteCategories(category.id);
                              categoryController.refreshData;
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
    );
  }
}
