import 'package:ecozyne_mobile/core/widgets/cancellation_bottom_sheet.dart';
import 'package:ecozyne_mobile/core/widgets/confirmation_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:ecozyne_mobile/data/providers/trash_transaction_provider.dart';
import 'package:ecozyne_mobile/features/waste_deposit/widgets/trash_submission_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WasteDeliveryTab extends StatefulWidget {

  const WasteDeliveryTab({super.key});

  @override
  State<WasteDeliveryTab> createState() => _WasteDeliveryTabState();
}

class _WasteDeliveryTabState extends State<WasteDeliveryTab> {
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
        "Terima pengantaran sampah ini?",
        onTap: () => Navigator.pop(ctx, true),
      ),
    );

    if (confirmed != true) return;

    final provider = context.read<TrashTransactionProvider>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (loadingContext) => const LoadingWidget(height: 100),
    );

    final success = await provider.acceptSubmissions(orderId);

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

  void _rejectSubmissions(BuildContext context, int orderId) {
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
    final provider = context.read<TrashTransactionProvider>();

    Navigator.pop(context);

    showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (_) => const Center(child: LoadingWidget()),
    );

    final success = await provider.rejectSubmissions(
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
    return Consumer<TrashTransactionProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: LoadingWidget());
        }

        if (provider.currentSubmissions.isEmpty) {
          return Center(
            child: EmptyState(
              connected: provider.connected,
              message: provider.message,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.currentSubmissions.length,
          itemBuilder: (context, index) {
            final currentSubmission = provider.currentSubmissions[index];

            return TrashSubmissionsCard(
              submission: currentSubmission,
              showActionButtons: true,
              onAccepted: () => _showConfirmationAcceptedDialog(context, currentSubmission.id),
              onRejected: () => _rejectSubmissions(context, currentSubmission.id),
            );
          },
        );
      }
    );
  }
}