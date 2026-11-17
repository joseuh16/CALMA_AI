import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:calma/core/data/firabase_service.dart';
// Asegúrate de que esta ruta sea la correcta según tu estructura de carpetas
import 'notificaciones.dart'; 

class ComentariosPage extends StatelessWidget {
  final String postId;
  final String postOwnerId; // NUEVO: ID del creador de la publicación
  final String userId;
  final String nombreUsuario;

  const ComentariosPage({
    super.key,
    required this.postId,
    required this.postOwnerId, // Añadido aquí
    required this.userId,
    required this.nombreUsuario,
  });

  @override
  Widget build(BuildContext context) {
    final FirebaseService firebase = FirebaseService();
    final TextEditingController ctrl = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF7CAFB4),
        title: const Text(
          "Comunidad de Apoyo",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Área de comentarios con Stream en tiempo real
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firebase.getComentariosStream(postId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 10),
                      Text("Aún no hay comentarios.", style: TextStyle(color: Colors.grey[500])),
                      const Text("¡Sé el primero en dar apoyo!", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    
                    // Verificación de seguridad para los campos
                    bool esMio = data['userId'] == userId;
                    String nombre = data.containsKey('nombre') ? data['nombre'] : "Usuario";
                    String texto = data.containsKey('texto') ? data['texto'] : "";

                    return _buildCommentBubble(nombre, texto, esMio);
                  },
                );
              },
            ),
          ),

          // Barra inferior para escribir con integración de notificaciones
          _buildInputArea(ctrl, firebase),
        ],
      ),
    );
  }

  // Burbuja de comentario con diseño limpio
  Widget _buildCommentBubble(String nombre, String texto, bool esMio) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: esMio ? const Color(0xFFE3F2FD) : Colors.white,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.03),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nombre,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: esMio ? Colors.blue[800] : const Color(0xFF7CAFB4),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              texto,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  // Barra de entrada de texto optimizada
  Widget _buildInputArea(TextEditingController ctrl, FirebaseService firebase) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -2),
            blurRadius: 10,
          )
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: ctrl,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: "Escribe un mensaje de apoyo...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: const Color(0xFF8DE0D1),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: () async {
                  final String mensaje = ctrl.text.trim();
                  if (mensaje.isEmpty) return;

                  // 1. Guardar en Firebase (CORREGIDO con parámetros nombrados)
                  await firebase.agregarComentario(
                    postId: postId,
                    postOwnerId: postOwnerId, // Pasamos el dueño
                    userId: userId,
                    nombre: nombreUsuario,
                    texto: mensaje,
                  );

                  // 2. Disparar notificación local (Feedback visual inmediato)
                  await NotificationService.mensajeNuevoComentario(nombreUsuario, mensaje);

                  // 3. Limpiar campo
                  ctrl.clear();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}