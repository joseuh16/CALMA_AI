import 'package:flutter/material.dart';

class AvatarLogin extends StatelessWidget {
  const AvatarLogin({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Ícono de hojitas (puedes cambiarlo por tu imagen si tienes el logo exacto)
        const Icon(Icons.eco, size: 45, color: Color(0xFF86B4B3)),
        const SizedBox(height: 5),
        const Text(
          "Calma",
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7CAFB4), // Tono turquesa
            letterSpacing: -1.0,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "¡Qué bueno verte de nuevo!",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}