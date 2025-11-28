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
      context.read<PointOutHistoryProvider>().getRewardExchangeHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator.adaptive(
      onRefresh: () async => await context
          .read<PointOutHistoryProvider>()
          .getRewardExchangeHistory(forceRefresh: true),
      color: Colors.black,
      backgroundColor: const Color(0xFF55C173),

      child: CustomScrollView(
        key: const PageStorageKey("point_out_list"),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [SizedBox(height: 10)],
              ),
            ),
          ),

          Consumer<PointOutHistoryProvider>(
            builder: (context, prov, child) {
              final grouped = prov.groupedHistory;

              if (prov.isLoading) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Center(child: LoadingWidget()),
                  ),
                );
              }

              if (prov.exchangeHistory.isEmpty) {
                return SliverFillRemaining(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      EmptyState(
                        connected: prov.connected,
                        message: prov.message,
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                );
              }

              return SliverList.builder(
                itemCount: grouped.length,
                itemBuilder: (context, index) {
                  final dateKey = grouped.keys.elementAt(index);
                  final dateLabel = DateFormatter.formatDate(dateKey);
                  final items = grouped[dateKey]!;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
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

                        Column(
                          children: List.generate(items.length, (itemIndex) {
                            final item = items[itemIndex];
                            final trx = item.exchangeTransactions.first;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
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
                          }),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
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
      return Color(0xFF55C173);
    case "rejected":
      return Colors.red;
    default:
      return Colors.blueGrey;
  }
}
