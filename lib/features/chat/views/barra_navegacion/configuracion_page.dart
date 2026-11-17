import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Ajusta tus importaciones reales aquí
import '../../../../features/auth/auth_service.dart';
import '../../../../settings/views/cerrar_cesion/mensaje_cerrar.dart';
// ignore: depend_on_referenced_packages
import 'package:calma/core/models/usuario.dart';

class ConfiguracionPage extends StatefulWidget {
  final Usuario user;
  const ConfiguracionPage({super.key, required this.user});

  @override
  State<ConfiguracionPage> createState() => _ConfiguracionPageState();
}

class _ConfiguracionPageState extends State<ConfiguracionPage> {
  bool _notificacionesActivas = true;
  bool _modoSilencioso = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Configuración',
          style: TextStyle(color: Color(0xFF2C3E50), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // --- TARJETA DE PERFIL ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9BBDF9), Color(0xFF8DE0D1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: const Color(0xFF9BBDF9).withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Text(
                      widget.user.nombres.isNotEmpty ? widget.user.nombres[0].toUpperCase() : 'U',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF5B61B9)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.nombres,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const Text(
                          'Miembro de la comunidad',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // --- SECCIÓN: PREFERENCIAS ---
            const Padding(
              padding: EdgeInsets.only(left: 10, bottom: 10),
              child: Text("Preferencias", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
            ),
            _buildSwitchOpcion(Icons.notifications_active_outlined, "Notificaciones de apoyo", _notificacionesActivas, (val) {
              setState(() => _notificacionesActivas = val);
            }),
            _buildSwitchOpcion(Icons.do_not_disturb_alt_outlined, "Modo silencioso", _modoSilencioso, (val) {
              setState(() => _modoSilencioso = val);
            }),

            const SizedBox(height: 20),

            // --- SECCIÓN: CUENTA Y SEGURIDAD ---
            const Padding(
              padding: EdgeInsets.only(left: 10, bottom: 10),
              child: Text("Cuenta y Seguridad", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
            ),
            _buildBotonOpcion(Icons.person_outline, "Editar Perfil", () {}),
            _buildBotonOpcion(Icons.lock_outline, "Privacidad", () {}),
            _buildBotonOpcion(Icons.help_outline, "Centro de Ayuda", () {}),

            const SizedBox(height: 30),

            // --- BOTÓN DE CERRAR SESIÓN ---
            Material(
              color: const Color(0xFFFFF0F0),
              borderRadius: BorderRadius.circular(15),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  HapticFeedback.mediumImpact();
                  DialogHelper.mostrarMensajeCerrar(
                    context,
                    () => AuthService.cerrarSesion(context),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_rounded, color: Colors.redAccent),
                      SizedBox(width: 10),
                      Text("Cerrar Sesión", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget para opciones con Switch (interruptor)
  Widget _buildSwitchOpcion(IconData icon, String title, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: SwitchListTile(
        secondary: Icon(icon, color: const Color(0xFF5B61B9)),
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        value: value,
        // ignore: deprecated_member_use
        activeColor: const Color(0xFF8DE0D1),
        onChanged: onChanged,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  // Widget para opciones navegables (botones normales)
  Widget _buildBotonOpcion(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF5B61B9)),
                const SizedBox(width: 15),
                Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}