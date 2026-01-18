import 'package:flutter/material.dart';
import 'package:iasuice/chat_AI/animaciones%20_chat_body/Typing_dots.dart';
import 'package:iasuice/chat_AI/animaciones%20_chat_body/chat_floating_animaciones.dart';
import 'package:iasuice/chat_AI/hora_mensaje/hora.dart';
import '../api/n8n_service.dart';
import '../chat_message.dart';
import '../chat_input.dart';

class ChatBody extends StatefulWidget {
  const ChatBody({super.key});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _mensajes = [];
  bool _mostrarInput = false;
  bool _botEscribiendo = false;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _enviarMensaje() async {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;

    setState(() {
      _mensajes.add({
        "rol": "user",
        "texto": texto,
        "hora": HoraMensaje.obtenerHoraActual(),
      });
      _botEscribiendo = true;
    });

    _controller.clear();
    _scrollToBottom();

    try {
      final respuesta = await N8NService.enviarMensaje(texto);

      setState(() {
        _botEscribiendo = false;
        _mensajes.add({
          "rol": "bot",
          "texto": respuesta,
          "hora": HoraMensaje.obtenerHoraActual(),
        });
      });
    } catch (e) {
      setState(() {
        _botEscribiendo = false;
        _mensajes.add({
          "rol": "bot",
          "texto": "⚠️ Error de conexión. Intenta nuevamente.",
          "hora": HoraMensaje.obtenerHoraActual(),
        });
      });
    }

    _scrollToBottom();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final saludo = HoraMensaje.obtenerSaludoSegunHora();

      setState(() {
        _mensajes.add({
          "rol": "bot",
          "texto": "$saludo! Soy tu asistente virtual. ¿En qué puedo ayudarte?",
          "hora": HoraMensaje.obtenerHoraActual(),
        });
      });
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ESPACIO PARA QUE LOS MENSAJES EMPIECEN MÁS ABAJO
        const SizedBox(height: 30),

        // MENSAJES
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 140), // Más espacio arriba
            physics: const BouncingScrollPhysics(),
            itemCount: _mensajes.length + (_botEscribiendo ? 1 : 0),
            itemBuilder: (_, index) {
              // Mostrar animación de escribiendo
              if (_botEscribiendo && index == _mensajes.length) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 10, left: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TypingDots(),
                  ),
                );
              }

              final msg = _mensajes[index];
              return ChatMessage(
                texto: msg["texto"]!,
                esUser: msg["rol"] == "user",
                hora: msg["hora"],
              );
            },
          ),
        ),

        // INPUT
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _mostrarInput
              ? ChatInput(
                  controller: _controller,
                  onSend: _enviarMensaje,
                )
              : const SizedBox(),
        ),

        // BOTÓN FLOTANTE
        if (!_mostrarInput)
          ChatFloatingAnimated(
            onPressed: () {
              setState(() {
                _mostrarInput = true;
              });
              _scrollToBottom();
            },
          ),
      ],
    );
  }
}