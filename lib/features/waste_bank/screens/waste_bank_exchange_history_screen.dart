import 'package:ecozyne_mobile/core/utils/history_helper.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/empty_state.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/data/models/trash_submissions.dart';
import 'package:ecozyne_mobile/data/providers/trash_submissions_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WasteBankExchangeHistoryScreen extends StatefulWidget {
  const WasteBankExchangeHistoryScreen({super.key});

  @override
  State<WasteBankExchangeHistoryScreen> createState() => _WasteBankExchangeHistoryScreenState();
}

class _WasteBankExchangeHistoryScreenState extends State<WasteBankExchangeHistoryScreen> {

  String _statusText(String status) {
    switch (status) {
      case "pending":
        return "Menunggu";
      case "approved":
        return "Disetujui";
      case "rejected":
        return "Ditolak";
      case "completed":
        return "Sampah Disetorkan";
      default:
        return "Unknown";
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case "pending":
        return Colors.orange;
      case "approved":
        return Colors.blue;
      case "completed":
        return const Color(0xFF55C173);
      case "rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case "pending":
        return Icons.access_time_rounded;
      case "approved":
        return Icons.check_circle_rounded;
      case "completed":
        return Icons.task_alt_rounded;
      case "rejected":
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrashSubmissionsProvider>().getTrashSubmissionsHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const CustomText(
          'Pengajuan Pengantaran Sampah',
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Consumer<TrashSubmissionsProvider>(
        builder: (context, provider, _) {
          final trashSubmissions = provider.trashSubmissions;

          if (provider.isLoading) {
            return const Center(child: LoadingWidget());
          }

          if (trashSubmissions.isEmpty) {
            return Center(child: EmptyState(connected: provider.connected, message: provider.message));
          }
          return Column(
            children: [
              _buildInfoBanner(),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: trashSubmissions.length,
                  itemBuilder: (context, index) {
                    final exchange = trashSubmissions[index];
                    return _exchangeStatusCard(context, exchange);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF55C173).withValues(alpha: 0.1),
            const Color(0xFF55C173).withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF55C173).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF55C173).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: Color(0xFF55C173),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  'Informasi Penting',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF55C173),
                ),
                SizedBox(height: 4),
                CustomText(
                  'Antarkan sampah Anda ke bank sampah jika pengajuan sudah disetujui',
                  fontSize: 13,
                  color: Colors.black87,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _exchangeStatusCard(BuildContext context, TrashSubmissions exchange) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _statusColor(exchange.status).withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF55C173).withValues(alpha: 0.2),
                        const Color(0xFF55C173).withValues(alpha: 0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF55C173).withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.recycling_rounded,
                    color: Color(0xFF55C173),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        "Pengajuan Tukar Sampah",
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.recycling_rounded,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: CustomText(
                              exchange.wasteBankName,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          CustomText(
                            timeAgo(exchange.createdAt),
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Divider(
              color: Colors.grey.shade200,
              height: 1,
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const CustomText(
                  'Status:',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(exchange.status)
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _statusColor(exchange.status)
                          .withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _statusIcon(exchange.status),
                        size: 16,
                        color: _statusColor(exchange.status),
                      ),
                      const SizedBox(width: 6),
                      CustomText(
                        _statusText(exchange.status),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: _statusColor(exchange.status),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}