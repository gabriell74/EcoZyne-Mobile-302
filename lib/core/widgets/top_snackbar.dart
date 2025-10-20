import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

void showSuccessTopSnackBar(
    BuildContext context,
    String message, {
      Icon? icon,
    }) {

  final defaultIcon = Icon(
    Icons.check_circle,
    color: Colors.white,
    size: 80,
  );

  final icons = icon != null
      ? Icon(
          icon.icon,
          color: Colors.white,
          size: 80,
        )
      : defaultIcon;

  showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.success(
      backgroundColor: const Color(0xFF55C173),
      icon: icons,
      message: message,
      textStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    ),
    displayDuration: const Duration(seconds: 2),
    animationDuration: const Duration(milliseconds: 600),
  );
}

void showErrorTopSnackBar(BuildContext context, String message) {
  showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.error(
      icon: const Icon(
            Icons.error,
            color: Colors.white,
            size: 80,
          ),
      message: message,
      textStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    ),
    displayDuration: const Duration(seconds: 3),
    animationDuration: const Duration(milliseconds: 600),
  );
}

void showInfoTopSnackBar(
    BuildContext context, String message) {
  showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.info(
      backgroundColor: Colors.blueAccent.shade400,
      icon: const Icon(
            Icons.info,
            color: Colors.white,
            size: 80,
          ),
      message: message,
      textStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    ),
    displayDuration: const Duration(seconds: 3),
    animationDuration: const Duration(milliseconds: 600),
  );
}
