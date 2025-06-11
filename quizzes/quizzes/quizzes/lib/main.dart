import 'package:flutter/material.dart';
import 'package:quizzes/users/pages/auth/login.dart';

import 'admin/screens/login_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
        //home: LoginScreen(), // for admin
     home: UserLoginPage(), // for User
      debugShowCheckedModeBanner: false,
    );
  }
}
