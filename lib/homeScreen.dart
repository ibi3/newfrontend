import 'dart:convert';
import 'package:web_socket/changeUsageLImitWidget.dart';
import 'package:web_socket/homeScreenWidget.dart';
import 'package:web_socket/trendsScreenWidget.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Globals.dart' as G;
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  PrHomeScreen createState() => PrHomeScreen();
}

class PrHomeScreen extends State<HomeScreen> {
  double monthUsage = 0;
  double usageLimit = 0;
  bool gettingData = true;
  var _selectedIndex = 0;
  bool buttonPressed = false;
  Map<String, double> unitsInfo;
  Map<String, double> billInfo;
  List<Widget> _children;
  Stream<Map> overAllDataStream;

  @override
  void initState() {
    super.initState();
    this.overAllDataStream = G.socketUtil.getStream;
    getData();
  }

  Future<void> navbarTapped(int index) async {
    this.setState(() {
      this._selectedIndex = index;
    });
  }

  Future<void> getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("accessToken");
    try {
      final http.Response usageResponse = await http.get(
          G.ip + ":" + G.restAPIPort + "/api/usage/limit",
          headers: {"authorization": token});
      Map userUsageLimit = json.decode(usageResponse.body);

      if (userUsageLimit.containsKey('error')) {
        this.usageLimit = 3000;
      } else {
        // print(userUsageLimit['data'].runtimeType);
        this.usageLimit = userUsageLimit['data'].toDouble();
        // print("Dsadsa");
      }
    } catch (e) {
      print(e);
    }

    try {
      final http.Response monthlyUsageResponse = await http.get(
          G.ip + ":" + G.restAPIPort + "/api/usage/monthly",
          headers: {"authorization": token});
      Map userMonthlyUsage = json.decode(monthlyUsageResponse.body);
      if (!userMonthlyUsage.containsKey('error')) {
        this.monthUsage = userMonthlyUsage['data'];
      }
    } catch (e) {
      print(e);
    }

    this.setState(() {
      this.gettingData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.gettingData) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return StreamBuilder(
      stream: overAllDataStream,
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        this.monthUsage += double.parse(snapshot.data['reading']['Usage_kW']);
        // String s= "DSasad";
        // s.split()
        _children = [
          HomeScreenWidget(
              overAllData: snapshot.data['reading'],
              parentContext: this.context,
              monthUsage: this.monthUsage,
              usageLimit: this.usageLimit),
          TrendsScreenWidget(snapshot.data['reading'], this.monthUsage),
          ChangeLimitScreen(
            parentClass: this,
            usageLimit: this.usageLimit,
          ),
        ];

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            leading: Icon(
              Icons.account_circle_sharp,
            ),
            title: Text(
              "بجلی",
              style: TextStyle(fontSize: 19, color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          body: _children[_selectedIndex],

          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Trends',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: navbarTapped,
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
      },
    );
  }
}
