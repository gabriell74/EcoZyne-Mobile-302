import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class CategoryItem extends StatelessWidget {
  final Color color;
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isLocked;

  const CategoryItem({
    super.key,
    required this.color,
    required this.label,
    required this.icon,
    this.onTap,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null || isLocked;

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : onTap,
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: isDisabled ? 0.2 : 0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: isDisabled ? color.withValues(alpha: 0.5) : color,
                    size: 28,
                  ),
                ),

                if (isLocked)
                  Positioned.fill(
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.lock_outline,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        CustomText(
          label,
          fontSize: 12,
          textAlign: TextAlign.center,
          color: isDisabled ? Colors.grey.withValues(alpha: 0.1) : Colors.grey[800],
        ),
      ],
    );
  }
}