class User {
  final int? id;
  final String nombres;
  //final String apellidoPaterno;
  //final String apellidoMaterno;
  final String email;
  final String telefono;
  final String password;
  final String? profileImage;

  User({
    this.id,
    required this.nombres,
    //required this.apellidoPaterno,
    //required this.apellidoMaterno,
    required this.email,
    required this.telefono,
    required this.password,
    required this.profileImage,
  });
  //Convertirlo a un Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombres': nombres,
      //'apellidoPaterno': apellidoPaterno,
      //'apellidoMaterno': apellidoMaterno,
      'email': email,
      'telefono': telefono,
      'password': password,
      'profileImage': profileImage,
    };
  }

  //Convertir de mapa a objeto
  factory User.fromMap(Map<String, dynamic> map){
    return User(
      id:map['id'],
      nombres: map['nombres'],
      //apellidoPaterno: map['apellidoPaterno'],
      //apellidoMaterno: map['apelidoMaterno'],
      email: map['email'],
      telefono: map['telefono'],
      password: map['password'],
      profileImage: map['profileImage'],
    );
  }
}
