import 'package:flutter/material.dart';

class InputPassword extends StatefulWidget {
  final TextEditingController controller;

  const InputPassword({super.key, required this.controller});

  @override
  State<InputPassword> createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  bool ocultar = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
        style: const TextStyle(
        fontSize: 16,
        fontFamily: 'serif',
        fontStyle: FontStyle.italic
        ),
      obscureText: ocultar,
      decoration: InputDecoration(
        hintText: "Contraseña",
         hintStyle:  const TextStyle(
          fontSize: 16,
          fontFamily: 'serif',
          fontStyle: FontStyle.italic,
          
        ),
        filled: true,
        fillColor: Colors.grey,
        suffixIcon: IconButton(
          icon: Icon(ocultar ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() => ocultar = !ocultar);
            
          },
          
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10),
          child: CircleAvatar(
            backgroundColor: Colors.black,
            child: Icon(
              Icons.lock,
              color: Colors.white,
            ),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide.none
        ),
      ),
      validator: (value) {
        if (value == null || value.length < 6) {
          return "Mínimo 6 caracteres";
        }
        return null;
      },
    );
  }
}
