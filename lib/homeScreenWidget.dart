import 'package:flutter/material.dart';
// import 'package:web_socket/homeScreen.dart';
import 'Globals.dart' as G;

import 'getRoomsWidget.dart';

class HomeScreenWidget extends StatefulWidget {
  final Map<String, dynamic> overAllData;
  final BuildContext context;
  HomeScreenWidget({Key key, this.overAllData, this.context}) : super(key: key);
  @override
  _HomeScreenWidget createState() => _HomeScreenWidget();
}

class _HomeScreenWidget extends State<HomeScreenWidget> {
  double percentUsed = 0.7;
  @override
  Widget build(BuildContext context) {
    return ListView(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 15.0),
          decoration: BoxDecoration(color: Colors.transparent),
          height: MediaQuery.of(context).size.height * 0.5,
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                padding: EdgeInsets.only(left: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Usage: ' +
                        widget.overAllData["Usage_kW"].toStringAsFixed(3) +
                        " KWH",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.zero,
                width: MediaQuery.of(widget.context).size.width * 0.4,
                height: MediaQuery.of(widget.context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Center(
                  child: Container(
                    width: MediaQuery.of(widget.context).size.width * 0.07,
                    height: MediaQuery.of(widget.context).size.height * 0.4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: LinearProgressIndicator(
                          minHeight: 20,
                          value: this.percentUsed,
                          valueColor: AlwaysStoppedAnimation(
                            percentUsed >= 1.0
                                ? Colors.redAccent
                                : Colors.greenAccent,
                          ),
                          backgroundColor: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: roomsList(widget.overAllData, widget.context),
          ),
        ),
      ],
    );
  }
}
