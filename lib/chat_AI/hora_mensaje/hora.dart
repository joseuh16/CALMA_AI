class HoraMensaje {
  // Obtiene la hora actual en formato HH:mm SIN intl
  static String obtenerHoraActual() {
    final now = DateTime.now();
    final hora = now.hour.toString().padLeft(2, '0');
    final minuto = now.minute.toString().padLeft(2, '0');
    return '$hora:$minuto';
  }

  // Saludo según la hora del día
  static String obtenerSaludoSegunHora() {
    final hora = DateTime.now().hour;
    if (hora >= 5 && hora < 12) return 'Buenos días';
    if (hora >= 12 && hora < 19) return 'Buenas tardes';
    return 'Buenas noches';
  }
}