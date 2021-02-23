// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';

class SignupScreenO extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
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
  String email, password;

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
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  )),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              onChanged: (text) => password = text,
              decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  )),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            width: double.infinity,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17.0)),
              color: Colors.deepPurple,
              onPressed: () async {
                print(1);
                try {
                  var result = await signup(email, password);
                  print("result: $result");
                  if (result == false) {
                    final snackbar =
                        SnackBar(content: Text('Incorrect credentials'));
                    Scaffold.of(context).showSnackBar(snackbar);
                  } else {
                    final snackbar =
                        SnackBar(content: Text('Account created succesfully!'));
                    Scaffold.of(context).showSnackBar(snackbar);
                  }
                } catch (error) {
                  print('error: $error');
                  final snackbar = SnackBar(content: Text('An error occured'));
                  Scaffold.of(context).showSnackBar(snackbar);
                }
              },
              child: Text(
                'Register',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final String apiUrl = "https://damp-scrubland-66596.herokuapp.com/api/";

dynamic signup(email, password) async {
  final http.Response response = await http.post(
    apiUrl + 'user/register/',
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
