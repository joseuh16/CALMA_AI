import 'package:flutter/material.dart';
import 'package:iasuice/chat_AI/chat_page.dart';
import 'package:iasuice/login_IA/login.dart';
//import 'package:iasuice/login_IA/login.dart';
import 'package:iasuice/register_scren/register_screen.dart';




void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       //home: const ChatPage(),
      home: const LoginScreen(),
      routes: {
        'register':(context)=> const RegisterScreen(),
      },
     
    );
  }
}
