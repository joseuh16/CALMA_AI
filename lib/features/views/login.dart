import 'package:flutter/material.dart';
import '../../features/chat/views/home_page.dart'; 
// ignore: depend_on_referenced_packages
import 'package:calma/core/models/usuario.dart'; // ✨ IMPORTANTE: Agregamos tu modelo de Usuario

import '../widgets/avatar_login.dart';
import '../widgets/input_field.dart';
import '../widgets/login_button.dart';
import '../widgets/fondo.dart';
import '../widgets/Custom_snackbar.dart';

// Importamos el controlador y el repositorio
import './controller/login_controller.dart'; 
import './controller/auth_repository.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController(); 
  final TextEditingController _passwordController = TextEditingController();
  
  // INYECCIÓN DE DEPENDENCIAS
  late final LoginController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LoginController(authRepository: AuthRepository());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus(); // Esconder teclado

    try {
      // user aquí es de tipo User (de Firebase)
      final user = await _controller.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      CustomSnackBar.showSuccess(context, "¡Bienvenido de nuevo!");
      await Future.delayed(const Duration(milliseconds: 800));
      
      if (!mounted) return;

      // ✨ MAGIA APLICADA: Convertimos el usuario de Firebase a tu modelo Usuario
      final usuarioLocal = Usuario(
        id: user.uid, 
        nombres: user.email?.split('@')[0] ?? 'Usuario', 
        email: user.email ?? '',
        telefono: 'No registrado',
        password: '', // Vacío por seguridad
      );
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(user: usuarioLocal)), // Pasamos el usuario convertido
      );

    // --- MANEJO DE ERRORES OPTIMIZADO (SRP) ---
    } on ValidationException catch (e) {
      if (!mounted) return;
      CustomSnackBar.showWarning(context, e.message);
    } on AuthException catch (e) {
      if (!mounted) return;
      CustomSnackBar.showError(context, e.message);
    } catch (e) {
      if (!mounted) return;
      CustomSnackBar.showError(context, "Ocurrió un error inesperado.");
    }
    // ------------------------------------------
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Fondologin(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const AvatarLogin(),
                const SizedBox(height: 40),

                InputField(
                  label: 'Correo Electrónico',
                  hint: 'Ejemplo: mariouh1173@gmail.com',
                  isPassword: false,
                  controller: _emailController,
                ),
                const SizedBox(height: 20),

                InputField(
                  label: 'Contraseña',
                  hint: 'Ingresa tu contraseña',
                  isPassword: true,
                  controller: _passwordController,
                ),
                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      // Acción para recuperar contraseña
                    },
                    child: const Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                ListenableBuilder(
                  listenable: _controller,
                  builder: (context, child) {
                    return LoginButton(
                      onPressed: _controller.isLoading ? () {} : () => _handleLogin(),
                      isLoading: _controller.isLoading,
                    );
                  },
                ),
                
                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿No tienes una cuenta? ',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'register');
                      },
                      child: const Text(
                        'Regístrate',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A89A6),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 60),

                const Text(
                  "Terms of Service / Privacy Policy",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}