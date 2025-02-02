import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'model/ProfileModel.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'SMEManager.db'),
      onCreate: (db, version) {
        return db.execute('''CREATE TABLE profile(
          company_name TEXT,
          owner_name TEXT,
          gstin TEXT,
          mobile TEXT,
          business_domain TEXT,
          address_line1 TEXT,
          address_line2 TEXT,
          landmark TEXT,
          city TEXT,
          district TEXT,
          state TEXT,
          pincode TEXT,
          profile_image TEXT,
        )''');
      },
      version: 1,
    );
  }

  Future<void> insertData(ProfileModel obj) async {
    Database localDB = await initDatabase();

    await localDB.insert(
      'profile',
      obj.profileModelMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getData() async {
    Database localDB = await initDatabase();

    List<Map<String, dynamic>> dataList = await localDB.query('profile');
    return dataList;
  }

  Future<List<Map<String, dynamic>>> fetchAndStoreData() async {
    List<Map<String, dynamic>> data = await getData();
    return data;
  }

  Future<void> updateData(ProfileModel obj) async {
    Database localDB = await initDatabase();
    await localDB.update(
      'profile',
      obj.profileModelMap(),
      where: 'company_name = ?',
      whereArgs: [obj.companyName],
    );
  }
}
