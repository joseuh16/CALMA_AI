import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../features/auth/auth_service.dart';
import 'mensaje_cerrar.dart';

class CerrarSesionBtn extends StatelessWidget {
  const CerrarSesionBtn({super.key});

  @override
  Widget build(BuildContext context) {

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {

          HapticFeedback.mediumImpact();

          DialogHelper.mostrarMensajeCerrar(
            context,
            () => AuthService.cerrarSesion(context),
          );

        },
        customBorder: const CircleBorder(),
        child: Ink(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            color: Color(0xFF5B61B9),
            size: 28,
          ),
        ),
      ),
    );
  }
}