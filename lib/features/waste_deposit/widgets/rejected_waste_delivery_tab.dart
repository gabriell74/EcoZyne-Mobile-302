import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/data/providers/trash_transaction_provider.dart';
import 'package:ecozyne_mobile/features/waste_deposit/widgets/trash_submission_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RejectedWasteDeliveryTab extends StatelessWidget {
  const RejectedWasteDeliveryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TrashTransactionProvider>(
        builder: (context, provider, _) {
          if (provider.isLoadingRejected) {
            return const Center(child: LoadingWidget());
          }

          if (provider.rejectedSubmissions.isEmpty) {
            return Center(
              child: EmptyState(
                connected: provider.connected,
                message: provider.messageRejected,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.rejectedSubmissions.length,
            itemBuilder: (context, index) {
              final rejectedSubmission = provider.rejectedSubmissions[index];
              return TrashSubmissionsCard(
                submission: rejectedSubmission,
              );
            },
          );
        }
    );
  }
}
