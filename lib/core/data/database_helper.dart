// ignore: depend_on_referenced_packages
import 'package:calma/core/models/usuario.dart';
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

    return await openDatabase(path, version: 3, onCreate: _createDB); // Subimos la versión a 3 por el cambio de tabla
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY, -- ✨ Ahora es TEXT para aceptar Firebase IDs
        nombres TEXT,
        email TEXT UNIQUE,
        telefono TEXT,
        password TEXT,
        profileImage TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE chats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT, -- ✨ Ahora es TEXT
        titulo TEXT,
        fechaCreacion TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        chatId INTEGER,
        texto TEXT,
        esUser INTEGER,
        fecha TEXT
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> getChats(String userId) async { // ✨ String userId
    final db = await instance.database;
    return await db.query(
      'chats',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'fechaCreacion DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getMessages(int chatId) async {
    final db = await instance.database;
    return await db.query(
      'messages',
      where: 'chatId = ?',
      whereArgs: [chatId],
      orderBy: 'fecha ASC',
    );
  }

  Future<int> insertMessage({
    required int chatId,
    required String texto,
    required bool esUser,
  }) async {
    final db = await instance.database;
    return await db.insert('messages', {
      'chatId': chatId,
      'texto': texto,
      'esUser': esUser ? 1 : 0,
      'fecha': DateTime.now().toString(),
    });
  }

  Future<int> registerUser(Usuario user) async {
    final db = await instance.database;
    // Si no tiene ID de Firebase aún, le creamos uno temporal basado en la fecha
    final userMap = user.toMap();
    userMap['id'] = user.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    return await db.insert('users', userMap);
  }

  Future<int> createChat(String userId, String titulo) async { // ✨ String userId
    final db = await instance.database;
    return await db.insert('chats', {
      'userId': userId,
      'titulo': titulo,
      'fechaCreacion': DateTime.now().toString(),
    });
  }

  Future<Usuario?> loginUser(String user, String password) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'nombres = ? AND password = ?',
      whereArgs: [user, password],
    );

    if (maps.isNotEmpty) {
      return Usuario.fromMap(maps.first); 
    }
    return null;
  }
}