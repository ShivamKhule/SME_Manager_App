import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  } 

  Future<Database> _initDatabase() async {

    return await openDatabase(
      join(await getDatabasesPath(), 'SME_Manager.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE sales(srno INTEGER, name TEXT PRIMARY KEY, amount INTEGER, paid INTEGER, totalAmount INTEGER, date TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertItem({int? srno, String? name, int? amount, int? paid, int? totalAmount, String? date}) async {
    final db = await database;
    await db.insert(
      'sales',
      {'srno': srno, 'name': name, 'amount' : amount, 'paid' : paid, 'totalAmount' : totalAmount, 'date' : date},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> fetchItems() async {
    final db = await database;
    return await db.query('sales');
  }

  Future<void> deleteItem(String name) async {
    final db = await database;
    await db.delete('sales', where: 'name = ?', whereArgs: [name]);
  }

}
