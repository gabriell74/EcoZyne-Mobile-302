class ProductTransaction {
  final int? productId;
  final String productName;
  final int productPrice;
  final int amount;
  final int totalPrice;

  ProductTransaction({
    this.productId,
    required this.productName,
    required this.productPrice,
    required this.amount,
    required this.totalPrice,
  });

  factory ProductTransaction.fromJson(Map<String, dynamic> json) {
    return ProductTransaction(
      productId: json['product_id'],
      productName: json['product_name'],
      productPrice: json['product_price'],
      amount: json['amount'],
      totalPrice: json['total_price'],
    );
  }
}
