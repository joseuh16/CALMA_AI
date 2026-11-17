import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String userId;
  final String nombre;
  final String mensaje;
  final String? mediaUrl; // URL de la imagen o video en Firebase Storage
  final String tipoMedia; // 'texto', 'imagen', 'video'
  final int abrazos;
  final DateTime fecha;

  PostModel({
    required this.id, required this.userId, required this.nombre,
    required this.mensaje, this.mediaUrl, required this.tipoMedia,
    required this.abrazos, required this.fecha,
  });

  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return PostModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      nombre: data['nombre'] ?? 'Anónimo',
      mensaje: data['mensaje'] ?? '',
      mediaUrl: data['mediaUrl'],
      tipoMedia: data['tipoMedia'] ?? 'texto',
      abrazos: data['abrazos'] ?? 0,
      fecha: (data['fecha'] as Timestamp).toDate(),
    );
  }
}