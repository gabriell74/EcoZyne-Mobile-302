import 'package:ecozyne_mobile/data/models/exchange_transaction.dart';

class ExchangeHistory {
  final int id;
  final int communityId;
  final String exchangeStatus;
  final String createdAt;
  final String updatedAt;
  final List<ExchangeTransactionHistory> exchangeTransactions;

  ExchangeHistory({
    required this.id,
    required this.communityId,
    required this.exchangeStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.exchangeTransactions,
  });

  factory ExchangeHistory.fromJson(Map<String, dynamic> json) {
    return ExchangeHistory(
      id: json["id"],
      communityId: json["community_id"],
      exchangeStatus: json["exchange_status"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      exchangeTransactions: (json["exchange_transactions"] as List)
          .map((e) => ExchangeTransactionHistory.fromJson(e))
          .toList(),
    );
  }
}
