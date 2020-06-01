import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:sciencebowlportable/models/Models.dart';
import 'package:sciencebowlportable/globals.dart';
import "package:hex/hex.dart";

// source:
// https://stackoverflow.com/questions/60397701/using-flutter-app-to-run-socketserver-and-communicate-with-other-phone-via-socke

class Client {
  Client({
    this.onError,
    this.onData,
    this.hostname,
    this.port,
  });

  String hostname;
  int port;
  Uint8ListCallback onData;
  DynamicCallback onError;

  void Function(EventSink<Uint8List>) onTimeout;
  bool connected = false;

  Socket socket;

  connect() async {
    try {
      socket = await Socket.connect(hostname, PORT);
      socket.listen(
        onData,
        onError: onError,
        onDone: disconnect,
        cancelOnError: false,
      );
      socket.timeout(Duration(seconds: 4), onTimeout: onTimeout);
      connected = true;
    } on Exception catch (exception) {
      onError(("Error : $exception"));
    }
  }

  write(String message) {
    socket.write(message);
  }

  disconnect() {
    if (socket != null) {
      socket.destroy();
      connected = false;
    }
  }
}

String key2ip(String input, String subnet) {
  String ip = "";
  String second;
  try {
    second = (HEX.decode(input[3]+input[4]))[0].toString();
    ip = subnet + '.' + second;
  } catch(e) {
    print("key2ip error $e");
  }
  return ip;
}