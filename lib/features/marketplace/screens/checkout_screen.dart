import 'package:ecozyne_mobile/core/utils/validators.dart';
import 'package:ecozyne_mobile/core/widgets/build_form_field.dart';
import 'package:ecozyne_mobile/core/widgets/confirmation_dialog.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/core/widgets/top_snackbar.dart';
import 'package:ecozyne_mobile/features/marketplace/widgets/product_checkout_detail.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  void _submitCheckout() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
          "Apakah anda yakin memesan produk ini?",
          onTap: () {
            Navigator.pop(context);
            showSuccessTopSnackBar(
              context,
              "Berhasil Membuat Order",
              icon: const Icon(Icons.shopping_bag),
            );

            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(context);
              Navigator.pop(context);
            });
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: const Color(0xFF55C173),
        title: const CustomText("Checkout", fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(
                "Informasi Pembeli",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 16),
              BuildFormField(
                label: "Nama Lengkap",
                controller: _nameController,
                validator: Validators.name,
                prefixIcon: Icons.person_outline,
              ),
              BuildFormField(
                label: "Nomor WhatsApp",
                controller: _phoneController,
                validator: Validators.whatsapp,
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_outlined,
              ),
              BuildFormField(
                label: "Alamat Lengkap",
                controller: _addressController,
                validator: Validators.address,
                maxLines: 3,
                prefixIcon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 24),
              ProductCheckoutDetail(),
              const SizedBox(height: 60),

              SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      _submitCheckout();
                    },
                    child: const CustomText(
                      "Buat Order",
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
