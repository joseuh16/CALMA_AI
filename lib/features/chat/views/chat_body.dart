import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:calma/core/data/database_helper.dart';
// ignore: depend_on_referenced_packages
import 'package:calma/features/chat/animations/Typing_dots.dart';
// ignore: depend_on_referenced_packages
import 'package:calma/features/chat/animations/chat_floating_animaciones.dart';
// ignore: depend_on_referenced_packages
import 'package:calma/core/utils/hora.dart';
// ignore: depend_on_referenced_packages
import 'package:calma/core/models/usuario.dart';
import '../services/n8n_service.dart';
import '../../../chat_AI/chat_message.dart';
import '../../../chat_AI/chat_input.dart';

// --- ARQUITECTURA AISLADA: CAPA DE LÓGICA (ViewModel/Controller) ---
class ChatLogicController extends ChangeNotifier {
  final int chatId;
  List<Map<String, String>> mensajes = [];
  bool botEscribiendo = false;

  ChatLogicController(this.chatId);

  Future<void> cargarChat() async {
    final mensajesDB = await DatabaseHelper.instance.getMessages(chatId);
    
    if (mensajesDB.isEmpty) {
      final saludo = TimeUtils.obtenerSaludoSegunHora();
      final mensajeBienvenida = "$saludo. Soy tu guía de luz. Este es un espacio seguro para ti. ¿Cómo te sientes hoy?";
      
      await DatabaseHelper.instance.insertMessage(
        chatId: chatId, texto: mensajeBienvenida, esUser: false,
      );
      
      mensajes.add({
        "rol": "bot", "texto": mensajeBienvenida, "hora": TimeUtils.obtenerHoraActual()
      });
    } else {
      for (var msg in mensajesDB) {
        mensajes.add({
          "rol": msg['esUser'] == 1 ? "user" : "bot",
          "texto": msg['texto'],
          "hora": TimeUtils.obtenerHoraDesdeFecha(msg['fecha']),
        });
      }
    }
    notifyListeners();
  }

  Future<void> enviarMensaje(String texto) async {
    if (texto.isEmpty) return;

    // 1. Añade mensaje de usuario
    await DatabaseHelper.instance.insertMessage(chatId: chatId, texto: texto, esUser: true);
    mensajes.add({"rol": "user", "texto": texto, "hora": TimeUtils.obtenerHoraActual()});
    botEscribiendo = true;
    notifyListeners();

    // 2. Consulta a la IA
    try {
      final respuesta = await N8NService.enviarMensaje(texto);
      await DatabaseHelper.instance.insertMessage(chatId: chatId, texto: respuesta, esUser: false);
      
      mensajes.add({"rol": "bot", "texto": respuesta, "hora": TimeUtils.obtenerHoraActual()});
    } catch (e) {
      final errorMsg = "Tuvimos un pequeño problema de conexión, pero sigo aquí. ¿Podrías repetirlo?";
      await DatabaseHelper.instance.insertMessage(chatId: chatId, texto: errorMsg, esUser: false);
      mensajes.add({"rol": "bot", "texto": errorMsg, "hora": TimeUtils.obtenerHoraActual()});
    } finally {
      botEscribiendo = false;
      notifyListeners();
    }
  }
}

// --- CAPA DE VISTA (UI) ---
class ChatBody extends StatefulWidget {
  final Usuario user;
  final int chatId;

  const ChatBody({super.key, required this.user, required this.chatId});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late ChatLogicController _logic;
  bool _mostrarInput = false;

  @override
  void initState() {
    super.initState();
    _logic = ChatLogicController(widget.chatId);
    _logic.addListener(_onEstadoCambiado);
    _logic.cargarChat();
  }

  void _onEstadoCambiado() {
    if (mounted) setState(() {});
    _scrollToBottom();
  }

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

  @override
  void dispose() {
    _logic.removeListener(_onEstadoCambiado);
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent, // Asegura que el gradiente o fondo blanco sutil se mantenga
      child: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 140),
              physics: const BouncingScrollPhysics(),
              itemCount: _logic.mensajes.length + (_logic.botEscribiendo ? 1 : 0),
              itemBuilder: (_, index) {
                if (_logic.botEscribiendo && index == _logic.mensajes.length) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 10, left: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TypingDots(), // Tus puntos de carga
                    ),
                  );
                }

                final msg = _logic.mensajes[index];
                return ChatMessage(
                  texto: msg["texto"]!,
                  esUser: msg["rol"] == "user",
                  hora: msg["hora"],
                );
              },
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _mostrarInput
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: ChatInput(
                      controller: _controller,
                      onSend: () {
                        _logic.enviarMensaje(_controller.text.trim());
                        _controller.clear();
                      },
                    ),
                  )
                : const SizedBox(),
          ),
          if (!_mostrarInput)
            ChatFloatingAnimated(
              onPressed: () {
                setState(() => _mostrarInput = true);
                _scrollToBottom();
              },
            ),
        ],
      ),
    );
  }
}