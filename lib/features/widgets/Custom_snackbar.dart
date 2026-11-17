import 'package:flutter/material.dart';

class CustomSnackBar {
  static void show(BuildContext context, {
    required String message,
    required IconData icon,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Oculta el anterior si existe
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.all(20),
        elevation: 6,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    show(
      context, // <-- Aquí pasamos el context directamente (posicional)
      message: message,
      icon: Icons.check_circle_outline,
      backgroundColor: const Color(0xFF86B4B3), // Color de tu app
    );
  }

  static void showError(BuildContext context, String message) {
    show(
      context, // <-- Aquí igual
      message: message,
      icon: Icons.error_outline,
      backgroundColor: Colors.redAccent.shade400,
    );
  }

  static void showWarning(BuildContext context, String message) {
    show(
      context, // <-- Y aquí también
      message: message,
      icon: Icons.warning_amber_rounded,
      backgroundColor: Colors.orangeAccent.shade400,
    );
  }
}