// import 'package:web_socket/bottomnavigationbarwidget.dart';
import 'package:web_socket/changeUsageLImitWidget.dart';
import 'package:web_socket/homeScreenWidget.dart';
import 'package:web_socket/trendsScreenWidget.dart';
// import 'getRoomsWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Globals.dart' as G;
import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  PrHomeScreen createState() => PrHomeScreen();
}

class PrHomeScreen extends State<HomeScreen> {
  // var currentElectricityUsage = 0.0;
  // var electricityUsed = 0.0;
  // var percentElectricityUsed = 0.0;
  var usageLimit = 0.0;
  var _selectedIndex = 0;
  bool buttonPressed = false;
  Map<String, double> unitsInfo;
  Map<String, double> billInfo;
  List<Widget> _children;

  double estimatedBill(var unitsUsed) {
    return unitsUsed * 18.90;
  }

  @override
  void initState() {
    super.initState();
    // this.currentElectricityUsage = double.parse(G.globalMap["Usage_kW"]);
    // this.electricityUsed += this.currentElectricityUsage;
    getData();
  }

  Future<void> navbarTapped(int index) async {
    this.setState(() {
      this._selectedIndex = index;
    });
  }

  Future<void> getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var usageLimit = pref.getString('usageLimit');
    this.usageLimit = double.parse(usageLimit);
  }

  @override
  Widget build(BuildContext context) {
    // if (G.globalMap != null) {
    return StreamBuilder(
      stream: G.data.stream,
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        _children = [
          HomeScreenWidget(overAllData: snapshot.data, context: this.context),
          TrendsScreenWidget(snapshot.data),
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
        // } else {
        //   return Scaffold(
        //     backgroundColor: Colors.black,
        //     body: Center(
        //       child: Text(
        //         "No data available",
        //         style: TextStyle(
        //           color: Colors.white,
        //           fontWeight: FontWeight.bold,
        //         ),
        //         textAlign: TextAlign.center,
        //       ),
        //     ),
        //   );
        // }
      },
    );
  }
}
