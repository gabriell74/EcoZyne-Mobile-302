import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class ProductCheckoutDetail extends StatefulWidget {

  const ProductCheckoutDetail({super.key});

  @override
  State<ProductCheckoutDetail> createState() => _ProductCheckoutDetailState();
}

class _ProductCheckoutDetailState extends State<ProductCheckoutDetail> {
  int quantity = 1;

  final int price = 25000;

  String productName = "Eco Enzyme Botol 500ml";

  int get total => quantity * price;

  void _increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomText(
          "Detail Produk",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.local_drink, color: Color(0xFF55C173)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(productName,
                        fontSize: 16, fontWeight: FontWeight.bold),
                    const SizedBox(height: 4),
                    CustomText("Rp 25.000",
                        fontSize: 14, color: Colors.grey[700]),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: _decreaseQuantity,
                  ),
                  CustomText("$quantity",
                      fontSize: 16, fontWeight: FontWeight.bold),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: _increaseQuantity,
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                "Total (${quantity.toString()} item)",
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              CustomText(
                "Rp ${total.toString()}",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF55C173),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
