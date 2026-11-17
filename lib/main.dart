import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
// ignore: depend_on_referenced_packages
import 'package:calma/features/views/login.dart';
// ignore: depend_on_referenced_packages
import 'package:calma/features/views/register_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:calma/features/chat/views/home_page.dart';
// ignore: depend_on_referenced_packages
import 'package:calma/core/models/usuario.dart';
import './features/chat/views/notificaciones/notificaciones.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthenticationWrapper(),
      routes: {'register': (context) => const RegisterScreen()},
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasData && snapshot.data != null) {
          final User firebaseUser = snapshot.data!;

          // Cambiamos a StreamBuilder para que Firestore "empuje" los datos en cuanto conecte
          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('usuarios').doc(firebaseUser.uid).snapshots(),
            builder: (context, userSnapshot) {
              // Si está cargando y no hay datos previos, mostramos carga
              if (userSnapshot.connectionState == ConnectionState.waiting && !userSnapshot.hasData) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }

              // Lógica de nombre con prioridades
              String nombreReal = "Usuario";

              // Prioridad 1: Firestore
              if (userSnapshot.hasData && userSnapshot.data!.exists) {
                final data = userSnapshot.data!.data() as Map<String, dynamic>?;
                if (data != null && data['nombre'] != null && data['nombre'].toString().trim().isNotEmpty) {
                  nombreReal = data['nombre'].toString().trim();
                } 
                // Prioridad 2: Auth Display Name
                else if (firebaseUser.displayName != null && firebaseUser.displayName!.trim().isNotEmpty) {
                  nombreReal = firebaseUser.displayName!;
                }
              } else {
                // Prioridad 3: Si no hay Firestore aún, intentar Auth
                if (firebaseUser.displayName != null && firebaseUser.displayName!.trim().isNotEmpty) {
                  nombreReal = firebaseUser.displayName!;
                }
              }

              final usuarioParaApp = Usuario(
                id: firebaseUser.uid,
                nombres: nombreReal,
                email: firebaseUser.email ?? '',
                telefono: 'No registrado',
                password: '',
              );

              return HomePage(user: usuarioParaApp);
            },
          );
        }
        return const LoginScreen();
      },
    );
  }
}