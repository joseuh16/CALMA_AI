import 'package:iasuice/login_IA/models/usuario.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('users.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombres TEXT,
        email TEXT UNIQUE,
        telefono TEXT,
        password TEXT,
        profileImage TEXT
      )
    ''');
  }

  // MÉTODO PARA REGISTRAR
  Future<int> registerUser(User user) async {
    final db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  // MÉTODO PARA LOGIN
  Future<User?> loginUser(String user, String password) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'nombres = ? AND password = ?',
      whereArgs: [user, password],
    );

    if (maps.isNotEmpty) {
      // Aquí podrías convertir el mapa de vuelta a un objeto User
      return User.fromMap(maps.first); 
    }
    return null;
  }
}