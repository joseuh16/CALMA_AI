// animaciones_chat_body/chat_floating_animated.dart
import 'package:flutter/material.dart';

class ChatFloatingAnimated extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  
  const ChatFloatingAnimated({
    super.key,
    required this.onPressed,
    this.text = 'Toca Para Escribir mensaje...',
  });

  @override
  State<ChatFloatingAnimated> createState() => _ChatFloatingAnimatedState();
}

class _ChatFloatingAnimatedState extends State<ChatFloatingAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            _animationController.forward().then((_) {
              _animationController.reverse();
              widget.onPressed();
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFD54F),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 4,
            // ignore: deprecated_member_use
            shadowColor: Colors.black.withOpacity(0.3),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.edit,
                color: Colors.black87,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                widget.text,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}