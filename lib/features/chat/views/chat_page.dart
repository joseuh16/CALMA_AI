import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:calma/features/chat/views/chat_body.dart';
// ignore: depend_on_referenced_packages
import 'package:calma/core/data/database_helper.dart';
// ignore: depend_on_referenced_packages
import 'package:calma/core/models/usuario.dart';
import 'chat_logo.dart';
import '../widgets/header.dart';

class ChatPage extends StatefulWidget {
  final Usuario user;
  // NUEVO: Agregamos esta función para avisarle al HomePage
  final Function(bool isChatActive) onChatStateChanged; 

  const ChatPage({
    super.key,
    required this.user,
    required this.onChatStateChanged, // NUEVO
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _chatActivo = false;
  int? _chatId;

  Future<void> _iniciarChat() async {
    final id = await DatabaseHelper.instance.createChat(
      widget.user.id!,
      "Reflexión ${DateTime.now().day}/${DateTime.now().month}", 
    );

    setState(() {
      _chatId = id;
      _chatActivo = true;
    });
    widget.onChatStateChanged(true); // NUEVO: Avisa que oculte la barra
  }

  void _abrirChatExistente(int chatId) {
    setState(() {
      _chatId = chatId;
      _chatActivo = true;
    });
    widget.onChatStateChanged(true); // NUEVO: Avisa que oculte la barra
  }

  void _regresarChat() {
    setState(() {
      _chatActivo = false;
      _chatId = null;
    });
    widget.onChatStateChanged(false); // NUEVO: Avisa que vuelva a mostrar la barra
  }

  // ... DE AQUÍ EN ADELANTE, DEJA TU CÓDIGO @override Widget build EXACTAMENTE IGUAL ...

  @override
  Widget build(BuildContext context) {
    return Container(
      // GRADIENTE AZUL PASTEL: Transmite calma y profundidad
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFE3F2FD), // Azul pastel muy claro
            Color(0xFFBBDEFB), // Azul cielo suave
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Permite ver el gradiente
        body: SafeArea( // SafeArea asegura que no choque con los bordes del teléfono
          child: Column(
            children: [
              // MANTENEMOS TU HEADER INTACTO
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Header(
                  mostrarBuscador: !_chatActivo,
                  mostrarRegresar: _chatActivo,
                  onRegresar: _regresarChat,
                  user: widget.user.nombres,
                ),
              ),
              const SizedBox(height: 10),

              // CONTENEDOR PRINCIPAL BLANCO CON BORDES SUAVES
              Expanded(
                child: ClipPath(
                  clipper: CurvedBorderClipper(),
                  child: Container(
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.95), // Blanco casi puro, sin deslumbrar
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.blueAccent.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: _chatActivo && _chatId != null
                        ? ChatBody(
                            user: widget.user,
                            chatId: _chatId!,
                          )
                        : ChatLogo(
                            userId: widget.user.id!,
                            onIniciarChat: _iniciarChat,
                            onAbrirChat: _abrirChatExistente,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Borde curvado más sutil
class CurvedBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 30); // Curva más suave
    path.quadraticBezierTo(size.width / 2, 0, size.width, 30);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}