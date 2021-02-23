import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket/homeScreen.dart';
import 'dart:convert';
import 'dart:core';
import '../Globals.dart' as G;
import 'package:web_socket/screens/signup.dart';

import '../socketio.dart';

class LoginScreen extends StatelessWidget {
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
            LoginForm(),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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
              onPressed: loginInProgress
                  ? null
                  : () async {
                      try {
                        setState(() {
                          loginInProgress = true;
                        });
                        var result = await login(email, password);
                        // print(result);
                        if (result == false) {
                          final snackbar =
                              SnackBar(content: Text('Incorrect credentials'));
                          Scaffold.of(context).showSnackBar(snackbar);
                        } else {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                          // final snackbar =
                          //     SnackBar(content: Text('Logged in!'));
                          // Scaffold.of(context).showSnackBar(snackbar);
                        }
                      } catch (error) {
                        print(error);
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
                loginInProgress ? 'Logging in...' : 'Login',
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
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => SignupScreen()));
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

final String apiUrl = 'http://192.168.248.1:3001/login';

dynamic login(username, password) async {
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

  if (response.statusCode == 200) {
    Map<String, dynamic> body = jsonDecode(response.body);
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("accessToken", body['accessToken']);
    pref.setString("refreshToken", body['refreshToken']);
    var socketUtil = SocketUtil(body['accessToken']);
    G.socketUtil = socketUtil;
    await G.socketUtil.initSocket();
  } else {
    return false;
  }

  // if (body.containsKey('data')) {
  //   return body['data'];
  // }
}
