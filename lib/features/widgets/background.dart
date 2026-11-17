import 'package:flutter/material.dart';

class RegisterBackground extends StatelessWidget {
  const RegisterBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "imagenes/nat.jpg",
              fit: BoxFit.cover, // llena toda la pantalla
            ),
          ),
          SafeArea(
            child: child,
          ),
        ],
      ),
    );
  }
}