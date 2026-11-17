import 'package:flutter/material.dart';

// 1. WIDGET PRINCIPAL
// Responsabilidad: Alinear el mensaje y definir el ancho máximo.
class ChatMessage extends StatelessWidget {
  final String texto;
  final bool esUser;
  final String? hora;

  const ChatMessage({
    super.key,
    required this.texto,
    required this.esUser,
    this.hora,
  });

  @override
  Widget build(BuildContext context) {
    final double maxWidth = MediaQuery.sizeOf(context).width * 0.75;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Align(
        alignment: esUser ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: _MessageBubble(
            esUser: esUser,
            texto: texto,
            hora: hora,
          ),
        ),
      ),
    );
  }
}

// 2. SUB-WIDGET: La forma y color de la burbuja
class _MessageBubble extends StatelessWidget {
  final bool esUser;
  final String texto;
  final String? hora;

  static const double _radius = 20.0;
  static const double _sharp = 4.0;

  const _MessageBubble({
    required this.esUser,
    required this.texto,
    this.hora,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        // Azul celeste suave para el usuario, Blanco para la IA (Idéntico a tu imagen)
        color: esUser ? const Color(0xFFB1D8F5) : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(_radius),
          topRight: const Radius.circular(_radius),
          bottomLeft: Radius.circular(esUser ? _radius : _sharp),
          bottomRight: Radius.circular(esUser ? _sharp : _radius),
        ),
        boxShadow: esUser 
            ? [] // El usuario no lleva sombra en tu diseño
            : [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.08), // Sombra sutil para la IA
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: _MessageContent(texto: texto, hora: hora),
      ),
    );
  }
}

// 3. SUB-WIDGET: Contenido (Texto)
class _MessageContent extends StatelessWidget {
  final String texto;
  final String? hora;

  const _MessageContent({
    required this.texto,
    this.hora,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          texto,
          style: const TextStyle(
            fontSize: 16,
            height: 1.3,
            color: Color(0xFF2C3E50), // Texto oscuro grisáceo para leer bien en ambos fondos
          ),
        ),
        if (hora != null) ...[
          const SizedBox(height: 4),
          _MessageTime(hora: hora!),
        ],
      ],
    );
  }
}

// 4. SUB-WIDGET: Hora
class _MessageTime extends StatelessWidget {
  final String hora;

  const _MessageTime({required this.hora});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 30),
        Text(
          hora,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.black45, // Gris sutil para la hora
          ),
        ),
      ],
    );
  }
}