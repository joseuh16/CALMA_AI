import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegresarBtn extends StatelessWidget {
  final VoidCallback onTap;
  
  const RegresarBtn({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Material(
        color: Colors.transparent, 
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact(); 
            onTap();
          },
          borderRadius: BorderRadius.circular(12),
          // ignore: deprecated_member_use
          splashColor: Colors.white.withOpacity(0.2), 
          // ignore: deprecated_member_use
          highlightColor: Colors.white.withOpacity(0.1),
          child: Ink(
            padding: const EdgeInsets.all(10), 
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20, 
            ),
          ),
        ),
      ),
    );
  }
}