
import 'package:ecozyne_mobile/data/models/exchange_history.dart';
import 'package:ecozyne_mobile/data/models/trash_transaction.dart';
import 'package:ecozyne_mobile/data/models/waste_submission_history.dart';

class PointIncomeHistory {
  final List<ExchangeHistory> rejectedReward;
  final List<TrashTransaction> wasteSubmission;

  PointIncomeHistory({
    required this.rejectedReward,
    required this.wasteSubmission,
  });

  factory PointIncomeHistory.fromJson(Map<String, dynamic> json) {
    return PointIncomeHistory(
      rejectedReward: (json["rejected_reward"] as List)
          .map((e) => ExchangeHistory.fromJson(e))
          .toList(),

      wasteSubmission: (json["waste_submission"] as List)
          .map((e) => TrashTransaction.fromJson(e))
          .toList(),
    );
  }
}
