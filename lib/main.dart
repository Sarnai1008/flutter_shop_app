import 'package:flutter/material.dart';
import '../../../screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
    @override
  Widget build(BuildContext context) {
       return MaterialApp(
          theme: ThemeData(
            useMaterial3: false,
            ),
      home:const HomePage(),
    );
  }
}
