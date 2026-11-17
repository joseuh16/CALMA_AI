import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:calma/core/data/database_helper.dart';
// ignore: depend_on_referenced_packages
import 'package:calma/core/models/usuario.dart';

// ✨ IMPORTANTE: Importamos tu servicio de Firebase
// (Asegúrate de que el nombre del archivo coincida, en tus errores anteriores decía "firabase_service.dart")
// ignore: depend_on_referenced_packages
import 'package:calma/core/data/firabase_service.dart'; 

// Importa tus widgets
import '../widgets/background.dart'; 
import '../widgets/input_nombre.dart';
import '../widgets/input_correo.dart';
import '../widgets/input_password.dart';
import '../widgets/input_telefono.dart';
import '../widgets/register_button.dart';
import '../widgets/input_tengo_cuenta.dart';
import '../widgets/Custom_snackbar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final nombreCtrl = TextEditingController();
  final correoCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final telCtrl = TextEditingController();

  bool _isLoading = false; 

  // ignore: non_constant_identifier_names
  Future<void> _Register() async {
    // 1. Validar formulario
    if (!_formKey.currentState!.validate()) {
      CustomSnackBar.showWarning(context, "Por favor, llena los campos correctamente.");
      return;
    }

    // 2. Iniciar estado de carga
    setState(() {
      _isLoading = true;
    });

    final nombre = nombreCtrl.text.trim();
    final email = correoCtrl.text.trim();
    final password = passCtrl.text.trim();
    final telefono = telCtrl.text.trim();

    try {
      // 3. Instanciar FirebaseService
      final firebaseService = FirebaseService();

      // 4. Registrar en Firebase (LA NUBE ☁️)
      final userCredential = await firebaseService.registrarUsuario(email, password, nombre);

      if (userCredential != null && userCredential.user != null) {
        // 5. Si Firebase fue exitoso, guardamos en SQLite (LOCAL 📱) con el ID de Firebase
        final nuevoUsuario = Usuario(
          id: userCredential.user!.uid, // ✨ ¡AQUÍ ESTÁ LA MAGIA!
          nombres: nombre,
          email: email,
          telefono: telefono,
          password: password,
          profileImage: "",
        );

        await DatabaseHelper.instance.registerUser(nuevoUsuario);
        
        if (!mounted) return;
        
        // 6. Mostrar éxito
        CustomSnackBar.showSuccess(context, "¡Usuario registrado con éxito en la nube!");
        
        // 7. Esperamos un poquito y volvemos al Login
        await Future.delayed(const Duration(seconds: 1));
        
        if (!mounted) return;
        Navigator.pop(context);
      } else {
        // Firebase devolvió null (ej. el correo ya existe o la contraseña es muy débil)
        if (!mounted) return;
        CustomSnackBar.showError(context, "Error: El correo ya está en uso o es inválido.");
      }

    } catch (e) {
      if (!mounted) return;
      CustomSnackBar.showError(context, "Error: Ocurrió un problema al registrarte.");
    } finally {
      // 8. Apagar el botón de carga
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RegisterBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Icon(Icons.eco, size: 45, color: Color(0xFF86B4B3)),
                  const Text(
                    "Calma",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7CAFB4),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Creando un espacio seguro para ti.",
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  const SizedBox(height: 35),

                  InputNombre(controller: nombreCtrl),
                  const SizedBox(height: 20),

                  InputCorreo(controller: correoCtrl),
                  const SizedBox(height: 20),

                  InputPassword(controller: passCtrl),
                  const SizedBox(height: 20),

                  InputTelefono(controller: telCtrl),
                  const SizedBox(height: 40),

                  RegisterButton(
                    onPressed: _Register,
                    isLoading: _isLoading, 
                  ),
                  const SizedBox(height: 20),

                  const InputTengoCuenta(),
                  const SizedBox(height: 50),

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
      ),
    );
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    correoCtrl.dispose();
    passCtrl.dispose();
    telCtrl.dispose();
    super.dispose();
  }
}