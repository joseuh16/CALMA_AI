import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool isPassword;
  final Color color;
  final TextEditingController controller;

  const InputField({
    super.key,
    required this.hint,
    required this.icon,
    required this.isPassword,
    required this.color,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: 325, 
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: color, 
        borderRadius: BorderRadius.circular(35),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 12),

          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              textAlign: TextAlign.center, 
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'sans-serif', 
                fontStyle: FontStyle.italic,
                color: Colors.black,
                fontWeight: FontWeight.w500
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(
                  fontSize: 15,
                  fontFamily: 'serif',
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
