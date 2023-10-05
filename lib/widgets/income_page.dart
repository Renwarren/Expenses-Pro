import 'package:expenses_pro/databases/expense_database.dart';
import 'package:expenses_pro/databases/income_database.dart';
import 'package:expenses_pro/helpers/category.dart';
import 'package:expenses_pro/helpers/user_preferences.dart';
import 'package:expenses_pro/models/expense.dart';
import 'package:expenses_pro/models/income.dart';
import 'package:expenses_pro/widgets/new_expense.dart';
import 'package:expenses_pro/widgets/new_income.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({Key? key}) : super(key: key);

  @override
  _IncomePageState createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  String chosenCurrency = UserSimplePreferences.getCurrency() as String;
  var incomeSum;

  void calcSum() async {
    var i = ExpensesDatabase.instance.getSumExpenses();
    print(i);
    setState(() {
      incomeSum = i as double;
    });
  }

  @override
  void initState() {
    super.initState();
    calcSum();
  }

  Widget totalIncome(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<String> text) {
        return Text(text.data!);
      },
      future: function(),
    );
  }

  Future<String> function() async {
    return incomeSum as String;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Incomes Page'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewIncome(),
                ),
              );
              setState(() {});
            },
          )
        ],
      ),
      backgroundColor: Colors.white.withOpacity(0.95),
      body: getBody(),
    );
  }

  Widget getBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 25,
              right: 25,
              top: 25,
            ),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.01),
                    spreadRadius: 10,
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    Text(
                      incomeCategory[0]["name"],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          FutureBuilder<List<Income>>(
              future: IncomesDatabase.instance.showIncomes(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Income>> snapshot) {
                if (snapshot.hasData) {
                  List<Income> incomeList = snapshot.data!;
                  return SizedBox(
                    height: 300.0, // put mediaquery here
                    child: ListView.builder(
                        itemCount: incomeList.length,
                        itemBuilder: (context, index) {
                          final i = incomeList[index];
                          incomeSum =
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
          //totalExpense(context),
        ],
      ),
    );
  }
}
