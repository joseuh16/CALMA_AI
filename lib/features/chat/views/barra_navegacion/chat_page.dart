import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swipe_to/swipe_to.dart';
// ignore: depend_on_referenced_packages
import 'package:calma/core/models/usuario.dart';
// ignore: depend_on_referenced_packages
import 'package:calma/core/data/firabase_service.dart';

class ChatGlobalPage extends StatefulWidget {
  final Usuario user;
  const ChatGlobalPage({super.key, required this.user});

  @override
  State<ChatGlobalPage> createState() => _ChatGlobalPageState();
}

class _ChatGlobalPageState extends State<ChatGlobalPage> {
  final _msgCtrl = TextEditingController();
  final FirebaseService _firebase = FirebaseService();
  final ScrollController _scrollController = ScrollController(); 
  
  Map<String, dynamic>? _mensajeAResponder;
  File? _archivoSeleccionado;
  bool _enviando = false;
  bool _yoEstoyEscribiendo = false;

  @override
  void initState() {
    super.initState();
    _msgCtrl.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (_msgCtrl.text.trim().isNotEmpty && !_yoEstoyEscribiendo) {
      _yoEstoyEscribiendo = true;
      _firebase.actualizarEstadoEscribiendo(widget.user.id!, widget.user.nombres, true);
    } else if (_msgCtrl.text.trim().isEmpty && _yoEstoyEscribiendo) {
      _yoEstoyEscribiendo = false;
      _firebase.actualizarEstadoEscribiendo(widget.user.id!, widget.user.nombres, false);
    }
  }

  @override
  void dispose() {
    _firebase.actualizarEstadoEscribiendo(widget.user.id!, widget.user.nombres, false);
    _msgCtrl.removeListener(_onTextChanged);
    _msgCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    
    if (pickedFile != null) {
      setState(() {
        _archivoSeleccionado = File(pickedFile.path);
      });
    }
  }

