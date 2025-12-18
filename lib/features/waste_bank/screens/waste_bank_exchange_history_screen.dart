import 'package:ecozyne_mobile/core/utils/history_helper.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class WasteBankExchangeHistoryScreen extends StatelessWidget {
  const WasteBankExchangeHistoryScreen({super.key});

  List<dynamic> get exchanges => [
    {
      "status": "pending",
      "wasteBankName": "Bank Sampah Sejahtera",
      "createdAt": DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      "status": "approved",
      "wasteBankName": "Bank Sampah Hijau",
      "createdAt": DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      "status": "cancelled",
      "wasteBankName": "Bank Sampah Bersih",
      "createdAt": DateTime.now().subtract(const Duration(days: 5)),
    },
  ];

  Color _statusColor(String status) {
    switch (status) {
      case "pending":
        return Colors.orange;
      case "approved":
        return const Color(0xFF55C173);
      case "cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _statusText(String status) {
    switch (status) {
      case "pending":
        return "Menunggu";
      case "approved":
        return "Disetujui";
      case "cancelled":
        return "Dibatalkan";
      default:
        return "Unknown";
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case "pending":
        return Icons.access_time_rounded;
      case "approved":
        return Icons.check_circle_rounded;
      case "cancelled":
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
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
      body: Column(
        children: [
          _buildInfoBanner(),

          Expanded(
            child: exchanges.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: exchanges.length,
              itemBuilder: (context, index) {
                final exchange = exchanges[index];
                return _exchangeStatusCard(context, exchange);
              },
            ),
          ),
        ],
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
                  fontSize: 14,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.recycling_rounded,
              size: 64,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),
          const CustomText(
            'Belum Ada Pengajuan',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
          const SizedBox(height: 8),
          CustomText(
            'Pengajuan pengantaran sampah Anda\nakan muncul di sini',
            fontSize: 14,
            color: Colors.grey.shade600,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _exchangeStatusCard(BuildContext context, dynamic exchange) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _statusColor(exchange["status"]).withValues(alpha: 0.2),
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
                              exchange["wasteBankName"],
                              fontSize: 14,
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
                            timeAgo(exchange["createdAt"]),
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
                    color: _statusColor(exchange["status"])
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _statusColor(exchange["status"])
                          .withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _statusIcon(exchange["status"]),
                        size: 16,
                        color: _statusColor(exchange["status"]),
                      ),
                      const SizedBox(width: 6),
                      CustomText(
                        _statusText(exchange["status"]),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: _statusColor(exchange["status"]),
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