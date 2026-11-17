import 'package:flutter/material.dart';
// IMPORTANTE: Asegúrate de que esta ruta apunte a tu HomePage y no a ChatPage
// ignore: depend_on_referenced_packages
import 'package:calma/features/chat/views/home_page.dart'; 
// ignore: depend_on_referenced_packages
import 'package:calma/features/views/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:calma/core/data/database_helper.dart';
// ignore: depend_on_referenced_packages
import 'package:calma/core/models/usuario.dart';

class SessionWrapper extends StatefulWidget {
  const SessionWrapper({super.key});

  @override
  State<SessionWrapper> createState() => _SessionWrapperState();
}

class _SessionWrapperState extends State<SessionWrapper> {

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  void _checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId != null) {
      final user = await DatabaseHelper.instance.database.then(
        (db) async {
          final result = await db.query(
            'users',
            where: 'id = ?',
            whereArgs: [userId],
          );

          if (result.isNotEmpty) {
            return Usuario.fromMap(result.first);
          }
          return null;
        },
      );

      if (user != null && mounted) {
        // AQUÍ ESTÁ LA CORRECCIÓN: Navegamos a HomePage para evitar pedir onChatStateChanged
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage(user: user)),
        );
      }
    } else {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}