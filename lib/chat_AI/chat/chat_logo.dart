import 'package:flutter/material.dart';
import 'package:iasuice/chat_AI/chat_floating.dart';

// En este apartado  se hara  la pantalla de inicio que tendra el chat 

class ChatLogo extends StatelessWidget {
  final VoidCallback onIniciarChat;
  const ChatLogo({super.key, required this.onIniciarChat});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height , // Altura extra
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //SizedBox(height: 50),
                // IMAGEN GRANDE
                Image.asset(
                  'imagenes/Animacion.png',
                  height: 270, // Un poco más pequeña
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
                
                // CONTENEDOR PARA EL TEXTO CON FONDO
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'NO estás solo.',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF333333),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Hay esperanza. Estamos aquí para ti.\nSi necesitas ayuda, por favor, pide apoyo.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF666666),
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                //const SizedBox(height: 350), // Espacio para el botón flotante
              ],
            ),
          ),
        ),
        
        // BOTÓN FLOTANTE FIJO
        Positioned(
          bottom: 30,
          left: 20,
          right: 20,
          child: ChatFloatingButton(onTap: onIniciarChat)
            
          
        ),
      ],
    );
  }
}