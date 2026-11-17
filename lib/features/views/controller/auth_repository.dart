import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// INTERFAZ: Define qué debe hacer el repositorio (Contrato)
abstract class IAuthRepository {
  Future<User?> login(String email, String password);
  Future<void> saveUserSession(String userId);
}

/// IMPLEMENTACIÓN: Cómo lo hace realmente con Firebase
class AuthRepository implements IAuthRepository {
  @override
  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // Retorna el usuario de Firebase
    } on FirebaseAuthException catch (e) {
      // Traducimos los errores de Firebase para tu controlador
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        throw Exception("Correo o contraseña incorrectos.");
      }
      throw Exception(e.message ?? "Error de autenticación en Firebase.");
    }
  }

  @override
  Future<void> saveUserSession(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId); // Firebase usa UIDs (String)
  }
}