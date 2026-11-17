import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading; // Nueva variable de estado

  const RegisterButton({
    super.key, 
    required this.onPressed, 
    this.isLoading = false, // Por defecto es falso
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, 
      height: 55,
      child: ElevatedButton(
        // Si está cargando, deshabilitamos el botón pasando null
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF8ED2C9), 
          // ignore: deprecated_member_use
          disabledBackgroundColor: const Color(0xFF8ED2C9).withOpacity(0.7), // Color atenuado al cargar
          elevation: 2, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: isLoading 
            ? const SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : const Text(
                "Registrarse",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}