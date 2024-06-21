import 'package:ecommerce_app/Admin_Panel/screen/manage_users/edit_users.dart';
import 'package:ecommerce_app/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce_app/common/widgets/loaders/circular_loader.dart';
import 'package:ecommerce_app/features/personalization/controllers/user_controller.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DisplayUsersScreen extends StatelessWidget {
  const DisplayUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = UserController.instance;

    return Scaffold(
      appBar: EAppBar(
        showBackArrow: true,
        title: Text(
          'All Users',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Obx(
            () => FutureBuilder(
              key: Key(userController.refreshData.value.toString()),
              future: userController.getUsers(),
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
                final users = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: users.length,
                  itemBuilder: (_, index) {
                    final user = users[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          '${user.firstName} ${user.lastName}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                          user.email,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                userController.loadUser(user);
                                Get.to(() => EditUserScreen(user: user));
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await userController.deleteUser(user.id);
                                userController.refreshData;
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
