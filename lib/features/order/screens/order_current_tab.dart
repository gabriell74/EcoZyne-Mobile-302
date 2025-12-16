import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/data/providers/waste_bank_order_provider.dart';
import 'package:ecozyne_mobile/features/order/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderCurrentTab extends StatelessWidget {
  const OrderCurrentTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WasteBankOrderProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(
            child: LoadingWidget(),
          );
        }

        if (provider.currentOrders.isEmpty) {
          return Center(
            child: EmptyState(
              connected: provider.connected,
              message: provider.message,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.currentOrders.length,
          itemBuilder: (context, index) {
            final order = provider.currentOrders[index];

            return OrderCard(
              order: order,
              showButtons: true,
            );
          },
        );
      },
    );
  }
}
