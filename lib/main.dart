import 'package:flutter/material.dart';

import 'helpers/user_preferences.dart';
import 'widgets/root_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSimplePreferences.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expenses Pro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RootApp(),
    );
  }
}
