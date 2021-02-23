import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';

// import 'package:web_socket/signup.dart';

class LoginScreenO extends StatelessWidget {
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
                'Login',
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
            LoginFormO(),
          ],
        ),
      ),
    );
  }
}

class LoginFormO extends StatefulWidget {
  @override
  _LoginFormStateO createState() => _LoginFormStateO();
}

class _LoginFormStateO extends State<LoginFormO> {
  final _formKey = GlobalKey<FormState>();

  String email, password;

  bool loginInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              onChanged: (text) => email = text,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Email',
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
              onPressed: loginInProgress
                  ? null
                  : () async {
                      try {
                        setState(() {
                          loginInProgress = true;
                        });
                        var result = await login(email, password);
                        if (result == false) {
                          final snackbar =
                              SnackBar(content: Text('Incorrect credentials'));
                          Scaffold.of(context).showSnackBar(snackbar);
                        } else {
                          final snackbar =
                              SnackBar(content: Text('Logged in!'));
                          Scaffold.of(context).showSnackBar(snackbar);
                        }
                      } catch (error) {
                        final snackbar =
                            SnackBar(content: Text('An error occured'));
                        Scaffold.of(context).showSnackBar(snackbar);
                      } finally {
                        setState(() {
                          loginInProgress = false;
                        });
                      }
                    },
              child: Text(
                loginInProgress ? 'Working...' : 'Log in',
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
                    text: 'Don\'t have an account? ',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextSpan(
                      text: 'Sign up!',
                      style: TextStyle(color: Colors.green),
                      recognizer: TapGestureRecognizer()..onTap = () {})
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final String apiUrl = 'https://damp-scrubland-66596.herokuapp.com/api/';

dynamic login(email, password) async {
  final http.Response response = await http.post(
    apiUrl + 'user/login/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );

  Map<String, dynamic> body = jsonDecode(response.body);

  if (body.containsKey('data')) {
    return body['data'];
  } else {
    return false;
  }
}
