import 'package:flutter/material.dart';

const List expenseCategory = [
  {"name": "Education", "image": "assets/images/education.png"},
  {"name": "Entertainment", "image": "assets/images/entertainment.png"},
  {"name": "Charity", "image": "assets/images/charity.png"},
  {"name": "Groceries", "image": "assets/images/groceries.png"},
  {"name": "Housing", "image": "assets/images/housing.png"},
  {"name": "Loan", "image": "assets/images/loan.png"},
  {"name": "Utility", "image": "assets/images/utility.png"},
  {"name": "Gifts", "image": "assets/images/money_gifts.png"},
];

const List incomeCategory = [
  {"name": "Salary", "image": "assets/images/salary.jpg"},
  {"name": "Investment", "image": "assets/images/Investment.jpg"},
  {"name": "Pocket Money", "image": "assets/images/pocket_money.png"},
  {"name": "Interest", "image": "assets/images/interest.png"},
  {"name": "Loan", "image": "assets/images/loan.png"},
];

Color getCategoryColor(String category) {
  switch (category) {
    case "Entertainment":
      return Colors.red;
    case "Gifts":
      return Colors.orange;
    case "Education":
      return Colors.yellow;
    case "Charity":
      return Colors.green;
    case "Groceries":
      return Colors.blue;
    case "Housing":
      return Colors.indigo;
    case "Loan":
      return Colors.purple;
    case "Utility":
      return Colors.grey;
    case "Salary":
      return Colors.cyan;
    case "Investment":
      return Colors.brown;
    case "Pocket Money":
      return Colors.blueGrey;
    case "Interest":
      return Colors.pink;
  }
  return Colors.yellow;
}
