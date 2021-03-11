import 'package:flutter/material.dart';
import 'package:web_socket/homeScreen.dart';
import 'Globals.dart' as G;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLimitScreen extends StatefulWidget {
  final double usageLimit;
  final PrHomeScreen parentClass;
  ChangeLimitScreen({Key key, this.usageLimit, this.parentClass})
      : super(key: key);
  @override
  _ChangeLimitScreen createState() => _ChangeLimitScreen();
}

class _ChangeLimitScreen extends State<ChangeLimitScreen> {
  bool editSettings = false;
  bool settingsedited = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController usageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    usageController.text = widget.usageLimit.toString();
  }

  Future<String> changeUsageLimit() async {
    final bool x = _formKey.currentState.validate();
    if (x) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var token = pref.getString('accessToken');
      try {
        print(usageController.text);
        var result = await http.put(
            G.ip + ":" + G.restAPIPort + '/api/usage/limit',
            headers: {
              'authorization': token,
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: jsonEncode({'usageLimit': usageController.text}));

        Map response = json.decode(result.body);
        if (response.containsKey('error')) {
          return response['error'];
        } else {
          this.setState(() {
            this.editSettings = false;
            this.settingsedited = true;
          });
          widget.parentClass.setState(() {
            widget.parentClass.usageLimit = double.parse(usageController.text);
          });
          return response['data'];
        }
      } catch (e) {
        return e.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Text(
                'Monthly Usage Limit',
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    enabled: editSettings,
                    validator: (value) {
                      if (double.parse(value) < 0) {
                        return "Please Enter a valid value";
                      }
                      return null;
                    },
                    controller: usageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 5, 15, 20),
                  child: FlatButton(
                      onPressed: () {
                        this.setState(() {
                          this.editSettings = true;
                        });
                      },
                      child: Text(
                        "Edit",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.red,
                            decoration: TextDecoration.underline),
                      )),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: RaisedButton(
                        color: editSettings ? Colors.greenAccent : Colors.grey,
                        textColor:
                            editSettings ? Colors.white : Colors.blueGrey,
                        // color: Colors.blue,
                        child: Text('Update'),
                        onPressed: () async {
                          String limitUpdateResponse = await changeUsageLimit();
                          final snackbar =
                              SnackBar(content: Text(limitUpdateResponse));
                          Scaffold.of(context).showSnackBar(snackbar);
                        })),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
