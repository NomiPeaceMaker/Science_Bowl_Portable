import 'dart:io';
import 'dart:typed_data';
import 'package:sciencebowlportable/models/Models.dart';
import 'package:sciencebowlportable/globals.dart';
import "package:hex/hex.dart";

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
  bool connected = false;

  Socket socket;

  connect() async {
    print("TRY TO CONNECT");
    try {
      socket = await Socket.connect(hostname, PORT);
      print("CONNECTION SUCCESSFULL");
      socket.listen(
        onData,
        onError: onError,
        onDone: disconnect,
        cancelOnError: false,
      );
      connected = true;
    } on Exception catch (exception) {
      onError(("Error : $exception"));
    }
  }

  write(String message) {
    //Connect standard in to the socket
    socket.write(message);
  }

  disconnect() {
    if (socket != null) {
      socket.destroy();
      connected = false;
    }
  }
}

String key2ip(String input, String subnet)
{
  String ip;
  String second;
  
  //input[0]+input[1]+input[2] = string of 3 random letter/numbers
  second = (HEX.decode(input[3]+input[4]))[0].toString();
  ip = subnet + '.' + second;

  return ip;
}