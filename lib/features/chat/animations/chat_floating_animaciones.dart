import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 1. WIDGET DE ESTADO: Solo maneja la lógica de la animación
class ChatFloatingAnimated extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;

  const ChatFloatingAnimated({
    super.key,
    required this.onPressed,
    this.text = "Toca para escribir mensaje...",
  });

  @override
  State<ChatFloatingAnimated> createState() => _ChatFloatingAnimatedState();
}

class _ChatFloatingAnimatedState extends State<ChatFloatingAnimated>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100), // Ligeramente más rápido = más reactivo
    );

    _scale = Tween(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _tapDown(TapDownDetails details) {
    HapticFeedback.lightImpact();
    _controller.forward();
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }

  void _tapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTapDown: _tapDown,
        onTapUp: _tapUp,
        onTapCancel: _tapCancel,
        child: ScaleTransition(
          scale: _scale,
          child: _FloatingButtonUI(text: widget.text),
        ),
      ),
    );
  }
}

// 2. SUB-WIDGET VISUAL: Solo dibuja el botón (Optimizado con const)
class _FloatingButtonUI extends StatelessWidget {
  final String text;

  const _FloatingButtonUI({required this.text});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(30),
      // Usando un azul que combina con tu app "Calma" en lugar del amarillo
      color: const Color(0xFF86B9E8), 
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 14,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.edit_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}