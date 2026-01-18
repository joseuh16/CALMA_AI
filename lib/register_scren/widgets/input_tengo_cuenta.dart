import 'package:flutter/material.dart';

class InputTengoCuenta extends StatelessWidget {
  const InputTengoCuenta({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context); // vuelve al login
      },
      child: const Text(
        '¿Ya tengo cuenta?',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic,
          color: Colors.black87,
        ),
      ),
    );
  }
}
