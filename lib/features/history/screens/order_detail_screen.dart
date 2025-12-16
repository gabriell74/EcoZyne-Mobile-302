import 'package:ecozyne_mobile/core/utils/price_formatter.dart';
import 'package:ecozyne_mobile/core/widgets/app_background.dart';
import 'package:ecozyne_mobile/core/widgets/cancellation_bottom_sheet.dart';
import 'package:ecozyne_mobile/core/widgets/confirmation_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:ecozyne_mobile/data/models/order.dart';
import 'package:ecozyne_mobile/data/providers/order_history_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cancelReasonCtrl = TextEditingController();

  @override
  void dispose() {
    _cancelReasonCtrl.dispose();
    super.dispose();
  }

  Color _paymentStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "paid": return Colors.green;
      case "pending": return Colors.orange;
      case "failed": return Colors.red;
      default: return Colors.grey;
    }
  }

  String _paymentStatusText(String status) {
    switch (status.toLowerCase()) {
      case "paid": return "Sudah Bayar";
      case "pending": return "Menunggu Pembayaran";
      case "failed": return "Gagal";
      default: return "Unknown";
    }
  }

  Color _orderStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "delivered": return Colors.green;
      case "processed": return Colors.blue;
      case "pending": return Colors.orange;
      case "cancelled": return Colors.red;
      default: return Colors.grey;
    }
  }

  String _orderStatusText(String status) {
    switch (status.toLowerCase()) {
      case "delivered": return "Selesai";
      case "processed": return "Diproses";
      case "pending": return "Menunggu";
      case "cancelled": return "Dibatalkan";
      default: return "Unknown";
    }
  }

  void _cancelOrder(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return CancellationBottomSheet(
          formKey: _formKey,
          cancelReasonCtrl: _cancelReasonCtrl,
          onPressed: (context) => _cancelDialog(context));
      },
    );
  }

  Future<void> _cancelDialog(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<OrderHistoryProvider>();

    Navigator.pop(context);

    showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (_) => const Center(child: LoadingWidget()),
    );

    final success = await provider.cancelOrder(
      widget.order.id,
      _cancelReasonCtrl.text.trim(),
    );

    if (mounted) Navigator.pop(this.context);

    if (success) {
      showSuccessTopSnackBar(
        this.context,
        provider.message,
        icon: const Icon(Icons.check_circle_rounded),
      );

      Navigator.pop(this.context);
    } else {
      showErrorTopSnackBar(this.context, provider.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final trx = widget.order.productTransactions.first;
    final showCancelButton = widget.order.statusOrder == "pending" &&
        widget.order.statusPayment == "pending";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText("Detail Pesanan", fontWeight: FontWeight.bold, fontSize: 18),
        centerTitle: true,
      ),
      body: AppBackground(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Status", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.payment, color: _paymentStatusColor(widget.order.statusPayment)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Pembayaran", style: TextStyle(fontSize: 12, color: Colors.grey)),
                                    Text(_paymentStatusText(widget.order.statusPayment),
                                        style: TextStyle(color: _paymentStatusColor(widget.order.statusPayment), fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Icon(Icons.shopping_bag, color: _orderStatusColor(widget.order.statusOrder)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Pesanan", style: TextStyle(fontSize: 12, color: Colors.grey)),
                                    Text(_orderStatusText(widget.order.statusOrder),
                                        style: TextStyle(color: _orderStatusColor(widget.order.statusOrder), fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.person, size: 20, color: Color(0xFF55C173)),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "Penerima",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                _buildInfoRowWithIcon(Icons.person_outline, "Nama", widget.order.orderCustomer),
                                const SizedBox(height: 12),
                                _buildInfoRowWithIcon(Icons.phone, "Telepon", widget.order.orderPhoneNumber),
                                const SizedBox(height: 12),
                                _buildInfoRowWithIcon(Icons.location_on, "Alamat", widget.order.orderAddress),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Produk", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.shopping_bag, color: Colors.pink),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(trx.productName, style: const TextStyle(fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 4),
                                    Text("${trx.amount} item", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                                    Text(trx.productPrice.toString().toCurrency,
                                        style: TextStyle(color: Colors.pink, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Total", style: TextStyle(fontWeight: FontWeight.w600)),
                              Text(trx.totalPrice.toString().toCurrency,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Pembayaran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.local_shipping, color: Color(0xFF55C173)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Cash on Delivery", style: TextStyle(fontWeight: FontWeight.w600)),
                                    Text("Bayar saat barang diterima",
                                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),
                ],
              ),
            ),

            if (showCancelButton)
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _cancelOrder(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Batalkan Pesanan", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRowWithIcon(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}