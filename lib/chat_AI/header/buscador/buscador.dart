// ignore_for_file: use_super_parameters, deprecated_member_use

import 'package:flutter/material.dart';

class Buscador extends StatelessWidget {
  const Buscador({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // en este aparato haremos el buscador de chat 
    return Container(
      margin: const EdgeInsets.only(top:45),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 50,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset:  const Offset(0, 4)
          )
        ]
      ),
         child: const TextField(
          decoration: InputDecoration(
            icon: Icon(Icons.search),
            hintText: 'Buscar Chat ...',
            hintStyle: TextStyle( 
               fontFamily: 'serif',
                fontStyle: FontStyle.italic,),
            border: InputBorder.none
          ),
         ),
    );
  }
}
