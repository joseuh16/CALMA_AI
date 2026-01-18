import 'package:flutter/material.dart';
import 'package:iasuice/login_IA/data/database_helper.dart';
import 'package:iasuice/login_IA/login.dart';
import 'package:iasuice/login_IA/models/usuario.dart';
import 'package:iasuice/register_scren/widgets/input_tengo_cuenta.dart';
import 'package:image_picker/image_picker.dart';
import 'widgets/background.dart';
import 'widgets/input_nombre.dart';
import 'widgets/input_correo.dart';
import 'widgets/input_password.dart';
import 'widgets/input_telefono.dart';
import 'widgets/terms_checkbox.dart';
import 'widgets/register_button.dart';

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

  String? _rutaImagen;

  bool aceptar = false;

  //Funcion para seleccionar la imagen
  // Future<void> _elegirImagen() async{
  //     final ImagePicker picker = ImagePicker();
  //     final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  //     if(image !=null){
  //       setState(() {
  //         _rutaImagen = image.path;
  //       });
  //     }
  // }

  //Funcion para agregar en la base de datos
  Future<void> _Register() async {
    //Validar que no hayan campos vacios
    if ((!_formKey.currentState!.validate() || !aceptar)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Acepta los términos y llena los campos correctamente")),
      );
      return;
    }

    //Crear un  nuevo objeto usuario
    final nuevoUsuario = User(
      nombres: nombreCtrl.text,
      email: correoCtrl.text,
      telefono: telCtrl.text,
      password: passCtrl.text,
      profileImage: "",
    );

    //Insetar en la bd
    try {
      await DatabaseHelper.instance.registerUser(nuevoUsuario);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("¡Usuario registrado con exito!")),
      );

      //Regresar al login (SI todo sale bien)
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: Algo salio mal")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RegisterBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    "Crear cuenta",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'serif',
                      fontStyle: FontStyle.italic,
                      color: Color.fromARGB(255, 19, 17, 17),
                    ),
                  ),
                  const SizedBox(height: 40),

                  InputNombre(controller: nombreCtrl),
                  const SizedBox(height: 35),

                  InputCorreo(controller: correoCtrl),
                  const SizedBox(height: 35),

                  InputPassword(controller: passCtrl),
                  const SizedBox(height: 35),

                  InputTelefono(controller: telCtrl),
                  const SizedBox(height: 35),

                  TermsCheckbox(
                    value: aceptar,
                    onChanged: (v) => setState(() => aceptar = v!),
                  ),

                  const SizedBox(height: 20),
                  RegisterButton(onPressed: _Register),
                  const SizedBox(height: 10),
                  const InputTengoCuenta(),
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
  // Limpiamos cada controlador
  nombreCtrl.dispose();
  correoCtrl.dispose();
  passCtrl.dispose();
  telCtrl.dispose();
  // Siempre llamar al super.dispose() al final
  super.dispose();
}
}
