import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:calma/core/data/database_helper.dart';
// ignore: depend_on_referenced_packages
import 'package:calma/features/chat/animations/chat_floating.dart';

class ChatLogo extends StatefulWidget {
  // ✨ CORRECCIÓN AQUÍ: Cambiamos 'int' por 'String'
  final String userId; 
  final Future<void> Function() onIniciarChat;
  final Function(int) onAbrirChat;

  const ChatLogo({
    super.key,
    required this.userId,
    required this.onIniciarChat,
    required this.onAbrirChat,
  });

  @override
  State<ChatLogo> createState() => _ChatLogoState();
}

class _ChatLogoState extends State<ChatLogo> {
  late Future<List<Map<String, dynamic>>> chatsFuture;

  @override
  void initState() {
    super.initState();
    _cargarChats();
  }

  void _cargarChats() {
    chatsFuture = DatabaseHelper.instance.getChats(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 20),
            /// LISTA DE CHATS ARRIBA (Estilo suave)
            SizedBox(
              height: 100,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: chatsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFF81D4FA)));
                  }
                  
                  final lista = snapshot.data ?? [];

                  if (lista.isEmpty) {
                    return const Center(
                      child: Text(
                        "Tu espacio está listo para escucharte",
                        style: TextStyle(color: Color(0xFF90CAF9), fontSize: 14),
                      )
                    );
                  }

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: lista.length,
                    itemBuilder: (context, index) {
                      final chat = lista[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: GestureDetector(
                          onTap: () => widget.onAbrirChat(chat['id']),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFFBBDEFB), width: 2),
                                ),
                                child: CircleAvatar(
                                  radius: 28,
                                  backgroundColor: const Color(0xFFE3F2FD),
                                  child: Text(
                                    chat['titulo'][0].toUpperCase(),
                                    style: const TextStyle(
                                      color: Color(0xFF64B5F6),
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: 70,
                                child: Text(
                                  chat['titulo'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 12, 
                                    color: Color(0xFF546E7A),
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            /// CONTENIDO CENTRAL (Ahora scrolleable para evitar Overflow)
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Image.asset(
                      'imagenes/Animacion.png', // Tu imagen de las manos con el corazón
                      height: 220,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 30),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4FAFF), // Fondo azul extremadamente pálido
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: const Color(0xFF90CAF9).withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Column(
                        children: [
                          Text(
                            'No estás solo.',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF455A64), // Gris azulado, menos agresivo que el negro
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Estamos aquí para ti.\nTómate tu tiempo, respira y hablemos cuando estés listo.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF78909C),
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 120), // Espacio para el botón flotante
                  ],
                ),
              ),
            ),
          ],
        ),

        /// BOTÓN FLOTANTE
        Positioned(
          bottom: 30,
          left: 20,
          right: 20,
          child: ChatFloatingButton(
            onTap: () async {
              await widget.onIniciarChat();
              setState(() => _cargarChats());
            },
          ),
        ),
      ],
    );
  }
}