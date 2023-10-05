import 'package:intl/intl.dart';

class Expense {
  final String title;
  final int id;
  final double amount;
  final DateTime date;
  final String category;

  Expense({
    required this.amount,
    required this.title,
    required this.date,
    required this.id,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "amount": amount,
      "date": DateFormat("yyyy-MM-dd hh:mm").format(date),
      "category": category,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) => new Expense(
      amount: map["amount"],
      title: map["title"],
      date: DateTime.parse(map["date"]),
      category: map["category"],
      id: map["id"]);
}
