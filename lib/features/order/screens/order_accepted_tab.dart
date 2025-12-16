import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/data/providers/waste_bank_order_provider.dart';
import 'package:ecozyne_mobile/features/order/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderAcceptedTab extends StatelessWidget {
  const OrderAcceptedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WasteBankOrderProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(
            child: LoadingWidget(),
          );
        }

        final acceptedOrders = provider.acceptedOrders;

        if (acceptedOrders.isEmpty) {
          return Center(
            child: EmptyState(
              connected: provider.connected,
              message: "Belum ada pesanan yang dikirimkan",
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: acceptedOrders.length,
          itemBuilder: (context, index) {
            final order = acceptedOrders[index];

            return OrderCard(
              order: order,
            );
          },
        );
      },
    );
  }
}
