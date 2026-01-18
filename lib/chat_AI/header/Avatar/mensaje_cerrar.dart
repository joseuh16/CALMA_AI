import 'package:flutter/material.dart';

void mensaje_cerrar(
  BuildContext context,
  VoidCallback onCerrar,
) {
  // MINI PANTALLA
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.person,
              size: 60,
              color: Color(0xFF5B61B9),
            ),
            const SizedBox(height: 10),

            const Text(
              "Mi cuenta",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'serif',
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 40),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Cerrar sesión",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  color: Colors.black87,
                  letterSpacing: 0.5,
                ),
              ),
              onTap: () {
                Navigator.pop(context); // cerrar mini pantalla
                onCerrar(); // Ejecutar acción directamente
              },
            ),
          ],
        ),
      );
    },
  );
}