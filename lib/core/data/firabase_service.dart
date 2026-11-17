import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // --- SECCIÓN SESIÓN Y TOKENS ---

  // Esta función ahora es más robusta para usarse sola o dentro del registro
  Future<void> actualizarTokenUsuario() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        String? token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          await _db.collection('usuarios').doc(user.uid).set({
            'fcmToken': token,
            'ultimaConexion': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
      } catch (e) {
        debugPrint("Error actualizando token: $e");
      }
    }
  }

  // --- SECCIÓN AUTENTICACIÓN (CORREGIDA Y UNIFICADA) ---
  Future<UserCredential?> registrarUsuario(String email, String password, String nombre) async {
    try {
      // 1. Crear el usuario en Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // 2. Actualizar el nombre en el perfil local de Auth inmediatamente
        await userCredential.user!.updateDisplayName(nombre);
        
        // 3. Obtener el token de notificaciones de una vez
        String? token = await FirebaseMessaging.instance.getToken();

        // 4. GUARDAR
        // Esto garantiza que el nombre y el token existan desde el segundo 1
        await _db.collection('usuarios').doc(userCredential.user!.uid).set({
          'nombre': nombre,
          'email': email,
          'uid': userCredential.user!.uid,
          'fcmToken': token,
          'ultimaConexion': FieldValue.serverTimestamp(),
        });
      }
      return userCredential;
    } catch (e) {
      debugPrint("Error en registrarUsuario: $e");
      return null;
    }
  }

  // --- SECCIÓN CHAT GLOBAL ---
  Stream<QuerySnapshot> getChatGlobalStream() {
    return _db.collection('chat_global').orderBy('fecha', descending: true).snapshots();
  }

  Future<String?> enviarMensajeGlobal({
    required String userId,
    required String nombre,
    required String texto,
    File? archivoMultimedia,
    bool esVideo = false,
    Map<String, dynamic>? mensajeRespondido,
  }) async {
    try {
      String? mediaUrl;
      if (archivoMultimedia != null) {
        String ext = esVideo ? 'mp4' : 'jpg';
        final ref = _storage.ref().child('chat_global_media/${DateTime.now().millisecondsSinceEpoch}.$ext');
        await ref.putFile(archivoMultimedia);
        mediaUrl = await ref.getDownloadURL();
      }

      await _db.collection('chat_global').add({
        'userId': userId,
        'nombre': nombre,
        'texto': texto,
        'mediaUrl': mediaUrl,
        'esVideo': esVideo,
        'respondidoA': mensajeRespondido,
        'fecha': FieldValue.serverTimestamp(),
      });
      return mediaUrl;
    } catch (e) {
      debugPrint("Error al enviar mensaje global: $e");
      return null;
    }
  }

  Future<void> actualizarEstadoEscribiendo(String userId, String nombre, bool estaEscribiendo) async {
    try {
      await _db.collection('estado_chat_global').doc(userId).set({
        'nombre': nombre,
        'estaEscribiendo': estaEscribiendo,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Error actualizando estado escribiendo: $e");
    }
  }

  Stream<QuerySnapshot> getUsuariosEscribiendo() {
    return _db
        .collection('estado_chat_global')
        .where('estaEscribiendo', isEqualTo: true)
        .snapshots();
  }

  // --- SECCIÓN CHAT PRIVADO ---
  Stream<QuerySnapshot> getChatPrivadoStream(String chatRoomId) {
    return _db
        .collection('chats_privados')
        .doc(chatRoomId)
        .collection('mensajes')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<String?> enviarMensajePrivado({
    required String chatRoomId,
    required String userId,
    required String nombre,
    required String texto,
    File? archivoMultimedia,
    Map<String, dynamic>? mensajeRespondido,
  }) async {
    try {
      String? mediaUrl;
      if (archivoMultimedia != null) {
        final ref = _storage.ref().child('chats_privados/$chatRoomId/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(archivoMultimedia);
        mediaUrl = await ref.getDownloadURL();
      }

      final Map<String, dynamic> datosMensaje = {
        'userId': userId,
        'nombre': nombre,
        'texto': texto,
        'timestamp': FieldValue.serverTimestamp(),
      };

      if (mediaUrl != null) datosMensaje['mediaUrl'] = mediaUrl;
      if (mensajeRespondido != null) datosMensaje['respondidoA'] = mensajeRespondido;

      await _db
          .collection('chats_privados')
          .doc(chatRoomId)
          .collection('mensajes')
          .add(datosMensaje);

      return mediaUrl;
    } catch (e) {
      debugPrint("Error enviando mensaje privado: $e");
      return null;
    }
  }

  // --- SECCIÓN VISTAS (HISTORIAS) ---
  Stream<QuerySnapshot> getVistasStream() {
    return _db.collection('vistas').orderBy('fecha', descending: true).snapshots();
  }

  Future<String?> publicarVista({
    required String userId,
    required String nombre,
    required String mensaje,
    File? imagen, 
    bool esVideo = false,
  }) async {
    try {
      String? imageUrl;
      if (imagen != null) {
        String ext = esVideo ? 'mp4' : 'jpg';
        final ref = _storage.ref().child('vistas/${DateTime.now().millisecondsSinceEpoch}.$ext');
        await ref.putFile(imagen);
        imageUrl = await ref.getDownloadURL();
      }

      await _db.collection('vistas').add({
        'userId': userId, 
        'nombre': nombre, 
        'mensaje': mensaje,
        'imageUrl': imageUrl, 
        'esVideo': esVideo, 
        'abrazos': 0, 
        'fecha': FieldValue.serverTimestamp(),
      });
      return imageUrl;
    } catch (e) {
      debugPrint("Error publicando vista: $e");
      return null;
    }
  }

  Future<void> darAbrazo(String postId) async {
    try {
      await _db.collection('vistas').doc(postId).update({
        'abrazos': FieldValue.increment(1),
      });
    } catch (e) {
      debugPrint("Error al dar abrazo: $e");
    }
  }

  // --- COMENTARIOS ---
  Future<void> agregarComentario({
    required String postId,
    required String postOwnerId,
    required String userId,
    required String nombre,
    required String texto,
  }) async {
    try {
      await _db.collection('vistas').doc(postId).collection('comentarios').add({
        'userId': userId, 
        'nombre': nombre, 
        'texto': texto, 
        'fecha': FieldValue.serverTimestamp(),
      });

      if (userId != postOwnerId) {
        DocumentSnapshot userDoc = await _db.collection('usuarios').doc(postOwnerId).get();
        if (userDoc.exists) {
          String? tokenFCMDueno = (userDoc.data() as Map<String, dynamic>)['fcmToken'];
          if (tokenFCMDueno != null) {
            debugPrint("Notificación para: $tokenFCMDueno");
          }
        }
      }
    } catch (e) {
      debugPrint("Error al agregar comentario: $e");
    }
  }

  Stream<QuerySnapshot> getComentariosStream(String postId) {
    return _db.collection('vistas').doc(postId).collection('comentarios').orderBy('fecha', descending: false).snapshots();
  }
}