import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/features/personalization/models/address_model.dart';
import 'package:ecommerce_app/features/shop/models/cart_item_model.dart';
import 'package:ecommerce_app/util/constants/enums.dart';
import 'package:ecommerce_app/util/helpers/helper_functions.dart';

class OrderModel {
  final String id;
  final String userId;
  final OrderStatus status;
  final double totalAmount;
  final DateTime orderTime;
  final String paymentMethod;
  final AddressModel? address;
  final DateTime? deliveryTime;
  final List<CartItemModel> items;

  OrderModel({
    required this.id,
    this.userId = '',
    required this.status,
    required this.items,
    required this.totalAmount,
    required this.orderTime,
    this.paymentMethod = 'Paypal',
    this.address,
    this.deliveryTime,
  });

  String get formattedOrderDate => EHelperFunctions.getFormattedDate(orderTime);
  String get formattedDeliveryDate =>
      EHelperFunctions.getFormattedDate(deliveryTime!);
  String get orderStatusText => status == OrderStatus.delivered
      ? 'Delivered'
      : status == OrderStatus.shipped
          ? 'Shipment on the way'
          : 'Processing';
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'UserId': userId,
      'Status': status.toString(),
      'TotalAmount': totalAmount,
      'OrderDate': orderTime,
      'PaymentMethod': paymentMethod,
      'Address': address?.toJson(),
      'DeliveryDate': deliveryTime,
      'Items': items.map((item) => item.toJson()).toList(),
    };
  }

  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return OrderModel(
      id: data['Id'] as String,
      userId: data['UserId'] as String,
      status:
          OrderStatus.values.firstWhere((e) => e.toString() == data['Status']),
      totalAmount: data['TotalAmount'] as double,
      orderTime: (data['OrderDate'] as Timestamp).toDate(),
      paymentMethod: data['PaymentMethod'] as String,
      address: AddressModel.fromMap(data['Address'] as Map<String, dynamic>),
      deliveryTime: data['DeliveryDate'] == null
          ? null
          : (data['DeliveryDate'] as Timestamp).toDate(),
      items: (data['Items'] as List<dynamic>)
          .map((itemData) =>
              CartItemModel.fromJson(itemData as Map<String, dynamic>))
          .toList(),
    );
  }
}
