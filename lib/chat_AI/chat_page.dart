import 'package:flutter/material.dart';
import 'package:iasuice/chat_AI/chat/chat_body.dart';
import 'package:iasuice/login_IA/models/usuario.dart';
import 'chat/chat_logo.dart';
import 'header/header.dart';

class ChatPage extends StatefulWidget {
  final User user;
  const ChatPage({super.key, required this.user});
  @override
  State<ChatPage> createState() => _ChatPageState(user: user);
}

class _ChatPageState extends State<ChatPage> {
final User user;
_ChatPageState({required this.user});

  bool _chatActivo = false;


  void _iniciarChat() {
    setState(() {
      _chatActivo = true;
    });
  }

  void _regresarChat() {
    setState(() {
      _chatActivo = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(
        top: 50,
        left: 20,
        right: 20,
        bottom: 20,
        ),
      decoration: BoxDecoration(
        color: Colors.amber,

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Importante: transparente
        body: Column(
          children: [
            // HEADER ARRIBA
            Header(
              mostrarBuscador: !_chatActivo,
              mostrarRegresar: _chatActivo,
              onRegresar: _regresarChat,
              user: user.nombres,
            ),

            // CUERPO DEL CHAT CON TRANSICIÓN SUAVE
            Expanded(
              child: ClipPath(
                clipper: CurvedBorderClipper(),
                child: Container(
                  color: Colors.white,
                  child: _chatActivo
                      ? const ChatBody()
                      : ChatLogo(onIniciarChat: _iniciarChat),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Clipper para la transición curva
class CurvedBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 50);
    path.quadraticBezierTo(size.width / 2, 0, size.width, 50);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}