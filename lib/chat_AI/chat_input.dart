import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 1. WIDGET PRINCIPAL (Director de orquesta)
class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // Añadimos padding para que "flote" sobre la barra inferior
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 16.0, top: 8.0),
        child: _InputContainer(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const _LeadingIcon(), // Icono de lápiz (Izquierda)
              const SizedBox(width: 12),
              Expanded(
                child: _CustomTextField( // Campo de texto (Centro)
                  controller: controller,
                  onSend: onSend,
                ),
              ),
              _SendButton(onSend: onSend), // Botón enviar (Derecha)
            ],
          ),
        ),
      ),
    );
  }
}

// 2. SUB-WIDGET: Contenedor visual (Gradiente y sombra tipo cápsula)
class _InputContainer extends StatelessWidget {
  final Widget child;

  const _InputContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40), // Forma redonda de píldora
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF86B9E8), // Azul de la izquierda
            Color(0xFFE5F1FC), // Blanco difuminado del centro
            Color(0xFF86B9E8), // Azul de la derecha
          ],
        ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.blue.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}

// 3. SUB-WIDGET: Círculo blanco con lápiz azul
class _LeadingIcon extends StatelessWidget {
  const _LeadingIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.edit,
        color: Color(0xFF5D95F9), // Azul del icono
        size: 20,
      ),
    );
  }
}

// 4. SUB-WIDGET: Campo de texto sin bordes (Transparente)
class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _CustomTextField({
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 4,
      minLines: 1,
      style: const TextStyle(
        fontSize: 16,
        color: Color(0xFF2C3E50), // Color del texto al escribir
      ),
      textInputAction: TextInputAction.send,
      onSubmitted: (_) => onSend(),
      decoration: const InputDecoration(
        hintText: 'Cuéntame lo que gustes...',
        hintStyle: TextStyle(
          color: Color.fromARGB(255, 0, 0, 0), // Color azul del hint
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
        border: InputBorder.none, // Quitamos las líneas nativas de Flutter
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }
}

// 5. SUB-WIDGET: Botón de enviar (Triángulo/Flecha)
class _SendButton extends StatelessWidget {
  final VoidCallback onSend;

  const _SendButton({required this.onSend});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.send_rounded,
        color: Color(0xFF3377F6), // Azul un poco más fuerte para destacar
        size: 26,
      ),
      onPressed: () {
        HapticFeedback.lightImpact(); // Vibración sutil al enviar
        onSend();
      },
    );
  }
}