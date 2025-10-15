import 'package:ecozyne_mobile/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: Colors.grey[700]),
        title: CustomText(
          label,
          fontSize: 16,
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
