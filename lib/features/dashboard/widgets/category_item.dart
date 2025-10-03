import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final Color color;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.color,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: color,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 50,
              height: 50,
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        CustomText(label, fontSize: 12),
      ],
    );
  }
}
