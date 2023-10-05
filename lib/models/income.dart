import 'package:intl/intl.dart';

class Income {
  final String title;
  final int id;
  final double amount;
  final DateTime date;
  final String category;

  Income({
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
      "date": DateFormat("yyyy-MM-dd").format(date),
      "category": category,
    };
  }

  factory Income.fromMap(Map<String, dynamic> map) => new Income(
      amount: map["amount"],
      title: map["title"],
      date: DateTime.parse(map["date"]),
      category: map["category"],
      id: map["id"]);
}
