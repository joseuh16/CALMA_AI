import 'package:flutter/material.dart';

class Fondologin extends StatelessWidget {
  final Widget child;
  const Fondologin ({super.key,required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //fondo
        Positioned.fill(
          child: Image.asset("imagenes/nat.jpeg", fit: BoxFit.cover),
        ),

        // formularios
        SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: child,
              
                ),
              ),
        ),
      ],
            );
    
  }
}
