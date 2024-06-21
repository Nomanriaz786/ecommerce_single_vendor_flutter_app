import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/features/shop/models/product_attribute_model.dart';
import 'package:ecommerce_app/features/shop/models/product_variation_model.dart';
import 'package:ecommerce_app/util/popup/loaders.dart';

import 'brand_model.dart';

class ProductModel {
  String id;
  int stock;
  String title;
  String? sku;
  double price;
  double salePrice;
  DateTime? date;
  String thumbnail;
  bool isFeatured;
  BrandModel? brand;
  String? description;
  String? categoryId;
  List<String>? images;
  String productType;
  List<ProductAttributeModel>? productAttributes;
  List<ProductVariationModel>? productVariations;

  // Improved constructor for clarity and consistency
  ProductModel({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.stock,
    required this.price,
    this.sku,
    this.salePrice = 0.0,
    this.date,
    this.brand,
    this.description,
    this.categoryId,
    this.images,
    required this.productType,
    this.productAttributes,
    this.productVariations,
    required this.isFeatured,
  });

  /// - Create Empty function for clean code
  static ProductModel empty() => ProductModel(
        id: '',
        title: '',
        thumbnail: '',
        stock: 0,
        price: 0,
        productType: '',
        isFeatured: false,
      );

  /// Json code
  Map<String, dynamic> toJson() {
    return {
      'SKU': sku,
      'Title': title,
      'Stock': stock,
      'Price': price,
      'Images': images ?? [],
      'Thumbnail': thumbnail,
      'SalePrice': salePrice,
      'IsFeatured': isFeatured,
      'CategoryId': categoryId,
      'Brand': brand?.toJson(),
      'Description': description,
      'ProductType': productType,
      'ProductAttributes':
          productAttributes?.map((e) => e.toJson()).toList() ?? [],
      'ProductVariations':
          productVariations?.map((e) => e.toJson()).toList() ?? [],
    };
  }

  /// - Map Json oriented document snapshot from firebase to model
  factory ProductModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Object?> document) {
    return _fromSnapshot(document.id, document.data() as Map<String, dynamic>);
  }

  /// - Map Json oriented document snapshot from firebase to model
  factory ProductModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    return _fromSnapshot(document.id, document.data()!);
  }

  /// - Helper method to create a ProductModel from snapshot data
  static ProductModel _fromSnapshot(String id, Map<String, dynamic> data) {
    try {
      return ProductModel(
        id: id,
        title: data['Title'] ?? '',
        sku: data['SKU'],
        stock: data['Stock'] is int
            ? data['Stock']
            : int.tryParse(data['Stock']?.toString() ?? '0') ?? 0,
        isFeatured: data['IsFeatured'] ?? false,
        price: _parseDouble(data['Price']),
        salePrice: _parseDouble(data['SalePrice']),
        thumbnail: data['Thumbnail'] ?? '',
        categoryId: data['CategoryId'] ?? '',
        description: data['Description'] ?? '',
        productType: data['ProductType'] ?? '',
        brand:
            data['Brand'] != null ? BrandModel.fromJson(data['Brand']) : null,
        images: data['Images'] != null ? List<String>.from(data['Images']) : [],
        productAttributes: data['ProductAttributes'] != null
            ? (data['ProductAttributes'] as List<dynamic>)
                .map((e) => ProductAttributeModel.fromJson(e))
                .toList()
            : [],
        productVariations: data['ProductVariations'] != null
            ? (data['ProductVariations'] as List<dynamic>)
                .map((e) => ProductVariationModel.fromJson(e))
                .toList()
            : [],
      );
    } catch (e) {
      ELoaders.errorSnackBar(
          title: "Error parsing ProductModel from snapshot: ${e.toString()}");
      return ProductModel.empty();
    }
  }

  /// Helper method to safely parse a double
  static double _parseDouble(dynamic value) {
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
