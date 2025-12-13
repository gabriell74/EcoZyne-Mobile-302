import 'package:ecozyne_mobile/data/models/product_transaction.dart';

class Order {
  final int id;
  final int communityId;
  final int wasteBankId;
  final String orderCustomer;
  final String orderPhoneNumber;
  final String orderAddress;
  final String statusOrder;
  final String statusPayment;
  final String createdAt;
  final String updatedAt;
  final List<ProductTransaction> productTransactions;

  Order({
    required this.id,
    required this.communityId,
    required this.wasteBankId,
    required this.orderCustomer,
    required this.orderPhoneNumber,
    required this.orderAddress,
    required this.statusOrder,
    required this.statusPayment,
    required this.createdAt,
    required this.updatedAt,
    required this.productTransactions,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      communityId: json['community_id'],
      wasteBankId: json['waste_bank_id'],
      orderCustomer: json['order_customer'],
      orderPhoneNumber: json['order_phone_number'],
      orderAddress: json['order_address'],
      statusOrder: json['status_order'],
      statusPayment: json['status_payment'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      productTransactions: (json['product_transactions'] as List)
          .map((e) => ProductTransaction.fromJson(e))
          .toList(),
    );
  }
}
