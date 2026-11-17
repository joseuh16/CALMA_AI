class Chat {
  final int? id;
  final String userId; // ✨ ¡Corregido a String!
  final String titulo;
  final String fechaCreacion;

  const Chat({
    this.id,
    required this.userId, // ✨
    required this.titulo,
    required this.fechaCreacion,
  });

  // Método copyWith: Pura magia SOLID para clonar/actualizar objetos sin mutar el original
  Chat copyWith({
    int? id,
    String? userId, // ✨
    String? titulo,
    String? fechaCreacion,
  }) {
    return Chat(
      id: id ?? this.id,
      userId: userId ?? this.userId, // ✨
      titulo: titulo ?? this.titulo,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'titulo': titulo,
    'fechaCreacion': fechaCreacion,
  };

  factory Chat.fromMap(Map<String, dynamic> map) => Chat(
    id: map['id'],
    userId: map['userId'].toString(), // ✨ Lo forzamos a texto por seguridad
    titulo: map['titulo'],
    fechaCreacion: map['fechaCreacion'],
  );
}