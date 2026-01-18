// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ChatFloatingButton extends StatelessWidget {
  final VoidCallback onTap;

  const ChatFloatingButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      left: 20,
      right: 20,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFD54F), // amarillo suave
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          
          child: Row(
            children: [
              // 🔵 CÍRCULO
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF212121),
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 22,
                ),
              ),

              const SizedBox(width: 14),

              //  TEXTO
              const Expanded(
                child: Text(
                  "Cuéntame lo que gustes…",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'serif',
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              const Icon(
                Icons.chevron_right,
                color: Colors.black54,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
