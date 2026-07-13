import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../models/user.dart';
import 'user_repository.dart';

class SqliteUserRepository implements UserRepository {
  static const String _tableName = 'users';
  static const String _databaseName = 'user_manager.db';

  Database? _database;

  Future<Database> get _db async {
    if (_database != null) {
      return _database!;
    }

    sqfliteFfiInit();
    final databasesPath = await databaseFactoryFfi.getDatabasesPath();
    final databasePath = path.join(databasesPath, _databaseName);

    _database = await databaseFactoryFfi.openDatabase(
      databasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _onCreate,
      ),
    );

    return _database!;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY,
        fullName TEXT NOT NULL,
        email TEXT NOT NULL,
        avatar TEXT NOT NULL
      )
    ''');

    for (final user in _seedUsers) {
      await db.insert(_tableName, _toMap(user));
    }
  }

  static final List<UserModel> _seedUsers = <UserModel>[
    const UserModel(
      id: 1,
      fullName: 'Nguyễn Văn An',
      email: 'an.nguyen@gmail.com',
      avatar: 'assets/im1.jpg',
    ),
    const UserModel(
      id: 2,
      fullName: 'Trần Thị Bình',
      email: 'bình.tran@gmailcom',
      avatar: 'assets/im2.jpg',
    ),
    const UserModel(
      id: 3,
      fullName: 'Lê Minh Cường',
      email: 'cuong.le@gmail.com',
      avatar: 'assets/im3.jpg',
    ),
  ];

  Map<String, Object?> _toMap(UserModel user) {
    return <String, Object?>{
      'id': user.id,
      'fullName': user.fullName,
      'email': user.email,
      'avatar': user.avatar,
    };
  }

  UserModel _fromMap(Map<String, Object?> row) {
    return UserModel(
      id: row['id'] as int,
      fullName: row['fullName'] as String,
      email: row['email'] as String,
      avatar: row['avatar'] as String,
    );
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final db = await _db;
    final rows = await db.query(
      _tableName,
      orderBy: 'id ASC',
    );

    return rows.map(_fromMap).toList();
  }

  @override
  Future<void> addUser(UserModel user) async {
    final db = await _db;
    await db.insert(_tableName, _toMap(user));
  }

  @override
  Future<void> updateUser(UserModel user) async {
    final db = await _db;
    await db.update(
      _tableName,
      _toMap(user),
      where: 'id = ?',
      whereArgs: <Object?>[user.id],
    );
  }

  @override
  Future<void> deleteUser(int id) async {
    final db = await _db;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: <Object?>[id],
    );
  }
}

UserRepository createUserRepository() => SqliteUserRepository();
