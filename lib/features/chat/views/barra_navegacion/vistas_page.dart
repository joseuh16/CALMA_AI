import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:calma/core/models/usuario.dart';
// ignore: depend_on_referenced_packages
import 'package:calma/core/data/firabase_service.dart';
import '../notificaciones/comentarios_page.dart';
import 'package:video_player/video_player.dart';

class VistasPage extends StatelessWidget {
  final Usuario user;
  final FirebaseService _firebase = FirebaseService();

  VistasPage({super.key, required this.user});

  void _abrirModalPublicar(BuildContext context) {
    final textCtrl = TextEditingController();
    File? archivoSeleccionado;
    bool esVideo = false;
    bool subiendo = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(builder: (context, setModalState) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20, right: 20, top: 20
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 15),
              const Text("¿Qué quieres compartir?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF7CAFB4))),
              const SizedBox(height: 10),
              TextField(
                controller: textCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Escribe un mensaje de apoyo...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 15),
              if (archivoSeleccionado != null)
                Text(esVideo ? "🎥 Video seleccionado" : "📸 Foto seleccionada", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.image, color: Colors.blue),
                    onPressed: () async {
                      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if (picked != null) setModalState(() { archivoSeleccionado = File(picked.path); esVideo = false; });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.videocam, color: Colors.red),
                    onPressed: () async {
                      final picked = await ImagePicker().pickVideo(source: ImageSource.gallery);
                      if (picked != null) setModalState(() { archivoSeleccionado = File(picked.path); esVideo = true; });
                    },
                  ),
                  const Spacer(),
                  subiendo 
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8DE0D1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      onPressed: () async {
                        if (textCtrl.text.isEmpty && archivoSeleccionado == null) return;
                        setModalState(() => subiendo = true);
                        await _firebase.publicarVista(
                          userId: user.id!,
                          nombre: user.nombres,
                          mensaje: textCtrl.text,
                          imagen: archivoSeleccionado,
                          esVideo: esVideo
                        );
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: const Text("Publicar", style: TextStyle(color: Colors.white)),
                    )
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFA),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirModalPublicar(context),
        label: const Text("Compartir"),
        icon: const Icon(Icons.add_a_photo),
        backgroundColor: const Color(0xFF7CAFB4),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firebase.getVistasStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Text("No hay publicaciones aún."));
          
          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => _buildPostCard(context, snapshot.data!.docs[index]),
          );
        },
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, DocumentSnapshot post) {
    final data = post.data() as Map<String, dynamic>;
    
    final bool esVideo = data.containsKey('esVideo') ? data['esVideo'] : false;
    final String? url = data.containsKey('imageUrl') ? data['imageUrl'] : null;
    final String nombre = data.containsKey('nombre') ? data['nombre'] : "Usuario";
    final String mensaje = data.containsKey('mensaje') ? data['mensaje'] : "";
    final int abrazos = data.containsKey('abrazos') ? data['abrazos'] : 0;
    
    // NUEVO: Extraemos el ID del creador de la publicación para mandarlo a los comentarios
    final String postOwnerId = data.containsKey('userId') ? data['userId'] : "";

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05), 
            blurRadius: 15
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFD1E8E4), 
              child: Text(nombre.isNotEmpty ? nombre[0].toUpperCase() : "?", style: const TextStyle(color: Color(0xFF7CAFB4)))
            ),
            title: Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text("Ahora mismo"),
          ),
          if (mensaje.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5), 
              child: Text(mensaje, style: const TextStyle(fontSize: 15))
            ),
          
          if (url != null)
            Padding(
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: esVideo ? _VideoWidget(url: url) : Image.network(url, fit: BoxFit.cover),
              ),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.pink), 
                  onPressed: () => _firebase.darAbrazo(post.id)
                ),
                Text("$abrazos apoyos"),
                const SizedBox(width: 15),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ComentariosPage(
                    postId: post.id,
                    postOwnerId: postOwnerId, // <-- PASAMOS EL DATO AQUÍ
                    userId: user.id!,
                    nombreUsuario: user.nombres,
                  ))),
                ),
                const Text("Comentar"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoWidget extends StatefulWidget {
  final String url;
  const _VideoWidget({required this.url});

  @override
  State<_VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<_VideoWidget> {
  late VideoPlayerController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        if (mounted) setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(_controller),
                GestureDetector(
                  onTap: () => setState(() => _controller.value.isPlaying ? _controller.pause() : _controller.play()),
                  child: Container(
                    color: Colors.transparent,
                    child: Center(
                      child: Icon(
                        _controller.value.isPlaying ? Icons.pause : Icons.play_arrow, 
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.7), 
                        size: 50
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}