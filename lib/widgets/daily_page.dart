import 'package:expenses_pro/databases/expense_database.dart';
import 'package:expenses_pro/databases/income_database.dart';
import 'package:expenses_pro/helpers/category.dart';
import 'package:expenses_pro/helpers/user_preferences.dart';
import 'package:expenses_pro/models/expense.dart';
import 'package:expenses_pro/models/income.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'nav_bar.dart';

class DailyPage extends StatefulWidget {
  @override
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Page'),
      ),
      drawer: NavBar(),
      backgroundColor: Colors.white,
      body: getBody(),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  String chosenCurrency = UserSimplePreferences.getCurrency() as String;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  Widget getBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          TableCalendar(
            focusedDay: focusedDay,
            firstDay: DateTime(1990),
            lastDay: DateTime(2050),
            calendarFormat: CalendarFormat.week,
            onDaySelected: (newDay, g) {
              setState(() {
                selectedDay = newDay;
                focusedDay = g;
              });
            },
            selectedDayPredicate: (date) {
              return isSameDay(selectedDay, date);
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
          Container(
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                width: 2.0,
                color: Colors.red.shade900,
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black38,
                    offset: Offset(0, 2),
                    blurRadius: 6.0),
              ],
            ),
            child: ListTile(
              title: Text("CURRENT BALANCE:"),
              trailing: Text("500 ${chosenCurrency}"),
            ),
          ),
          FutureBuilder<List<Expense>>(
              future: ExpensesDatabase.instance.showExpenses(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Expense>> snapshot) {
                if (snapshot.hasData) {
                  List<Expense> expenseList = snapshot.data!;
                  return SizedBox(
                    height: 150.0, // put mediaquery here
                    child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          final i = expenseList[index];
                          return Container(
                            margin: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                width: 2.0,
                                color: getCategoryColor(i.category),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black38,
                                    offset: Offset(0, 2),
                                    blurRadius: 6.0),
                              ],
                            ),
                            child: ListTile(
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    i.category,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("${i.amount} " + chosenCurrency),
                                  Text(
                                    DateFormat("yyyy-MM-dd").format(i.date),
                                  ),
                                ],
                              ),
                              title: Text("${i.title}"),
                              trailing: InkWell(
                                  child: Icon(Icons.delete),
                                  onTap: () {
                                    setState(() {
                                      ExpensesDatabase.instance
                                          .deleteExpense(i);
                                    });
                                  }),
                            ),
                          );
                        }),
                  );
                } else {
                  return Center(
                    child: Text("NO CURRENT EXPENSES"),
                  );
                }
              }),
          Divider(),
          FutureBuilder<List<Income>>(
              future: IncomesDatabase.instance.showIncomes(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Income>> snapshot) {
                if (snapshot.hasData) {
                  List<Income> incomeList = snapshot.data!;
                  return SizedBox(
                    height: 150.0, // put mediaquery here
                    child: ListView.builder(
                        itemCount: incomeList.length,
                        itemBuilder: (context, index) {
                          final i = incomeList[index];
                          var incomeSum =
                              ExpensesDatabase.instance.getSumExpenses();
                          return Container(
                            margin: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                width: 2.0,
                                color: getCategoryColor(i.category),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black38,
                                    offset: Offset(0, 2),
                                    blurRadius: 6.0),
                              ],
                            ),
                            child: ListTile(
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    i.category,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("${i.amount} " + chosenCurrency),
                                  Text(
                                    DateFormat("yyyy-MM-dd").format(i.date),
                                  ),
                                ],
                              ),
                              title: Text("${i.title}"),
                              trailing: InkWell(
                                  child: Icon(Icons.delete),
                                  onTap: () {
                                    setState(() {
                                      IncomesDatabase.instance.deleteIncome(i);
                                    });
                                  }),
                            ),
                          );
                        }),
                  );
                } else {
                  return Center(
                    child: Text("NO CURRENT INCOMES"),
                  );
                }
              }),
        ],
      ),
    );
  }
}
