// import 'dart:js';

// import 'package:flutter/material.dart';

// import 'package:web_socket/socketio.dart';

// /home/ibrahim/Desktop/coding/Flutter/learn/sproj_final/front end museebat/

// import 'package:web_socket/socketio.dart';

import 'package:web_socket/socketio.dart';

// Map<String, dynamic> globalMap;

const String ip = 'http://10.0.2.2';
const String signupPort = '8000';
const String loginPort = '8000';
const String streamPort = '8002';
const String restAPIPort = '8004';

SocketUtil socketUtil;

var userUsageLimit = 2000.0;
