// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback? onClose;

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSend,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Campo de texto
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Escribe un mensaje...',
                  border: InputBorder.none,
                  isCollapsed: true,
                ),
                maxLines: 4,
                minLines: 1,
                style: const TextStyle(fontSize: 16),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
              ),
            ),
          ),
          
          const SizedBox(width: 10),
          
          // Botón enviar
          Container(
            decoration: BoxDecoration(
               color: const Color.fromARGB(255, 21, 22, 4), // Color de tu app
             // color: const Color(0xFF5B61B9), // Color de tu app
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Color.fromARGB(255, 233, 210, 4), size: 22),
              onPressed: onSend,
              padding: const EdgeInsets.all(10),
            ),
          ),
        ],
      ),
    );
  }
}