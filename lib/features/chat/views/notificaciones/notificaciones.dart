import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid = 
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        debugPrint("Notificación tocada: ${details.payload}");
      },
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // Descarga imágenes para mostrar en la notificación
  static Future<String?> _downloadAndSaveFile(String? url, String fileName) async {
    if (url == null || url.isEmpty) return null;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/$fileName';
      final http.Response response = await http.get(Uri.parse(url));
      final File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    } catch (e) {
      debugPrint("Error descargando imagen para notif: $e");
      return null;
    }
  }

  // 1. Notificación estilo WhatsApp para el Chat
  static Future<void> mensajeChatComunitario(String autor, String mensaje) async {
    final Person sender = Person(name: autor, key: autor, important: true);

    final MessagingStyleInformation messagingStyle = MessagingStyleInformation(
      Person(name: 'Tú', key: '0'),
      conversationTitle: 'Chat Comunitario 👥',
      groupConversation: true,
      messages: [
        Message(mensaje.isEmpty ? '📷 Imagen' : mensaje, DateTime.now(), sender),
      ],
    );

    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'chat_channel_v1',
      'Chat Comunitario',
      importance: Importance.max,
      priority: Priority.max,
      styleInformation: messagingStyle,
      color: const Color(0xFF7CAFB4),
    );

    await _notificationsPlugin.show(
      Random().nextInt(10000),
      'Nuevo mensaje',
      '',
      NotificationDetails(android: androidDetails),
      payload: 'chat_global',
    );
  }

  // 2. Notificación con imagen para Nuevas Publicaciones (Vistas)
  static Future<void> mensajeNuevaPublicacion(String autor, String mensaje, String? imageUrl) async {
    BigPictureStyleInformation? bigPictureStyle;
    
    if (imageUrl != null) {
      final String? filePath = await _downloadAndSaveFile(imageUrl, 'temp_post_img.jpg');
      if (filePath != null) {
        bigPictureStyle = BigPictureStyleInformation(
          FilePathAndroidBitmap(filePath),
          contentTitle: '¡$autor compartió algo! ✨',
          summaryText: mensaje,
        );
      }
    }

    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'vistas_channel_v1',
      'Publicaciones',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: bigPictureStyle,
      color: const Color(0xFF8DE0D1),
    );

    await _notificationsPlugin.show(
      Random().nextInt(10000),
      'Nueva publicación',
      mensaje,
      NotificationDetails(android: androidDetails),
      payload: 'vistas_page',
    );
  }

  // 3. Notificación para Comentarios
  static Future<void> mensajeNuevoComentario(String autor, String texto) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'comment_channel_v1',
      'Comentarios',
      importance: Importance.high,
      priority: Priority.high,
      color: Colors.blue,
    );

    await _notificationsPlugin.show(
      Random().nextInt(10000),
      '$autor comentó 💬',
      texto,
      const NotificationDetails(android: androidDetails),
      payload: 'comentarios_page',
    );
  }
}