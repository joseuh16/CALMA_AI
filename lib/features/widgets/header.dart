import 'package:flutter/material.dart';

// OJO AQUÍ: Asegúrate de que estas rutas apunten a los nuevos archivos que creamos

import '../../settings/views/cerrar_cesion/cerrar_scesion.dart';
import '../../settings/views/cerrar_cesion/regresar.dart';

class Header extends StatelessWidget {
  final bool mostrarBuscador;
  final bool mostrarRegresar;
  final VoidCallback onRegresar;
  final String user;

  const Header({
    super.key,
    required this.mostrarBuscador,
    required this.mostrarRegresar,
    required this.onRegresar,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mostrarBuscador ? 190 : 130,
      width: double.infinity,
      // MANTENEMOS EL MARGEN DE 15 PÍXELES
      margin: const EdgeInsets.all(15), 
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        // ✨ APLICAMOS EL DEGRADADO AZUL Y VERDE PROFESIONAL
        gradient: const LinearGradient(
          colors: [Color(0xFF9BBDF9), Color(0xFF8DE0D1)], 
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        // MANTENEMOS LAS ESQUINAS REDONDEADAS
        borderRadius: BorderRadius.circular(30), 
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: const Color(0xFF9BBDF9).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // FILA 1: Saludo al usuario (FONDO TRANSPARENTE, toma el degradado del contenedor)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Hola $user",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // FILA 2: Botón regresar, Título y Avatar (Cerrar sesión)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  // Llamamos al nuevo RegresarBtn
                  if (mostrarRegresar) RegresarBtn(onTap: onRegresar),
                  if (mostrarRegresar) const SizedBox(width: 10),

                  // Título con ícono y texto
                  const Icon(Icons.chat, color: Colors.white, size: 32),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tus chats',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Tu espacio con calma',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              // Llamamos al nuevo CerrarSesionBtn optimizado
              const CerrarSesionBtn(),
            ],
          ),
        ],
      ),
    );
  }
}