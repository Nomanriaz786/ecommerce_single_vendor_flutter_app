import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/data/authentication_repository/authentication_repository.dart';
import 'package:ecommerce_app/features/shop/models/order_model.dart';
import 'package:get/get.dart';

class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  /// -Fetch user all orders
  Future<List<OrderModel>> fetchUserOrders() async {
    try {
      final userId = AuthenticationRepository.instance.authUser.uid;
      if (userId.isEmpty) {
        throw 'Unable to find user information. Try again in few minutes';
      }
      final result =
          await _db.collection('User').doc(userId).collection('Orders').get();
      return result.docs
          .map((document) => OrderModel.fromSnapshot(document))
          .toList();
    } catch (e) {
      throw 'Something went wrong while fetching order information. Try again later';
    }
  }

  /// -Add methods for for order processing
  Future<void> saveOrder(OrderModel order, String userId) async {
    try {
      await _db
          .collection('User')
          .doc(userId)
          .collection('Orders')
          .add(order.toJson());
    } catch (e) {
      throw 'Something went wrong while saving order information';
    }
  }
}
