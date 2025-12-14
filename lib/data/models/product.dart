class Product {
  final int id;
  final int wasteBankId;
  final String? wasteBankName;
  final String productName;
  final String description;
  final int price;
  final int stock;
  final String photo;
  final String? createdAt;
  final String? updatedAt;

  Product({
    required this.id,
    required this.wasteBankId,
    required this.productName,
    required this.description,
    required this.price,
    required this.stock,
    required this.photo,
    this.wasteBankName,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      wasteBankId: json['waste_bank_id'],
      wasteBankName: json['waste_bank_name'],
      productName: json['product_name'],
      description: json['description'],
      price: json['price'],
      stock: json['stock'],
      photo: json['photo'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
