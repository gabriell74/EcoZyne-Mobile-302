import 'package:ecozyne_mobile/core/widgets/cancellation_bottom_sheet.dart';
import 'package:ecozyne_mobile/core/widgets/confirmation_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:ecozyne_mobile/data/providers/waste_bank_order_provider.dart';
import 'package:ecozyne_mobile/features/order/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderCurrentTab extends StatefulWidget {
  const OrderCurrentTab({super.key});

  @override
  State<OrderCurrentTab> createState() => _OrderCurrentTabState();
}

class _OrderCurrentTabState extends State<OrderCurrentTab> {

  @override
  void dispose() {
    _rejectReasonCtrl.dispose();
    super.dispose();
  }

  final TextEditingController _rejectReasonCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _showConfirmationAcceptedDialog(
    BuildContext context,
    int orderId,
  ) async {
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

    final success = await provider.acceptOrder(orderId);

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

  void _rejectOrder(BuildContext context, int orderId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return CancellationBottomSheet(
          formKey: _formKey,
          cancelReasonCtrl: _rejectReasonCtrl,
          onPressed: (context) => _rejectDialog(context, orderId),
        );
      },
    );
  }

  Future<void> _rejectDialog(BuildContext context, int orderId) async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<WasteBankOrderProvider>();

    Navigator.pop(context);

    showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (_) => const Center(child: LoadingWidget()),
    );

    final success = await provider.rejectOrder(
      orderId,
      _rejectReasonCtrl.text.trim(),
    );

    if (mounted) Navigator.pop(this.context);

    if (success) {
      showSuccessTopSnackBar(
        this.context,
        provider.messageRejected,
        icon: const Icon(Icons.check_circle_rounded),
      );
    } else {
      showErrorTopSnackBar(this.context, provider.messageRejected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WasteBankOrderProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: LoadingWidget());
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
              onAccepted: () =>
                  _showConfirmationAcceptedDialog(context, order.id),
              onRejected: () => _rejectOrder(context, order.id),
            );
          },
        );
      },
    );
  }
}
