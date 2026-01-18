// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:iasuice/chat_AI/chat_page.dart';
import 'package:iasuice/login_IA/data/database_helper.dart';
import 'widgets/avatar_login.dart';
import 'widgets/input_field.dart';
import 'widgets/login_button.dart';
import 'widgets/footer_links.dart';
import 'widgets/fondo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usuarioController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    String usuario = usuarioController.text.trim();
    String password = passwordController.text.trim();

    if (usuario.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Rellene los campos para continuar")),
      );
    }

    //Buscar en la bd
    final usuarioLog = await DatabaseHelper.instance.loginUser(
      usuario,
      password,
    );
    if (!mounted) return;
    if (usuarioLog != null) {
      //Logro ingresar
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChatPage(user: usuarioLog)),
      );
    } else {
      //Credenciales incorrectas
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Correo o contraseña incorrectos")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Fondologin(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AvatarLogin(),
                const SizedBox(height: 24),

                InputField(
                  hint: 'Usuario',
                  icon: Icons.person,
                  isPassword: false,
                  color: Colors.grey,
                  controller: usuarioController,
                ),
                const SizedBox(height: 16),

                InputField(
                  hint: 'Contraseña',
                  icon: Icons.lock,
                  isPassword: true,
                  color: Colors.grey,
                  controller: passwordController,
                ),
                const SizedBox(height: 8),

                LoginButton( onPressed: _login,),
                const SizedBox(height: 16),

                const FooterLinks(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
