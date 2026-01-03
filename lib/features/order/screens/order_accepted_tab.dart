import 'package:ecozyne_mobile/core/widgets/confirmation_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:ecozyne_mobile/data/providers/waste_bank_order_provider.dart';
import 'package:ecozyne_mobile/features/order/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderAcceptedTab extends StatelessWidget {
  const OrderAcceptedTab({super.key});

  Future<void> _showConfirmationCompleteDialog(
    BuildContext context,
    int orderId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        "Tandai Selesai?",
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

    final success = await provider.completeOrder(orderId);

    if (context.mounted) Navigator.pop(context);

    if (success) {
      showSuccessTopSnackBar(
        context,
        provider.messageCompleted,
        icon: const Icon(Icons.check_circle_rounded),
      );
    } else {
      showErrorTopSnackBar(context, provider.messageCompleted);
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
            final bool showCompleteButton = order.statusOrder == "processed";
            return OrderCard(
              order: order,
              showCompleteButton: showCompleteButton,
              onCompleted: () => _showConfirmationCompleteDialog(context, order.id),              
            );
          },
        );
      },
    );
  }
}
