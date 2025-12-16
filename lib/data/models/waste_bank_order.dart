class WasteBankOrder {
  final int id;
  final String customerName;
  final String phoneNumber;
  final String address;
  final int totalPrice;
  final int amount;
  final String productName;
  final String statusOrder;
  final String statusPayment;
  final String? cancellationReason;
  final String createdAt;

  WasteBankOrder({
    required this.id,
    required this.customerName,
    required this.phoneNumber,
    required this.address,
    required this.totalPrice,
    required this.amount,
    required this.productName,
    required this.statusOrder,
    required this.statusPayment,
    this.cancellationReason,
    required this.createdAt,
  });

  factory WasteBankOrder.fromJson(Map<String, dynamic> json) {
    return WasteBankOrder(
      id: json['id'],
      customerName: json['customer_name'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      totalPrice: json['total_price'],
      amount: json['amount'],
      productName: json['product_name'],
      statusOrder: json['status_order'],
      statusPayment: json['status_payment'],
      cancellationReason: json['cancellation_reason'],
      createdAt: json['created_at'],
    );
  }
}
