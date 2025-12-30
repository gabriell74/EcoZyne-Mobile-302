import 'package:ecozyne_mobile/core/utils/date_formatter.dart';
import 'package:ecozyne_mobile/core/utils/history_helper.dart';
import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/data/providers/point_income_history_provider.dart';
import 'package:ecozyne_mobile/features/history/widgets/date_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/history_item.dart';

class PointInScreen extends StatefulWidget {
  const PointInScreen({super.key});

  @override
  State<PointInScreen> createState() => _PointInScreenState();
}

class _PointInScreenState extends State<PointInScreen>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PointIncomeHistoryProvider>().getPointIncomeHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<PointIncomeHistoryProvider>(
      builder: (context, prov, _) {
        if (prov.isLoading) {
          return const Center(child: LoadingWidget());
        }

        if (prov.pointIncomeHistory == null || prov.groupedHistory.isEmpty) {
          return Center(
            child: EmptyState(
              connected: prov.connected,
              message: prov.message,
            ),
          );
        }

        final grouped = prov.groupedHistory;
        final dateKeys = grouped.keys.toList()
          ..sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));

        return RefreshIndicator.adaptive(
          onRefresh: () async =>
              prov.getPointIncomeHistory(),
          color: Colors.black,
          backgroundColor: const Color(0xFF55C173),
          child: ListView.builder(
            key: const PageStorageKey("point_in_list"),
            padding: const EdgeInsets.all(16),
            itemCount: dateKeys.length,
            itemBuilder: (context, index) {
              final dateKey = dateKeys[index];
              final dateLabel = DateFormatter.formatDate(DateTime.parse(dateKey));
              final items = grouped[dateKey]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DateHeader(date: dateLabel),
                  const SizedBox(height: 12),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final mapItem = items[i];
                      final type = mapItem["type"];
                      final item = mapItem["item"];

                      if (type == "rejectedReward") {
                        final data = item.exchangeTransactions.first;
                        return HistoryItem(
                          icon: Icons.add_circle_outline,
                          color: const Color(0xFF55C173),
                          title: "Poin Masuk (Penukaran Ditolak)",
                          subtitle: "+${data.totalUnitPoint} Poin",
                          subtitleColor: const Color(0xFF55C173),
                          time: timeAgo(item.updatedAt),
                          description:
                          "Pengembalian poin dari penukaran '${data.reward.rewardName}' (${data.amount} item) pada tanggal '${DateFormatter.formatDate(item.createdAt)}'",
                        );
                      } else {
                        return HistoryItem(
                          icon: Icons.add_circle_outline,
                          color: Colors.blue,
                          title: "Poin Masuk (Setoran Sampah)",
                          subtitle: "+${item.pointEarned ?? 0} Poin",
                          subtitleColor: Colors.blue,
                          time: timeAgo(item.createdAt),
                          description: "Ketuk untuk melihat detail",
                          trashImage: item.trashImage,
                          trashWeight: item.trashWeight.toString(),
                          wasteBankName: item.wasteBankName,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
