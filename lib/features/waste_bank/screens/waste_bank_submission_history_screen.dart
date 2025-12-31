import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecozyne_mobile/core/utils/date_formatter.dart';
import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/data/providers/waste_bank_submission_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WasteBankSubmissionHistoryScreen extends StatefulWidget {
  const WasteBankSubmissionHistoryScreen({super.key});

  @override
  State<WasteBankSubmissionHistoryScreen> createState() =>
      _WasteBankSubmissionHistoryScreenState();
}

class _WasteBankSubmissionHistoryScreenState
    extends State<WasteBankSubmissionHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<WasteBankSubmissionProvider>().getSubmissionHistory();
    });
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'approved':
        return 'Disetujui';
      case 'rejected':
        return 'Pengajuan Ditolak';
      default:
        return 'Menunggu Persetujuan';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WasteBankSubmissionProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText(
          "Riwayat Pengajuan",
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        centerTitle: true,
      ),
      body: AppBackground(
        child: provider.isLoading
            ? const Center(child: LoadingWidget())
            : provider.submissions.isEmpty
            ? Center(
                child: EmptyState(
                  connected: provider.connected,
                  message: provider.message,
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: provider.submissions.length,
                itemBuilder: (context, index) {
                  final item = provider.submissions[index];

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: item.photo,
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,

                              placeholder: (context, url) => Container(
                                height: 160,
                                width: double.infinity,
                                color: Colors.grey[300],
                                child: const Center(child: LoadingWidget()),
                              ),

                              errorWidget: (context, url, error) => Container(
                                height: 160,
                                width: double.infinity,
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.broken_image,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            item.wasteBankName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            item.wasteBankLocation,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            "Catatan: ${item.notes}",
                            style: const TextStyle(fontSize: 14),
                          ),

                          const SizedBox(height: 8),

                          Row(
                            children: [
                              const Text(
                                "Status: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Chip(
                                label: Text(
                                  _statusLabel(item.status),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: _statusColor(item.status),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Text(
                            "Dibuat: ${DateFormatter.formatDate(item.createdAt)}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),

                          Text(
                            "Terakhir update: ${DateFormatter.formatDate(item.updatedAt)}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