  Future<void> _enviar() async {
    final texto = _msgCtrl.text.trim();
    if (texto.isEmpty && _archivoSeleccionado == null) return;
    
    setState(() {
      _enviando = true;
    });

    try {
      await _firebase.enviarMensajeGlobal(
        userId: widget.user.id!,
        nombre: widget.user.nombres,
        texto: texto,
        archivoMultimedia: _archivoSeleccionado,
        mensajeRespondido: _mensajeAResponder,
      );

      _msgCtrl.clear();
      setState(() {
        _mensajeAResponder = null;
        _archivoSeleccionado = null;
        _enviando = false;
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
        }
      });
    } catch (e) {
      setState(() => _enviando = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al enviar: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Chat Comunitario",
          style: TextStyle(color: Color(0xFF7CAFB4), fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF7CAFB4)),
          onPressed: () async {
            FocusManager.instance.primaryFocus?.unfocus(); 
            await Future.delayed(const Duration(milliseconds: 150)); 
            if (context.mounted) {
              Navigator.maybePop(context); 
            }
          },
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firebase.getChatGlobalStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("Sé el primero en saludar 👋", style: TextStyle(color: Colors.grey)),
                    );
                  }
                  
                  final docs = snapshot.data!.docs;
                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    physics: const BouncingScrollPhysics(),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      var msg = docs[index];
                      Map<String, dynamic> data = msg.data() as Map<String, dynamic>;
                      bool soyYo = data['userId'] == widget.user.id;
                      
                      return SwipeTo(
                        onRightSwipe: (details) {
                          setState(() {
                            _mensajeAResponder = {
                              'nombre': data['nombre'],
                              'texto': data['texto'],
                            };
                          });
                        },
                        child: _buildBurbuja(data, soyYo),
                      );
                    },
                  );
                },
              ),
            ),
            _indicadorEscribiendo(),
            _inputArea(),
          ],
        ),
      ),
    );
  }

  Widget _indicadorEscribiendo() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firebase.getUsuariosEscribiendo(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const SizedBox.shrink();

        var escribiendo = snapshot.data!.docs
            .where((doc) => doc.id != widget.user.id && doc['estaEscribiendo'] == true)
            .map((doc) => doc['nombre'])
            .toList();

        if (escribiendo.isEmpty) return const SizedBox.shrink();

        String texto = escribiendo.length == 1 
            ? "${escribiendo[0]} está escribiendo..." 
            : "Varios están escribiendo...";

        return Padding(
          padding: const EdgeInsets.only(left: 15, bottom: 5),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              texto,
              style: const TextStyle(color: Color(0xFF7CAFB4), fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ),
        );
      },
    );
  }

  Widget _inputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          // ignore: deprecated_member_use
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_mensajeAResponder != null)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                  border: const Border(left: BorderSide(color: Color(0xFF7CAFB4), width: 4)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Respondiendo a ${_mensajeAResponder!['nombre']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF7CAFB4))),
                          Text(_mensajeAResponder!['texto'] ?? 'Imagen', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black54, fontSize: 13)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () => setState(() => _mensajeAResponder = null),
                    )
                  ],
                ),
              ),

            if (_archivoSeleccionado != null)
              Stack(
                children: [
                  Container(
                    height: 100, width: 100, margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), image: DecorationImage(image: FileImage(_archivoSeleccionado!), fit: BoxFit.cover)),
                  ),
                  Positioned(
                    right: -5, top: -5,
                    child: IconButton(icon: const Icon(Icons.cancel, color: Colors.redAccent), onPressed: () => setState(() => _archivoSeleccionado = null)),
                  )
                ],
              ),

            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Colors.grey),
                  onPressed: _seleccionarImagen,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(color: const Color(0xFFF0F2F5), borderRadius: BorderRadius.circular(25)),
                    child: TextField(
                      controller: _msgCtrl,
                      decoration: const InputDecoration(hintText: "Escribe un mensaje...", border: InputBorder.none),
                      onSubmitted: (_) => _enviar(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                _enviando 
                ? const Padding(padding: EdgeInsets.all(12.0), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)))
                : GestureDetector(
                    onTap: _enviar,
                    child: const CircleAvatar(backgroundColor: Color(0xFF7CAFB4), child: Icon(Icons.send_rounded, color: Colors.white, size: 20)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBurbuja(Map<String, dynamic> data, bool soyYo) {
    String autor = data['nombre'] ?? 'Desconocido';
    String texto = data['texto'] ?? '';
    String? mediaUrl = data.containsKey('mediaUrl') ? data['mediaUrl'] : null;
    Map<String, dynamic>? respondidoA = data.containsKey('respondidoA') ? data['respondidoA'] : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: soyYo ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!soyYo)
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 4),
              child: Text(autor, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            ),
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            padding: const EdgeInsets.all(6), 
            decoration: BoxDecoration(
              color: soyYo ? const Color(0xFF7CAFB4) : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(soyYo ? 20 : 0),
                bottomRight: Radius.circular(soyYo ? 0 : 20),
              ),
              boxShadow: [
                // ignore: deprecated_member_use
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5, offset: const Offset(0, 2))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (respondidoA != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: soyYo ? Colors.white.withOpacity(0.2) : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                      border: Border(left: BorderSide(color: soyYo ? Colors.white : const Color(0xFF7CAFB4), width: 4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(respondidoA['nombre'] ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: soyYo ? Colors.white : const Color(0xFF7CAFB4))),
                        Text(respondidoA['texto'] ?? 'Multimedia', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: soyYo ? Colors.white70 : Colors.black54)),
                      ],
                    ),
                  ),

                if (mediaUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(mediaUrl, fit: BoxFit.cover),
                  ),
                
                if (texto.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      texto,
                      style: TextStyle(color: soyYo ? Colors.white : Colors.black87, fontSize: 15),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}