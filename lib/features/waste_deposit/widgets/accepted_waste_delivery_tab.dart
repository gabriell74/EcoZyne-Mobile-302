import 'dart:io';
import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/data/models/trash_transaction.dart';
import 'package:ecozyne_mobile/data/providers/trash_transaction_provider.dart';
import 'package:ecozyne_mobile/features/waste_deposit/widgets/store_trash_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'trash_submission_card.dart';

class AcceptedWasteDeliveryTab extends StatefulWidget {
  const AcceptedWasteDeliveryTab({super.key});

  @override
  State<AcceptedWasteDeliveryTab> createState() =>
      _AcceptedWasteDeliveryTabState();
}

class _AcceptedWasteDeliveryTabState extends State<AcceptedWasteDeliveryTab> {
  final TextEditingController _trashWeightCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;

  @override
  void dispose() {
    _trashWeightCtrl.dispose();
    super.dispose();
  }

  void _storeTrash(BuildContext context, int orderId) {
    _trashWeightCtrl.clear();
    _selectedImage = null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StoreTrashBottomSheet(
          formKey: _formKey,
          trashWeightCtrl: _trashWeightCtrl,
          initialImage: _selectedImage,
          initialImageUrl: null,
          onImageSelected: (File? image) {
            setState(() => _selectedImage = image);
          },
          onPressed: (bottomSheetContext) async {
            await _submitStoreTrash(bottomSheetContext, orderId);
          },
        );
      },
    );
  }

  Future<void> _submitStoreTrash(
      BuildContext bottomSheetContext, int orderId) async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<TrashTransactionProvider>();

    Navigator.pop(bottomSheetContext);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: LoadingWidget()),
    );

    final success = await provider.storeTrash(
      orderId,
      {
        "trash_weight": int.parse(_trashWeightCtrl.text.trim()),
        "trash_image": _selectedImage!.path,
      },
    );

    if (mounted) Navigator.pop(context);

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

  void _showTrashDetail(BuildContext context, TrashTransaction trx) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: Icon(Icons.remove)),
              const SizedBox(height: 12),
              const CustomText(
                "Detail Pengantaran Sampah",
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 16),
              if (trx.trashImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    trx.trashImage!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              CustomText("Berat Sampah: ${trx.trashWeight} kg"),
              const SizedBox(height: 8),
              CustomText("Poin Didapat: ${trx.pointEarned}"),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TrashTransactionProvider>(
      builder: (context, provider, _) {
        if (provider.isLoadingAccepted) {
          return const Center(child: LoadingWidget());
        }

        if (provider.acceptedSubmissions.isEmpty) {
          return Center(
            child: EmptyState(
              connected: provider.connected,
              message: provider.messageAccepted,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.acceptedSubmissions.length,
          itemBuilder: (context, index) {
            final submission = provider.acceptedSubmissions[index];
            return TrashSubmissionsCard(
              submission: submission,
              showCompleteButton: submission.status == 'approved',
              onCompleted: () => _storeTrash(context, submission.id),
            );
          },
        );
      },
    );
  }
}
