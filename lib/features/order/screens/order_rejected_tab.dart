import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/data/providers/waste_bank_order_provider.dart';
import 'package:ecozyne_mobile/features/order/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderRejectedTab extends StatelessWidget {
  const OrderRejectedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WasteBankOrderProvider>(
      builder: (context, provider, _) {
        final rejectedOrders = provider.rejectedOrders;

        if (provider.isLoading) {
          return const Center(child: LoadingWidget());
        }

        if (rejectedOrders.isEmpty) {
          return Center(
            child: EmptyState(
              connected: provider.connected,
              message: 'Belum ada pesanan ditolak',
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: rejectedOrders.length,
          itemBuilder: (context, index) {
            final order = rejectedOrders[index];
            return OrderCard(order: order);
          },
        );
      },
    );
  }
}
