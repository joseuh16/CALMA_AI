import 'package:flutter/material.dart';

class InputCorreo extends StatelessWidget {
  final TextEditingController controller;

  const InputCorreo({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
       style: const TextStyle(
        fontSize: 16,
        fontFamily: 'serif',
        fontStyle: FontStyle.italic

        
        ),
      keyboardType: TextInputType.emailAddress,


      decoration:  InputDecoration(
        hintText: "Correo electrónico",
         hintStyle:  const TextStyle(
          fontSize: 16,
          fontFamily: 'serif',
          fontStyle: FontStyle.italic,
          
        ),
        filled: true,
        fillColor: Colors.grey,
        //circle
        prefixIcon:Padding(
          padding: const EdgeInsets.all(10),
          child: CircleAvatar(
            backgroundColor: Colors.black,
            child: Icon(
            Icons.email,
            color:Colors.white,
          ),
          ),
        ),

        //bordes
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide.none,
        ),


      ),
      validator: (value) {
        if (value == null || !value.contains("@")) {
          return "Correo inválido";
        }
        return null;
      },
    );
  }
}
