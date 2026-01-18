import 'package:flutter/material.dart';

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
    return Align(
      alignment: esUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72, // 72% para mejor
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: esUser ? const Color(0xFFDCF8C6) : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: esUser ? const Radius.circular(18) : const Radius.circular(6),
              bottomRight: esUser ? const Radius.circular(6) : const Radius.circular(18),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                texto,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.45,
                  letterSpacing: 0.05,
                ),
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  hora ?? '',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    letterSpacing: 0.3,
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