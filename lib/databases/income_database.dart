import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '/models/income.dart';

class IncomesDatabase {
  static final IncomesDatabase instance = IncomesDatabase._();
  static Database? _database;
  IncomesDatabase._();

  Future<Database> get database async {
    if (_database != null) return Future.value(_database);
    _database = await _init("incomes.db");
    return _database!;
  }

  Future<Database> _init(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute("""CREATE TABLE incomes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL,
        date TEXT NOT NULL,
        category TEXT NOT NULL
      )""");
  }

  Future<Income> insertIncome(Income e) async {
    final Database db = await database;
    await db.insert(
      "incomes",
      e.toMap(),
    );
    print('Income Inserted');
    return e;
  }

  void updateIncome(Income e) async {
    final Database db = await database;
    await db.update("incomes", e.toMap(), where: "id = ?", whereArgs: [e.id]);
  }

  void deleteIncome(Income e) async {
    final Database db = await database;
    db.delete("incomes", where: "id = ?", whereArgs: [e.id]);
  }

  Future<List<Income>> showIncomes() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query("incomes");
    List<Income> incomeList = List.generate(maps.length, (index) {
      return Income.fromMap(maps[index]);
    });
    return incomeList;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
