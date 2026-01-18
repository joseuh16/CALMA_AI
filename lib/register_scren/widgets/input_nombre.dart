import 'package:flutter/material.dart';

class InputNombre extends StatelessWidget {
  final TextEditingController controller;

  const InputNombre({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
         style: const TextStyle(
        fontSize: 16,
        fontFamily: 'serif',
        fontStyle: FontStyle.italic
        ),
      decoration:  InputDecoration(
        hintText: "Nombre Completo",
         hintStyle:  const TextStyle(
          fontSize: 16,
          fontFamily: 'serif',
          fontStyle: FontStyle.italic,
          
        ),
        
        filled: true,
        fillColor: Colors.grey,

        //circulo

        prefixIcon: Padding(
          padding: const EdgeInsets.all(10),
          child: CircleAvatar(
            backgroundColor: Colors.black,
            child: Icon(
              Icons.person,
              color: Colors.white
              ),
          ),
        ),
      

      // bordes redondos capsula
       border : OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: BorderSide.none,
       ),
    ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "ingrese su nombre porfavor";
        }
        return null;
      },
    );
  }
}
