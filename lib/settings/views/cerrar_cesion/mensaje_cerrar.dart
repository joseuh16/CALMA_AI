import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialogHelper {
  static void mostrarMensajeCerrar(BuildContext context, VoidCallback onCerrar) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: const Color(0xFF5B61B9).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 50,
                  color: Color(0xFF5B61B9),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Mi cuenta",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 30),
              Material(
                color: Colors.transparent,
                child: ListTile(
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    Navigator.pop(context);
                    onCerrar(); // Se ejecuta la acción que le inyectamos
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  // ignore: deprecated_member_use
                  tileColor: const Color(0xFF771912).withOpacity(0.05),
                  leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                  title: const Text(
                    "Cerrar sesión",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.redAccent,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black26),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}