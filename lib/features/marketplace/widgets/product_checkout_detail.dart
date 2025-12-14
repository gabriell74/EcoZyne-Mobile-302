import 'package:ecozyne_mobile/core/utils/price_formatter.dart';
import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:ecozyne_mobile/data/models/product.dart';
import 'package:flutter/material.dart';

class ProductCheckoutDetail extends StatelessWidget {
  final Product product;
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const ProductCheckoutDetail({
    super.key,
    required this.product,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  });

  int get price => product.price;
  int get total => price * quantity;

  bool get isOutOfStock => product.stock <= 0;
  bool get isMaxStock => quantity >= product.stock;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          "Detail Produk",
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF55C173).withValues(alpha: 0.2),
                          const Color(0xFF55C173).withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.local_drink,
                      color: Color(0xFF55C173),
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          product.productName,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 6),
                        CustomText(
                          price.toCurrency,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF55C173),
                        ),
                        const SizedBox(height: 4),
                        CustomText(
                          isOutOfStock
                              ? "Stok habis"
                              : "Stok tersedia: ${product.stock}",
                          fontSize: 12,
                          color: isOutOfStock
                              ? Colors.red
                              : Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Divider(color: Colors.grey.shade200),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    "Jumlah",
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: quantity > 1 ? onDecrease : null,
                        child: _circleButton(
                          icon: Icons.remove,
                          enabled: quantity > 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomText(
                          "$quantity",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap:
                        (!isOutOfStock && !isMaxStock) ? onIncrease : null,
                        child: _circleButton(
                          icon: Icons.add,
                          enabled: !isOutOfStock && !isMaxStock,
                          isPrimary: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF55C173).withValues(alpha: 0.08),
                const Color(0xFF55C173).withValues(alpha: 0.03),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    "Total Pembayaran",
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                  const SizedBox(height: 4),
                  CustomText(
                    "$quantity item",
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
              CustomText(
                total.toCurrency,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF55C173),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _circleButton({
    required IconData icon,
    required bool enabled,
    bool isPrimary = false,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: enabled
            ? (isPrimary ? const Color(0xFF55C173) : Colors.grey.shade200)
            : Colors.grey.shade100,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 18,
        color: enabled ? Colors.black87 : Colors.grey.shade400,
      ),
    );
  }
}