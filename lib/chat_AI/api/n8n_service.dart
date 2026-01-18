import 'dart:convert';
import 'package:http/http.dart' as http;

class N8NService {
  static const String url = "https://teksar.app.n8n.cloud/webhook/ai-agent";

  static Future<String> enviarMensaje(String texto) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": texto}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data["response"]?? "Sin respuesta"; // ajusta según la respuesta de N8N
      } else {
        return "Error al conectar con N8N";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
