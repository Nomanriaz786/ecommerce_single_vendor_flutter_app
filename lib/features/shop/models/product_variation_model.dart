class ProductVariationModel {
  final String id;
  String sku;
  String image;
  String? description;
  double price;
  double salesPrice;
  int stock;
  Map<String, String> attributeValues;

  ProductVariationModel({
    required this.id,
    this.sku = '',
    this.image = '',
    this.description = '',
    this.price = 0.0,
    this.salesPrice = 0.0,
    this.stock = 0,
    required this.attributeValues,
  });

  /// -Create empty function
  static ProductVariationModel empty() =>
      ProductVariationModel(id: '', attributeValues: {});

  /// -Json Format
  toJson() {
    return {
      'Id': id,
      'Images': image,
      'Description': description,
      'Price': price,
      'SalePrice': salesPrice,
      'SKU': sku,
      'Stock': stock,
      'AttributeValues': attributeValues,
    };
  }

  /// Map Json oriented document snapshot from FireBase to Model
  factory ProductVariationModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) {
      return ProductVariationModel.empty();
    }
    return ProductVariationModel(
      id: data['Id'] ?? '',
      price: double.parse((data['Price'] ?? 0.0).toString()),
      sku: data['SKU'] ?? '',
      stock: data['Stock'] ?? '',
      salesPrice: double.parse((data['SalePrice'] ?? 0.0).toString()),
      image: data['Image'] ?? '',
      attributeValues: Map<String, String>.from(data['AttributeValues']),
    );
  }
}
