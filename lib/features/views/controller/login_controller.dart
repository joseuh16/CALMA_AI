import 'package:flutter/material.dart';
import 'auth_repository.dart';

// --- EXCEPCIONES PERSONALIZADAS ---
class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}
// ----------------------------------

class LoginController extends ChangeNotifier {
  // Inyección de dependencias
  final IAuthRepository _authRepository;
  
  LoginController({required IAuthRepository authRepository}) 
      : _authRepository = authRepository;

  bool isLoading = false;

  Future<dynamic> login(String email, String password) async {
    // 1. Validar campos
    if (email.isEmpty || password.isEmpty) {
      throw ValidationException("Por favor, rellene todos los campos.");
    }

    // 2. Iniciar estado de carga
    isLoading = true;
    notifyListeners();

    try {
      // 3. Simular carga visual (opcional)
      await Future.delayed(const Duration(milliseconds: 1500));

      // 4. Buscar en Firebase a través del repositorio
      final user = await _authRepository.login(email, password);

      if (user != null) {
        // Guardar sesión usando el UID de Firebase
        await _authRepository.saveUserSession(user.uid);
        return user; 
      } else {
        throw AuthException("Usuario o contraseña incorrectos.");
      }
    } catch (e) {
      // Si es un error nuestro, lo dejamos pasar
      if (e is ValidationException || e is AuthException) {
        rethrow;
      }
      // Capturamos el error que viene del AuthRepository
      throw AuthException(e.toString().replaceAll("Exception: ", ""));
    } finally {
      // 5. Apagar carga
      isLoading = false;
      notifyListeners();
    }
  }
}