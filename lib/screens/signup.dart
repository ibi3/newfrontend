import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket/screens/login.dart';
import 'dart:convert';
import 'dart:core';

import 'package:web_socket/signup.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: AppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20.0, 80.0, 20.0, 20.0),
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            SignupForm(),
          ],
        ),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();

  String username, password;

  bool signupInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              onChanged: (text) => username = text,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(17.0),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              onChanged: (text) => password = text,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(17.0),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            width: double.infinity,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17.0)),
              color: Colors.green,
              disabledColor: Colors.grey,
              onPressed: signupInProgress
                  ? null
                  : () async {
                      try {
                        setState(() {
                          signupInProgress = true;
                        });
                        var result = await signup(username, password);
                        if (result == false) {
                          final snackbar =
                              SnackBar(content: Text('Incorrect credentials'));
                          Scaffold.of(context).showSnackBar(snackbar);
                        } else {
                          final snackbar =
                              SnackBar(content: Text('Logged in!'));
                          Scaffold.of(context).showSnackBar(snackbar);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        }
                      } catch (error) {
                        final snackbar =
                            SnackBar(content: Text('An error occured'));
                        Scaffold.of(context).showSnackBar(snackbar);
                      } finally {
                        setState(() {
                          signupInProgress = false;
                        });
                      }
                    },
              child: Text(
                signupInProgress ? 'Working...' : 'Sign Up',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextSpan(
                      text: 'Login!',
                      style: TextStyle(color: Colors.green),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final String apiUrl = 'http://192.168.248.1:3000/users/';

dynamic signup(username, password) async {
  final http.Response response = await http.post(
    apiUrl,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
    }),
  );
  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}
