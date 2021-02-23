import 'Globals.dart' as G;
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:web_socket/getRoomsWidget.dart';

class ComponentPowerUsage {
  final double powerUsage;
  final String component;
  final charts.Color barColor =
      charts.ColorUtil.fromDartColor(Colors.greenAccent);

  ComponentPowerUsage({@required this.powerUsage, @required this.component});
}

class FiveDaysPowerUsage {
  final double powerUsage;
  final String date;

  final charts.Color barColor =
      charts.ColorUtil.fromDartColor(Colors.greenAccent);

  FiveDaysPowerUsage({@required this.powerUsage, @required this.date});
}

Widget TrendsScreenWidget(Map overAllData) {
  // bool dataLoading = true;
  List datacomponentPowerUsage = roomBarSeries(overAllData);
  List<List> dataFiveDaysPowerUsage = [
    [200.0, "21/11/2019"],
    [300.0, "22/11/2019"],
    [210.0, "23/11/2019"],
    [201.0, "24/11/2019"],
    [500.0, "25/11/2019"]
  ];
  List<Color> colorList;

  List<ComponentPowerUsage> componentPowerUsages;
  List<FiveDaysPowerUsage> fiveDaysPowerUsages;

  componentPowerUsages = datacomponentPowerUsage
      .map((tuple) =>
          ComponentPowerUsage(powerUsage: tuple[0], component: tuple[1]))
      .toList();

  fiveDaysPowerUsages = dataFiveDaysPowerUsage
      .map((tuple) => FiveDaysPowerUsage(powerUsage: tuple[0], date: tuple[1]))
      .toList();

  List<charts.Series<ComponentPowerUsage, String>> componentSeries = [
    charts.Series(
      id: "componentsuse",
      data: componentPowerUsages,
      domainFn: (ComponentPowerUsage series, _) => series.component,
      measureFn: (ComponentPowerUsage series, _) => series.powerUsage,
      colorFn: (ComponentPowerUsage series, _) => series.barColor,
    )
  ];

  List<charts.Series<FiveDaysPowerUsage, String>> fiveDaysSeries = [
    charts.Series(
      id: "dailyuse",
      data: fiveDaysPowerUsages,
      domainFn: (FiveDaysPowerUsage series, _) => series.date,
      measureFn: (FiveDaysPowerUsage series, _) => series.powerUsage,
      colorFn: (FiveDaysPowerUsage series, _) => series.barColor,
    )
  ];

  return ListView(
    // mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        decoration: BoxDecoration(color: Colors.white),
        height: 300,
        padding: EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Component Use',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: charts.BarChart(componentSeries, animate: true),
                )
              ],
            ),
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(color: Colors.white),
        margin: EdgeInsets.only(top: 15),
        height: 300,
        padding: EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Power data of the last 5 days',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: charts.BarChart(fiveDaysSeries, animate: true),
                )
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
