// import 'dart:js';

import 'dart:async';

// import 'package:flutter/material.dart';

// import 'package:web_socket/socketio.dart';

// /home/ibrahim/Desktop/coding/Flutter/learn/sproj_final/front end museebat/

// import 'package:web_socket/socketio.dart';

import 'package:web_socket/socketio.dart';

// Map<String, dynamic> globalMap;
StreamController<Map<String, dynamic>> data;

SocketUtil socketUtil;

var userUsageLimit = 2000.0;
