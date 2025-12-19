import 'package:ecozyne_mobile/core/utils/user_helper.dart';
import 'package:ecozyne_mobile/core/widgets/confirmation_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/loading_widget.dart';
import 'package:ecozyne_mobile/core/widgets/login_required_dialog.dart';
import 'package:ecozyne_mobile/data/models/waste_bank.dart';
import 'package:ecozyne_mobile/data/providers/trash_transaction_provider.dart';
import 'package:ecozyne_mobile/data/providers/user_provider.dart';
import 'package:ecozyne_mobile/features/waste_bank/widgets/map_selection_widget.dart';
import 'package:ecozyne_mobile/features/waste_bank/widgets/waste_bank_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class WasteBankDetailScreen extends StatefulWidget {
  final WasteBank wasteBank;
  const WasteBankDetailScreen({super.key, required this.wasteBank});

  @override
  State<WasteBankDetailScreen> createState() => _WasteBankDetailScreenState();
}

class _WasteBankDetailScreenState extends State<WasteBankDetailScreen> {
  late final MapController _mapController;
  late final LatLng _bankLocation;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _bankLocation = LatLng(
      widget.wasteBank.latitude,
      widget.wasteBank.longitude,
    );
  }

  Future<void> _showConfirmDialog(BuildContext context, int wasteBankId) async {
    final userProvider = context.read<UserProvider>();
    final bool isMyWasteBank = widget.wasteBank.id == userProvider.user?.wasteBank?.id;

    if (isMyWasteBank) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.business_outlined,
                  color: Colors.orange[700],
                  size: 60,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Tidak dapat setor sampah\ndi bank sampah Anda sendiri",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmationDialog(
        "Anda yakin memilih Bank Sampah ini?",
        onTap: () => Navigator.pop(context, true),
      ),
    );

    if (confirmed != true) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LoadingWidget(height: 100),
    );

    final provider = context.read<TrashTransactionProvider>();

    final success = await provider.submitTrashSubmissions(wasteBankId);

    if (!mounted) return;
    Navigator.pop(context);

    if (success) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 60,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Berhasil memilih\nBank Sampah",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: Colors.red,
                  size: 60,
                ),
                const SizedBox(height: 16),
                Text(
                  provider.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    final bool isMyWasteBank = widget.wasteBank.id == userProvider.user?.wasteBank?.id;
    final bool isLoggedIn = UserHelper.isLoggedIn(context);

    final bool isButtonEnabled = !isMyWasteBank;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText("Bank Sampah", fontWeight: FontWeight.bold, fontSize: 18),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: MapSelectionWidget(
                      showInfoLocation: false,
                      mapController: _mapController,
                      defaultCenter: _bankLocation,
                      defaultZoom: 15,
                      batamBounds: LatLngBounds(
                        LatLng(0.91, 103.50),
                        LatLng(1.30, 104.20),
                      ),
                      selectedLocation: _bankLocation,
                      onLocationSelected: (_) {},
                    ),
                  ),

                  const SizedBox(height: 16),

                  WasteBankDetailCard(
                    name: widget.wasteBank.wasteBankName,
                    location: widget.wasteBank.wasteBankLocation,
                    imageUrl: widget.wasteBank.photo,
                    isMyBank: isMyWasteBank
                  ),

                  SizedBox(height: 12),

                  CustomText(
                    "Tentang Bank Sampah",
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),

                  SizedBox(height: 12),

                  CustomText(
                    widget.wasteBank.notes,
                    textAlign: TextAlign.start,
                  ),

                  if (isMyWasteBank) ...[
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.orange.shade700),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Ini adalah bank sampah Anda. "
                                  "Anda tidak dapat setor sampah di sini.",
                              style: TextStyle(
                                color: Colors.orange.shade800,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getButtonColor(
                      isMyWasteBank: isMyWasteBank,
                    ),
                  ),
                  onPressed: !isButtonEnabled
                      ? null
                      : () async {
                    if (!isLoggedIn) {
                      showDialog(
                        context: context,
                        builder: (context) => LoginRequiredDialog(),
                      );
                      return;
                    }

                    await _showConfirmDialog(context, widget.wasteBank.id);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_getButtonIcon(
                        isMyWasteBank: isMyWasteBank,
                      )),
                      SizedBox(width: 8),
                      CustomText(
                        _getButtonText(
                          isMyWasteBank: isMyWasteBank,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getButtonColor({
    required bool isMyWasteBank,
  }) {
    if (isMyWasteBank) return Colors.orange.shade700;
    return const Color(0xFF55C173);
  }

  IconData _getButtonIcon({
    required bool isMyWasteBank,
  }) {
    if (isMyWasteBank) return Icons.business_outlined;
    return Icons.recycling_outlined;
  }

  String _getButtonText({
    required bool isMyWasteBank,
  }) {
    if (isMyWasteBank) return "Bank Sampah Anda";
    return "Setor Sampah";
  }
}