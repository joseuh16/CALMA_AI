import 'dart:convert';
import 'package:http/http.dart' as http;

class N8NService {
  static const String url =
      "https://teksar.app.n8n.cloud/webhook/ai-agent";

  static Future<String> enviarMensaje(String texto) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "message": texto,
        }),
      );

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);

          if (data is Map && data.containsKey("response")) {
            return data["response"].toString();
          }

          if (data is Map && data.containsKey("message")) {
            return data["message"].toString();
          }

          if (data is Map && data.containsKey("output")) {
            return data["output"].toString();
          }

          return data.toString();
        } catch (_) {
          return response.body;
        }
      } else {
        return "Error ${response.statusCode}: No se pudo conectar.";
      }
    } catch (e) {
      return "Error de conexión: $e";
    }
  }
}