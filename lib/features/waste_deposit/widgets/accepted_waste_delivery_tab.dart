import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/data/providers/trash_transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'trash_submission_card.dart';

class AcceptedWasteDeliveryTab extends StatelessWidget {

  const AcceptedWasteDeliveryTab({super.key});

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
              final acceptedSubmission = provider.acceptedSubmissions[index];
              final bool showCompleteButton = acceptedSubmission.status == 'approved';
              return TrashSubmissionsCard(
                submission: acceptedSubmission,
                showCompleteButton: showCompleteButton,
              );
            },
          );
        }
    );
  }
}