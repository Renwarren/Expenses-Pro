import 'package:expenses_pro/databases/income_database.dart';
import 'package:expenses_pro/models/income.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '/helpers/category.dart';
import 'package:flutter/material.dart';

class NewIncome extends StatefulWidget {
  const NewIncome({Key? key}) : super(key: key);

  @override
  _NewIncomeState createState() => _NewIncomeState();
}

class _NewIncomeState extends State<NewIncome> {
  int activeCategory = 0;
  String category = "Salary";
  DateTime date = DateTime(2000);
  TextEditingController _titleController = TextEditingController();
  FocusNode _titleFocusNode = FocusNode();
  TextEditingController _amountController = TextEditingController();
  FocusNode _amountFocusNode = FocusNode();

  void titleListener() => setState(() {
        if (!_titleFocusNode.hasFocus) {
          FocusScope.of(context).requestFocus(FocusNode());
        }
      });

  void amountListener() => setState(() {
        if (!_amountFocusNode.hasFocus) {
          FocusScope.of(context).requestFocus(FocusNode());
        }
      });

  @override
  void initState() {
    super.initState();
    _titleController.addListener(titleListener);
    _titleFocusNode.addListener(titleListener);
    _amountController.addListener(amountListener);
    _amountFocusNode.addListener(amountListener);
  }

  @override
  void dispose() {
    _titleController.removeListener(titleListener);
    _titleFocusNode.removeListener(titleListener);
    _amountController.removeListener(amountListener);
    _amountFocusNode.removeListener(amountListener);
    _titleController.dispose();
    _titleFocusNode.dispose();
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  void presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        date = pickedDate;
      });
    });
  }

  void submitData() {
    if (_titleController.text.isEmpty || _amountController.text.isEmpty) return;

    final title = _titleController.text;
    final amount = double.parse(_amountController.text);

    if (title.isEmpty || amount <= 0 || date.year == 2000) return;

    setState(() {
      Income i = Income(
          amount: amount, title: title, category: category, date: date, id: 1);
      IncomesDatabase.instance.insertIncome(i);
      category = 'Salary';
      date = DateTime(2000);
      activeCategory = 0;
    });
    _titleController.clear();
    _amountController.clear();
    Fluttertoast.showToast(
      msg: "Income Successfully Added",
      backgroundColor: Colors.blue,
      fontSize: 16,
      textColor: Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Income Page'),
      ),
      backgroundColor: Colors.white.withOpacity(0.95),
      body: getBody(),
    );
  }

  Widget getBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
            ),
            child: Text(
              "Income Category",
              style: TextStyle(
                fontFamily: "Times",
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(incomeCategory.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      activeCategory = index;
                      category = incomeCategory[index]["name"];
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                    ),
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 10,
                      ),
                      width: 150,
                      height: 170,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: activeCategory == index
                                ? Colors.green
                                : Colors.transparent,
                            width: activeCategory == index ? 2 : 0),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.withOpacity(0.15),
                              ),
                              child: Center(
                                child: Image.asset(
                                  incomeCategory[index]["image"],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(
                              incomeCategory[index]["name"],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              "TITLE",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: TextField(
              focusNode: _titleFocusNode,
              controller: _titleController,
              cursorColor: Colors.black,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter Transaction Title",
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              "AMOUNT",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: TextField(
              focusNode: _amountFocusNode,
              controller: _amountController,
              keyboardType: TextInputType.number,
              cursorColor: Colors.black,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter Income Amount",
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              "DATE",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: InkWell(
              child: Text(
                date.year == 2000
                    ? "Click Here to Pick the Date"
                    : DateFormat.yMMMEd().format(date),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              onTap: presentDatePicker,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Center(
            child: ElevatedButton(
              onPressed: submitData,
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
