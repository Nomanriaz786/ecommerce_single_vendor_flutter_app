import 'package:cloud_firestore/cloud_firestore.dart';

class BrandModel {
  dynamic id;
  dynamic name;
  String image;
  bool? isFeatured;
  dynamic productCount;

  BrandModel({
    required this.id,
    required this.name,
    required this.image,
    this.isFeatured,
    this.productCount,
  });

  /// - Empty HelperFunction
  static BrandModel empty() => BrandModel(id: '', name: '', image: '');

  /// Convert model to json structure so that you can store data in firebase
  toJson() {
    return {
      'Id': id,
      'Name': name,
      'Image': image,
      'ProductsCount': productCount,
      'IsFeatured': isFeatured,
    };
  }

  /// Map Json oriented document snapshot from FireBase to BrandModel
  factory BrandModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) {
      return BrandModel.empty();
    }
    return BrandModel(
      id: data['Id'] ?? '',
      name: data['Name'] ?? '',
      image: data['Image'] ?? '',
      productCount: data['ProductsCount'] ?? '',
      isFeatured: data['IsFeatured'] ?? false,
    );
  }

  /// Map Json oriented document snapshot from FireBase to BrandModel
  factory BrandModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return BrandModel(
        id: document.id,
        name: data['Name'] ?? '',
        image: data['Image'] ?? '',
        productCount: data['ProductsCount'] ?? '',
        isFeatured: data['IsFeatured'] ?? false,
      );
    } else {
      return BrandModel.empty();
    }
  }
}
