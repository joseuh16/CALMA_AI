import 'package:flutter/material.dart';
import 'package:iasuice/chat_AI/header/Avatar/cerrar_scesion.dart';
import 'package:iasuice/chat_AI/header/buscador/buscador.dart';
import 'package:iasuice/chat_AI/header/regresar/regresar.dart';
import 'package:iasuice/login_IA/models/usuario.dart';

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
      height: mostrarBuscador ? 240 : 270, // Altura reducida
      width: double.infinity,
      padding: const EdgeInsets.only(top: 25, left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.amber, // Morado
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(45),
          bottomRight: Radius.circular(45),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    "Hola ${user}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // FILA CON TÍTULO Y AVATAR
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  // boton Regresar
                  if (mostrarRegresar) Regresar(onTap: onRegresar),
                  if (mostrarRegresar) const SizedBox(width: 10),

                  // Título con ícono
                  const Icon(Icons.chat, color: Colors.white, size: 32),
                  const SizedBox(width: 10),
                  const Text(
                    'Tus chat',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // llamamos a cerrar cesion
              const CerrarScesion(),
            ],
          ),
          if (mostrarBuscador) const Buscador()
        ],
      ),
    );
  }
}
