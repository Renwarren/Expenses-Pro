import 'dart:io';

import 'package:expenses_pro/widgets/expense_page.dart';
import 'package:flutter/material.dart';

import '/helpers/user_preferences.dart';
import 'daily_page.dart';
import 'income_page.dart';
import 'settings_page.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  String name = "userName";

  String email = "userEmail";

  String image = "assets/images/salary.jpg";

  @override
  void initState() {
    if (UserSimplePreferences.getUsername() == null) {
    } else {
      name = UserSimplePreferences.getUsername() as String;
      email = UserSimplePreferences.getEmail() as String;
      image = UserSimplePreferences.getImage() as String;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Colors.blue,
        child: ListView(
          children: [
            buildHeader(
              name: name,
              email: email,
              image: image,
            ),
            const SizedBox(
              height: 48,
            ),
            buildMenuItem(
              text: "Home",
              icon: Icons.home,
              onClicked: () => selectedItem(context, 0),
            ),
            buildMenuItem(
              text: "Expenses",
              icon: Icons.money,
              onClicked: () => selectedItem(context, 1),
            ),
            buildMenuItem(
              text: "Incomes",
              icon: Icons.wallet_giftcard,
              onClicked: () => selectedItem(context, 2),
            ),
            buildMenuItem(
              text: "Stats",
              icon: Icons.query_stats,
              onClicked: () => selectedItem(context, 3),
            ),
            Divider(),
            buildMenuItem(
              text: "Settings",
              icon: Icons.settings,
              onClicked: () => selectedItem(context, 4),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    VoidCallback? onClicked,
    required String text,
    required IconData icon,
  }) {
    final color = Colors.black;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: TextStyle(
          color: Colors.black87,
        ),
      ),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DailyPage(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ExpensePage(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => IncomePage(),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DailyPage(),
        ));
        break;
      case 4:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SettingsPage(),
        ));
        break;
    }
  }

  Widget buildHeader({
    required String name,
    required String email,
    required String image,
  }) =>
      InkWell(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20)
              .add(EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: FileImage(new File(image)),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
}


//Material is tapable