import 'dart:async';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'Globals.dart' as G;

class SocketUtil {
  final _usageData = StreamController<Map<String, dynamic>>();
  dynamic userId;
  IO.Socket socket;
  static const URI = G.ip + ":" + G.streamPort;
  SocketUtil(dynamic id) {
    this.userId = id;
  }

  Stream<Map> get getStream => _usageData.stream;

  initSocket() async {
    this.socket = IO.io(
        URI,
        IO.OptionBuilder().setTransports(['websocket']).setExtraHeaders(
            {'token': this.userId}).build());

    socket.onConnect((_) {
      print('connected');
      // print(this.userId);
      // socket.emit("token", [this.userId]);
    });
    // socket.on('message', (data) => print(data));
    socket.onReconnectAttempt((_) => print("reconnect attempt"));
    socket.onDisconnect((_) {
      print('disconnect');
      _usageData.close();
    });
    socket.onError((err) {
      // print("sdasad");
      print(err);
    });
    socket.on("sensor-data-snapshot", (incomingData) {
      // print(incomingData);
      var incomingDataMap = json.decode(incomingData);
      _usageData.sink.add(incomingDataMap);
    });
  }

  sendMessage(String messageType, String message) {
    if (socket != null) {
      this.socket.emit(messageType, [message]);
    }
  }

  pprint(data) {
    if (data is Map) {
      data = json.encode(data);
    }
    print(data);
  }
}
