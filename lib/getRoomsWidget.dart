import 'package:flutter/material.dart';

String getRoomName(String shortName) {
  String result;
  if (shortName == "BR1") {
    result = 'Bedroom 1';
  } else if (shortName == "GR") {
    result = 'Game Room';
  } else if (shortName == "MB") {
    result = "Main Bedroom";
  } else if (shortName == "SR") {
    result = "Sun Room";
  } else if (shortName == "Dr") {
    result = "Dining Room";
  } else if (shortName == "BR3") {
    result = "Bedroom 3";
  } else if (shortName == "BR2") {
    result = "Bedroom 2";
  } else if (shortName == "Reg") {
    result = "Regular";
  } else if (shortName == "BR") {
    result = "Bedroom";
  } else if (shortName == "DNR") {
    result = "Dining Room";
  } else if (shortName == "DR") {
    result = "Drawing Room";
  } else if (shortName == "UPS") {
    result = "UPS";
  } else if (shortName == "MBR") {
    result = "Main Bedroom";
  } else if (shortName == "LR") {
    result = "Living Room";
  } else {
    result = shortName;
  }
  return result;
}

Widget listWidgets(
    BuildContext context, String name, double usage, double totalUsage,
    {String component = ""}) {
  return Container(
    margin: EdgeInsets.fromLTRB(0, 0, 0, 7.0),
    decoration: BoxDecoration(color: Colors.transparent),
    // alignment: AlignmentGeometry.lerp(),
    height: MediaQuery.of(context).size.height * 0.09,
    width: MediaQuery.of(context).size.width,
    child: Column(
      children: <Widget>[
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                name + " " + component + " is on",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
              ),
              Text(
                ((usage / totalUsage) * 100).toStringAsFixed(2) + "%",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

List getEachBar(String name, double usage, {String component = ""}) {
  return [usage, name + " " + component];
}

List<Widget> roomsList(Map usage, BuildContext context) {
  final children = <Widget>[];
  print(usage);
  // print(usage);
  double totalUsage = double.parse(usage['Usage_kW']);
  usage.forEach((key, value) {
    List a = key.split('_');
    if (a[0] == "Usage" || a[0] == "Date" || key == '_id') {
    } else if (a.length > 2) {
      if (double.parse(value) < 0.0001) {
      } else {
        children.add(listWidgets(
            context, getRoomName(a[1]), double.parse(value), totalUsage,
            component: a[0]));
      }
    } else if (a.length == 2) {
      if (double.parse(value) < 0.0001) {
      } else {
        listWidgets(
            context, getRoomName(a[0]), double.parse(value), totalUsage);
      }
    }
  });
  return children;
}

List roomBarSeries(Map usage) {
  final children = [];
  usage.forEach((key, value) {
    List a = key.split('_');
    if (a[0] == "Usage" || a[0] == "Date" || key == '_id') {
    } else if (a.length > 2) {
      if (double.parse(value) < 0.0001) {
      } else {
        children.add(getEachBar(a[1], double.parse(value), component: a[0]));
      }
    } else if (a.length == 2) {
      if (double.parse(value) < 0.0001) {
      } else {
        children.add(getEachBar(a[0], double.parse(value)));
      }
    }
  });
  return children;
}
