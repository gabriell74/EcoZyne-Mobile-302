import 'package:ecozyne_mobile/core/utils/date_formatter.dart';
import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/data/providers/order_history_provider.dart';
import 'package:ecozyne_mobile/features/history/widgets/date_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/order_history_card.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderHistoryProvider>(context, listen: false)
          .getProductOrderHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<OrderHistoryProvider>(builder: (context, prov, _) {
      if (prov.isLoading) {
        return const Center(child: LoadingWidget());
      }

      if (prov.orderHistory.isEmpty) {
        return Center(
          child: EmptyState(
            connected: prov.connected,
            message: prov.message,
          ),
        );
      }

      final grouped = prov.groupedHistory;

      return RefreshIndicator.adaptive(
        onRefresh: () async => await prov.getProductOrderHistory(),
        color: Colors.black,
        backgroundColor: const Color(0xFF55C173),
        child: ListView.builder(
          key: const PageStorageKey('order_history_list'),
          padding: const EdgeInsets.all(16),
          itemCount: grouped.length,
          itemBuilder: (context, index) {
            final dateKey = grouped.keys.elementAt(index);
            final items = grouped[dateKey]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DateHeader(date: DateFormatter.formatDate(dateKey)),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (_, index) => OrderHistoryCard(order: items[index]),
                ),
                const SizedBox(height: 8),
              ],
            );
          },
        ),
      );
    });
  }
}