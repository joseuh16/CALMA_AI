class Usuario {
  final String? id; 
  final String nombres;
  final String email;
  final String telefono;
  final String password;
  final String? profileImage;

  const Usuario({
    this.id,
    required this.nombres,
    required this.email,
    required this.telefono,
    required this.password,
    this.profileImage,
  });

  Usuario copyWith({
    String? id,
    String? nombres,
    String? email,
    String? telefono,
    String? password,
    String? profileImage,
  }) {
    return Usuario(
      id: id ?? this.id,
      nombres: nombres ?? this.nombres,
      email: email ?? this.email,
      telefono: telefono ?? this.telefono,
      password: password ?? this.password,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'nombres': nombres,
    'email': email,
    'telefono': telefono,
    'password': password,
    'profileImage': profileImage,
  };

  factory Usuario.fromMap(Map<String, dynamic> map) => Usuario(
    id: map['id']?.toString(), 
    nombres: map['nombres'],
    email: map['email'],
    telefono: map['telefono'],
    password: map['password'],
    profileImage: map['profileImage'],
  );
}