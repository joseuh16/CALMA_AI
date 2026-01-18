import 'package:flutter/material.dart';

class Regresar extends StatelessWidget {
  final VoidCallback onTap;
  const Regresar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // En este apartado se hace boton regresar al panel inicial
    return GestureDetector(

      onTap: onTap,
      child:Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color:Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size:22,
        ),
      )
    );
  }
}
