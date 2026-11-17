import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:calma/core/models/usuario.dart';
// ignore: depend_on_referenced_packages
import 'package:calma/core/data/firabase_service.dart'; // Importa tu servicio
import 'notificaciones/notificaciones.dart'; // Asegúrate de que esta ruta sea correcta

// Asegúrate de que las rutas de estos archivos sean las correctas en tu proyecto
import '../../chat/views/chat_page.dart';
import './barra_navegacion/configuracion_page.dart'; 
import './barra_navegacion/chat_page.dart'; // Tu ChatGlobalPage
import './barra_navegacion/vistas_page.dart';

class HomePage extends StatefulWidget {
  final Usuario user; 

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _ocultarBarra = false; 

  // --- VARIABLES GLOBALES PARA NOTIFICACIONES Y BARRA ---
  int _mensajesNoLeidosGlobal = 0;
  bool _cargaInicialChat = true;
  StreamSubscription<QuerySnapshot>? _chatGlobalSubscription;
  final FirebaseService _firebase = FirebaseService();

  @override
  void initState() {
    super.initState();
    _escucharChatGlobal(); // Iniciamos la escucha al abrir la app
  }

  void _escucharChatGlobal() {
    _chatGlobalSubscription = _firebase.getChatGlobalStream().listen((snapshot) {
      if (_cargaInicialChat) {
        _cargaInicialChat = false; 
        return; // Ignoramos mensajes viejos
      }

      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          var data = change.doc.data() as Map<String, dynamic>;
          
          // Si el mensaje NO es nuestro y NO estamos en la pestaña del Chat Global (Índice 2)
          if (data['userId'] != widget.user.id && _selectedIndex != 2) {
            if (mounted) {
              setState(() {
                _mensajesNoLeidosGlobal++;
              });
            }
            // Lanzamos la notificación en el teléfono
            NotificationService.mensajeChatComunitario(
              data['nombre'] ?? 'Alguien', 
              data['texto'] ?? ''
            );
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _chatGlobalSubscription?.cancel(); // Limpiamos al cerrar
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Si entramos al Chat Global (Índice 2), reiniciamos el contador de la barra
      if (index == 2) {
        _mensajesNoLeidosGlobal = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          ChatPage(
            user: widget.user,
            onChatStateChanged: (bool chatActivo) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && _ocultarBarra != chatActivo) {
                  setState(() {
                    _ocultarBarra = chatActivo;
                  });
                }
              });
            },
          ),
          VistasPage(user: widget.user), 
          ChatGlobalPage(user: widget.user), 
          ConfiguracionPage(user: widget.user)
        ],
      ),
      bottomNavigationBar: _ocultarBarra
          ? const SizedBox.shrink()
          : Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                selectedItemColor: const Color(0xFF64B5F6),
                unselectedItemColor: const Color(0xFFB0BEC5),
                selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
                elevation: 0,
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.smart_toy_outlined, size: 28),
                    activeIcon: Icon(Icons.smart_toy, size: 28),
                    label: 'Chat IA',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.visibility_outlined, size: 28),
                    activeIcon: Icon(Icons.visibility, size: 28),
                    label: 'Vistas',
                  ),
                  BottomNavigationBarItem(
                    // AQUI ESTÁ LA BURBUJA (BADGE) EN EL ÍCONO
                    icon: Badge(
                      isLabelVisible: _mensajesNoLeidosGlobal > 0, // Solo se ve si hay > 0
                      label: Text('$_mensajesNoLeidosGlobal'),
                      child: const Icon(Icons.chat_bubble_outline, size: 26),
                    ),
                    activeIcon: const Icon(Icons.chat_bubble, size: 26),
                    label: 'Chat',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.settings_outlined, size: 28),
                    activeIcon: Icon(Icons.settings, size: 28),
                    label: 'Configuración',
                  ),
                ],
              ),
            ),
    );
  }
}