import 'package:flutter/material.dart';

import 'daily_page.dart';
import 'nav_bar.dart';

class RootApp extends StatefulWidget {
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DailyPage(),
      drawer: NavBar(),
    );
  }
}
