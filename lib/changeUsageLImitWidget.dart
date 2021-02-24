import 'package:flutter/material.dart';
import 'package:web_socket/homeScreen.dart';
// import 'package:web_socket/homeScreen.dart';
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

    usageController.text = G.userUsageLimit.toString();
  }

  Future<void> changeUsageLimit() async {
    final bool x = _formKey.currentState.validate();
    if (x) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var userID = pref.getString('userid');
      try {
        var result = await http.post('http://10.0.2.2:3000/limit',
            body: {'userid': userID, 'limit': usageController.text});

        var response = json.decode(result.body);
        if (response['error'] == true) {
          print("error");
        } else {
          pref.setString('limit', G.userUsageLimit.toString());
          G.userUsageLimit = double.parse(usageController.text);
          this.setState(() {
            this.editSettings = false;
            this.settingsedited = true;
          });
          widget.parentClass.setState(() {
            widget.parentClass.usageLimit = G.userUsageLimit;
          });
        }
      } catch (e) {
        print(e);
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
                      textColor: editSettings ? Colors.white : Colors.blueGrey,
                      // color: Colors.blue,
                      child: Text('Update'),

                      onPressed: changeUsageLimit,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
