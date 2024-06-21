class CartItemModel {
  String productId;
  String title;
  double price;
  String? image;
  int quantity;
  String variationId;
  String? brandName;
  Map<String, String>? selectedVariation;

  CartItemModel({
    required this.productId,
    required this.quantity,
    this.variationId = '',
    this.image,
    this.price = 0.0,
    this.title = '',
    this.brandName,
    this.selectedVariation,
  });

  ///Empty cart
  static CartItemModel empty() => CartItemModel(
        productId: '',
        quantity: 0,
      );

  /// -Convert a CartItemModel to json map
  Map<String, dynamic> toJson() {
    return {
      'ProductId': productId,
      'Title': title,
      'Price': price,
      'Image': image,
      'Quantity': quantity,
      'VariationId': variationId,
      'BrandName': brandName,
      'SelectedVariation': selectedVariation,
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> data) {
    return CartItemModel(
      productId: data['ProductId'],
      title: data['Title'],
      price: data['Price'],
      image: data['Image'],
      quantity: data['Quantity'],
      variationId: data['VariationId'],
      brandName: data['BrandName'],
      selectedVariation: data['SelectedVariation'] != null
          ? Map<String, String>.from(data['SelectedVariation'])
          : null,
    );
  }
}
