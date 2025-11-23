import 'package:ecozyne_mobile/core/utils/date_formatter.dart';
import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/data/providers/history_provider.dart';
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
      Provider.of<HistoryProvider>(context, listen: false)
          .getRewardExchangeHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Selector<HistoryProvider, bool>(
      selector: (_, prov) => prov.isLoading,
      builder: (_, isLoading, __) {
        if (isLoading) {
          return const Center(child: LoadingWidget());
        }

        return Selector<HistoryProvider, List>(
          selector: (_, prov) => prov.exchangeHistory,
          builder: (_, history, __) {
            if (history.isEmpty) {
              return Selector<HistoryProvider, Map<String, dynamic>>(
                selector: (_, prov) => {
                  "connected": prov.connected,
                  "message": prov.message,
                },
                builder: (_, state, __) {
                  return Center(
                    child: EmptyState(
                      connected: state["connected"],
                      message: state["message"],
                    ),
                  );
                },
              );
            }

            final grouped = groupByDate(history);

            return ListView.builder(
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

                    ...items.map((item) {
                      final trx = item.exchangeTransactions.first;

                      return HistoryItem(
                        icon: _iconFromStatus(item.exchangeStatus),
                        color: _colorFromStatus(item.exchangeStatus),
                        title:
                        "Penukaran Hadiah (${_textStatus(item.exchangeStatus)})",
                        subtitle: "- ${trx.totalUnitPoint} Poin",
                        subtitleColor: Colors.red,
                        time: timeAgo(item.createdAt),
                        description:
                        "Menukar ${trx.reward.rewardName} sebanyak ${trx.amount} item",
                      );
                    }),

                    const SizedBox(height: 20),
                  ],
                );
              },
            );
          },
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

String timeAgo(dynamic date) {
  DateTime dt;

  try {
    dt = date is String ? DateTime.parse(date) : date;
  } catch (_) {
    return "-";
  }

  final diff = DateTime.now().difference(dt);

  if (diff.inMinutes < 60) return "${diff.inMinutes}m";
  if (diff.inHours < 24) return "${diff.inHours}j";
  return "${diff.inDays}h";
}

Map<String, List<dynamic>> groupByDate(List items) {
  final Map<String, List<dynamic>> grouped = {};

  for (var item in items) {
    final date = DateTime.parse(item.createdAt.toString());

    final key =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    grouped.putIfAbsent(key, () => []).add(item);
  }

  final sortedKeys = grouped.keys.toList()
    ..sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));

  return {for (var k in sortedKeys) k: grouped[k]!};
}
