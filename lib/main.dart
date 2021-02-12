import 'package:flutter/material.dart';
import 'package:web_socket/screens/login.dart';

Future<void> main() async {
  runApp(
    MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
