import 'package:flutter/material.dart';
// Creacion de esperar el mensaje 
class TypingDots extends StatefulWidget {
  const TypingDots({super.key});

  @override
  State<TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this,duration: const Duration(milliseconds: 2000),)..repeat();}

  @override
  void dispose() {_controller.dispose();super.dispose();}

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        margin: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),),

        child: const Text("• • •", style: TextStyle(fontSize: 22,color: Colors.black54,letterSpacing: 2,),),
      ),
    );
  }
}