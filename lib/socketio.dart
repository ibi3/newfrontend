import 'dart:convert';
// import 'package:adhara_socket_io/adhara_socket_io.dart';
// import 'package:socket_io/socket_io.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'Globals.dart' as G;

class SocketUtil {
  dynamic userId;
  IO.Socket socket;
  static const URI = 'http://192.168.248.1:3002/';
  SocketUtil(dynamic id) {
    this.userId = id;
  }
  initSocket() async {
    this.socket =
        IO.io(URI, IO.OptionBuilder().setTransports(['websocket']).build());

    socket.onConnect((_) {
      print('connected');
      print(this.userId);
      socket.emit("token", [this.userId]);
    });
    // socket.on('message', (data) => print(data));
    socket.onReconnectAttempt((_) => print("reconnect attempt"));
    socket.onDisconnect((_) => print('disconnect'));
    socket.onError((err) {
      print("sdasad");
      print(err);
    });
    socket.on("sensor-data-snapshot", (data) {
      data = json.decode(data);
      print(data);
      G.data.add(data[0]);
    });
    // socket.on('fromServer', (_) => print(_));
    // socket.connect();
  }

  sendMessage(String messageType, String message) {
    if (socket != null) {
      // pprint("sending message from '$'...");
      this.socket.emit(messageType, [message]);
      // pprint("Message emitted from '$identifier'...");
    }
  }

  pprint(data) {
    if (data is Map) {
      data = json.encode(data);
    }
    print(data);
  }
}

// socket = IO.io(
//         'http://10.0.2.2:4005',
//         IO.OptionBuilder()
//             .setTransports(['websocket'])
//             .disableAutoConnect()
//             .build());
//     socket.onConnect((_) {
//       print('connect');
//     });
//     socket.onDisconnect((_) => print('disconnect'));
//     socket.on('greet', (data) {
//       print("server says" + data);
//       socket.emit('msg', "HELLO");
//     });
//     socket.connect();
//   }
