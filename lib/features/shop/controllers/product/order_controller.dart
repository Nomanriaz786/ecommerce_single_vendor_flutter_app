import 'package:ecommerce_app/bottom_navigation_bar.dart';
import 'package:ecommerce_app/common/widgets/success_screens/success_screen_1.dart';
import 'package:ecommerce_app/data/authentication_repository/authentication_repository.dart';
import 'package:ecommerce_app/data/order/order_repository.dart';
import 'package:ecommerce_app/features/personalization/controllers/address_controller.dart';
import 'package:ecommerce_app/features/shop/controllers/product/cart_controller.dart';
import 'package:ecommerce_app/features/shop/controllers/product/checkout_controller.dart';
import 'package:ecommerce_app/features/shop/models/order_model.dart';
import 'package:ecommerce_app/generated/assets.dart';
import 'package:ecommerce_app/util/constants/enums.dart';
import 'package:ecommerce_app/util/constants/image_strings.dart';
import 'package:ecommerce_app/util/popup/full_screen_loading.dart';
import 'package:ecommerce_app/util/popup/loaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  final addressController = AddressController.instance;
  final cartController = Get.put(CartController());
  final checkoutController = CheckoutController.instance;
  final orderRepository = Get.put(OrderRepository());

  /// -Fetch user all orders
  Future<List<OrderModel>> fetchUserOrders() async {
    try {
      final userOrders = await orderRepository.fetchUserOrders();
      return userOrders;
    } catch (e) {
      ELoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  /// -Add methods for for order processing
  void processOrder(double totalAmount) async {
    try {
      // -Start Loader
      EFullScreenLoader.openLoadingDialog(
          'Processing your order', EImages.pencilAnimation);

      // -Get User Authentication Id
      final userId = AuthenticationRepository.instance.authUser.uid;
      if (userId.isEmpty) {
        return;
      }

      // -Add Data
      final order = OrderModel(
        id: UniqueKey().toString(),
        userId: userId,
        status: OrderStatus.pending,
        totalAmount: totalAmount,
        orderTime: DateTime.now(),
        paymentMethod: checkoutController.selectedPaymentMethod.value.name,
        address: addressController.selectedAddress.value,
        deliveryTime: DateTime.now(),
        items: cartController.cartItems.toList(),
      );

      // -Save order to firebase
      await orderRepository.saveOrder(order, userId);

      // -Update the cart status
      cartController.clearCart();

      // -Show success screen
      Get.off(() => SuccessScreen(
            image: Assets.animationsOrderCompleteCarDeliveryAnimation,
            title: 'Payment success! ',
            subtitle: 'Your item will be shipped soon',
            onPressed: () => Get.offAll(() => const BottomNavigation()),
          ));
    } catch (e) {
      ELoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
