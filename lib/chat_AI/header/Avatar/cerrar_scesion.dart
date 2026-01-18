import 'package:flutter/material.dart';
import 'package:iasuice/chat_AI/header/Avatar/mensaje_cerrar.dart';
import 'package:iasuice/login_IA/login.dart';

class CerrarScesion extends StatelessWidget {
  const CerrarScesion({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        mensaje_cerrar(context, () => _cerrarSesion(context));
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.person_outline,
          color: Color(0xFF5B61B9),
          size: 30,
        ),
      ),
    );
  }

  void _cerrarSesion(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }
}
