import 'package:ai_assistance_app/widget/homepage.dart';
import 'package:flutter/material.dart';


Future<void> main() async{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Assistance APP',
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
    );
  }
}
