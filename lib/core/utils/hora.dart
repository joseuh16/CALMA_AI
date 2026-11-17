// En Arquitectura de Software, las utilidades no deben instanciarse.
// Usamos un constructor privado privado: TimeUtils._()
class TimeUtils {
  TimeUtils._(); // Evita que alguien haga `var t = TimeUtils();` por error

  /// Obtiene la hora actual en formato HH:mm SIN intl
  static String obtenerHoraActual() {
    final now = DateTime.now();
    final hora = now.hour.toString().padLeft(2, '0');
    final minuto = now.minute.toString().padLeft(2, '0');
    return '$hora:$minuto';
  }

  /// Saludo según la hora del día
  static String obtenerSaludoSegunHora() {
    final hora = DateTime.now().hour;
    if (hora >= 5 && hora < 12) return 'Buenos días bella persona';
    if (hora >= 12 && hora < 19) return 'Buenas tardes bella persona';
    return 'Buenas noches bella persona';
  }
  
  /// Extrae HH:mm de un String de fecha completo
  static String obtenerHoraDesdeFecha(String fechaString) {
    try {
      final fecha = DateTime.parse(fechaString);
      final hora = fecha.hour.toString().padLeft(2, '0');
      final minuto = fecha.minute.toString().padLeft(2, '0');
      return "$hora:$minuto";
    } catch (e) {
      // Siempre es bueno manejar el error si el String no es un DateTime válido
      return "00:00"; 
    }
  }
}