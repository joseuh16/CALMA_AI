import 'package:flutter/material.dart';

class InputTelefono extends StatelessWidget {
  final TextEditingController controller;

  const InputTelefono({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
       style: const TextStyle(
        fontSize: 16,
        fontFamily: 'serif',
        fontStyle: FontStyle.italic
        ),
      decoration:  InputDecoration(
        hintText: "Teléfono",
        hintStyle:  const TextStyle(
          fontSize: 16,
          fontFamily: 'serif',
          fontStyle: FontStyle.italic,
          
        ),
        filled: true,
        fillColor: Colors.grey,

        prefixIcon: Padding(
          padding: const EdgeInsets.all(10),
          child: CircleAvatar(
            backgroundColor: Colors.black,
            child: Icon(
              Icons.phone,
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
        if (value == null || value.length < 10) {
          return "Número inválido";
        }
        return null;
      },
    );
  }
}
