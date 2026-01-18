import 'package:flutter/material.dart';

class AvatarLogin extends StatelessWidget {
  const AvatarLogin({super.key});
  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person,
        size: 50,
        color: Colors.black54
      ),
    );
  }
}
