import 'package:flutter/material.dart';
import 'package:shopping_list/screens/groceries.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Groceries',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 147, 229, 250),
          brightness: Brightness.dark,
          surface: Color.fromARGB(255, 42, 51, 59),
        ),
        scaffoldBackgroundColor: Color.fromARGB(255, 50, 58, 60),
      ),
      home: GroceryScreen(),
    );
  }
}