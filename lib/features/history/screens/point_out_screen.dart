import 'package:ecozyne_mobile/core/utils/date_formatter.dart';
import 'package:ecozyne_mobile/core/utils/history_helper.dart';
import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/data/providers/point_out_history_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/history_item.dart';

class PointOutScreen extends StatefulWidget {
  const PointOutScreen({super.key});

  @override
  State<PointOutScreen> createState() => _PointOutScreenState();
}

class _PointOutScreenState extends State<PointOutScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PointOutHistoryProvider>(context, listen: false)
          .getRewardExchangeHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<PointOutHistoryProvider>(
      builder: (context, prov, _) {
        if (prov.isLoading) {
          return const Center(child: LoadingWidget());
        }

        if (prov.exchangeHistory.isEmpty) {
          return Center(
            child: EmptyState(
              connected: prov.connected,
              message: prov.message,
            ),
          );
        }

        // langsung pakai groupedHistory dari provider
        final grouped = prov.groupedHistory;

        return RefreshIndicator.adaptive(
          onRefresh: () async => await prov.getRewardExchangeHistory(forceRefresh: true),
          color: Colors.black,
          backgroundColor: const Color(0xFF55C173),
          child: ListView.builder(
            key: const PageStorageKey('point_out_list'),
            padding: const EdgeInsets.all(16),
            itemCount: grouped.length,
            itemBuilder: (context, index) {
              final dateKey = grouped.keys.elementAt(index);
              final dateLabel = DateFormatter.formatDate(dateKey);
              final items = grouped[dateKey]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateLabel,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, itemIndex) {
                      final item = items[itemIndex];
                      final trx = item.exchangeTransactions.first;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: HistoryItem(
                          icon: _iconFromStatus(item.exchangeStatus),
                          color: _colorFromStatus(item.exchangeStatus),
                          title:
                          "Penukaran Hadiah (${_textStatus(item.exchangeStatus)})",
                          subtitle: "- ${trx.totalUnitPoint} Poin",
                          subtitleColor: Colors.red,
                          time: timeAgo(item.createdAt),
                          description:
                          "Menukar '${trx.reward.rewardName}' (${trx.amount}) item",
                        ),
                      );
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

String _textStatus(String status) {
  switch (status) {
    case "pending":
      return "Menunggu Persetujuan";
    case "approved":
      return "Disetujui";
    case "rejected":
      return "Ditolak";
    default:
      return "Status tidak diketahui";
  }
}

IconData _iconFromStatus(String status) {
  switch (status) {
    case "pending":
      return Icons.hourglass_top;
    case "approved":
      return Icons.check_circle_outline;
    case "rejected":
      return Icons.cancel_outlined;
    default:
      return Icons.info_outline;
  }
}

Color _colorFromStatus(String status) {
  switch (status) {
    case "pending":
      return Colors.orange;
    case "approved":
      return const Color(0xFF55C173);
    case "rejected":
      return Colors.red;
    default:
      return Colors.blueGrey;
  }
}