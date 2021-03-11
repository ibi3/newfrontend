import 'Globals.dart' as G;
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:web_socket/getRoomsWidget.dart';

bool isLeapYear(int year) {
  if (year % 4 == 0) {
    if (year % 100 == 0) {
      if (year % 400 == 0) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  } else {
    return false;
  }
}

double getMonthTotalDays(int month, int year) {
  if ([01, 03, 05, 07, 08, 10, 12].contains(month)) {
    return 31;
  } else if (month == 2) {
    if (isLeapYear(year)) {
      return 29;
    } else {
      return 28;
    }
  }
  return 30;
}

double getEstimateUsage(String date, double monthUsage) {
  List parsedDate = date.split("-");
  String currentDay = parsedDate[2];
  String currentMonth = parsedDate[1];
  String currentYear = parsedDate[0];

  double totalDaysOfMonth =
      getMonthTotalDays(int.parse(currentMonth), int.parse(currentYear));
  double totalApproxUsage =
      (monthUsage / double.parse(currentDay)) * totalDaysOfMonth;
  return totalApproxUsage;
}

double getEstimatedBill(String date, double monthUsage) {
  double totalEstimatedUsage = getEstimateUsage(date, monthUsage);
  double totalBill = 0;
  if (totalEstimatedUsage <= 50 / 1000) {
    totalBill += totalEstimatedUsage * 2;
  } else if (totalEstimatedUsage <= 5) {
    if (totalEstimatedUsage <= 100 / 1000) {
      totalBill += totalEstimatedUsage * 5.79;
    } else {
      totalBill += 100 * 5.79;
      totalEstimatedUsage -= 100;
      if (totalEstimatedUsage <= 100 / 1000) {
        totalBill += totalEstimatedUsage * 8.11;
      } else {
        totalBill += 100 * 5.79;
        totalEstimatedUsage -= 100;
        if (totalEstimatedUsage <= 100 / 1000) {
          totalBill += totalEstimatedUsage * 10.2;
        } else {
          totalBill += 100 * 10.2;
          totalEstimatedUsage -= 100;
          if (totalEstimatedUsage <= 400 / 1000) {
            totalBill += totalEstimatedUsage * 17.6;
          } else {
            totalBill += 400 * 17.6;
            totalEstimatedUsage -= 400;
            if (totalEstimatedUsage > 0) {
              totalBill += totalEstimatedUsage * 20.7;
            }
          }
        }
      }
    }
  } else {
    totalBill = totalEstimatedUsage * 14.38;
  }
  return totalBill;
}

// DateTime(1002,02,12);

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

Widget TrendsScreenWidget(Map overAllData, double monthUsage) {
  String currentDate = overAllData['Date_Time'].split(" ")[0];
  List datacomponentPowerUsage = roomBarSeries(overAllData);
  List<List> dataFiveDaysPowerUsage = [
    [200.0, "21/11/2019"],
    [300.0, "22/11/2019"],
    [210.0, "23/11/2019"],
    [201.0, "24/11/2019"],
    [500.0, "25/11/2019"]
  ];

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
        height: 100,
        // padding: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
          child: Card(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: Container(
                    child: Text(
                      'Current Month Usage: ',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    child: Text(
                      monthUsage.toStringAsFixed(3) + " kWh",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(color: Colors.white),
        height: 100,
        margin: EdgeInsets.only(top: 7),
        // padding: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
          child: Card(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: Container(
                    child: Text(
                      'Expected Bill: ',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    child: Text(
                      getEstimatedBill(currentDate, monthUsage)
                              .toStringAsFixed(0) +
                          " Rs",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                ),
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
