import 'package:ecozyne_mobile/core/widgets/confirmation_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:ecozyne_mobile/data/providers/waste_bank_order_provider.dart';
import 'package:ecozyne_mobile/features/order/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderCurrentTab extends StatelessWidget {
  const OrderCurrentTab({super.key});

  Future<void> _showConfirmationAcceptedDialog(BuildContext context, int orderId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        "Terima pesanan ini?",
        onTap: () => Navigator.pop(ctx, true),
      ),
    );

    if (confirmed != true) return;

    final provider = context.read<WasteBankOrderProvider>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (loadingContext) => const LoadingWidget(height: 100),
    );

    final success =
    await provider.acceptOrder(orderId);

    if (context.mounted) Navigator.pop(context);

    if (success) {
      showSuccessTopSnackBar(
        context,
        provider.messageAccepted,
        icon: const Icon(Icons.check_circle_rounded),
      );
    } else {
      showErrorTopSnackBar(context, provider.messageAccepted);
    }
  }

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
              showActionButtons: true,
              onAccepted: () => _showConfirmationAcceptedDialog(context, order.id),
            );
          },
        );
      },
    );
  }
}
