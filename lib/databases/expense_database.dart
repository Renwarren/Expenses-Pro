import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '/models/expense.dart';

class ExpensesDatabase {
  static final ExpensesDatabase instance = ExpensesDatabase._();
  static Database? _database;
  ExpensesDatabase._();

  Future<Database> get database async {
    if (_database != null) return Future.value(_database);
    _database = await _init("expenses.db");
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
    await db.execute("""CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL,
        date TEXT NOT NULL,
        category TEXT NOT NULL
      )""");
  }

  Future<Expense> insertExpense(Expense e) async {
    final Database db = await database;
    await db.insert(
      "expenses",
      e.toMap(),
    );
    print('Expense Inserted');
    return e;
  }

  void updateExpense(Expense e) async {
    final Database db = await database;
    await db.update("expenses", e.toMap(), where: "id = ?", whereArgs: [e.id]);
  }

  void deleteExpense(Expense e) async {
    final Database db = await database;
    db.delete("expenses", where: "id = ?", whereArgs: [e.id]);
  }

  Future<List<Expense>> showExpenses() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query("expenses");
    List<Expense> expenseList = List.generate(maps.length, (index) {
      return Expense.fromMap(maps[index]);
    });
    return expenseList;
  }

  Future getSumExpenses() async {
    final Database db = await database;
    var result = await db.rawQuery("SELECT SUM(amount) FROM expenses");
    var sum = result[0]["SUM(amount)"];
    print(sum);
    return sum as double;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<List<Expense>> showRecentExpenses() async {
    final Database db = await database;
    var maps = await db
        .rawQuery("SELECT amount FROM expenses ORDER BY id DESC LIMIT 3 ");
    List<Expense> expenseList = List.generate(maps.length, (index) {
      return Expense.fromMap(maps[index]);
    });
    expenseList.forEach((element) {
      print(element.date);
    });
    return expenseList;
  }
}
