import 'package:flutter/material.dart';

class InputTengoCuenta extends StatelessWidget {
  const InputTengoCuenta({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "¿Ya tienes una cuenta? ",
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context); // Vuelve al login
          },
          child: const Text(
            "Iniciar sesión",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A89A6), // Color azul de la imagen
            ),
          ),
        ),
      ],
    );
  }
}