import 'package:flutter/material.dart';

class Fondologin extends StatelessWidget {
  final Widget child;
  const Fondologin ({super.key,required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fondo
        Positioned.fill(
          child: Image.asset("imagenes/nat.jpg", fit: BoxFit.cover), // Asegúrate de que la extensión sea correcta (.jpg o .jpeg)
        ),
        // Contenido
        SafeArea(
          child: child,
        ),
      ],
    );
  }
}