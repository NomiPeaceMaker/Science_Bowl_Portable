import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import "package:hex/hex.dart";
import 'package:sciencebowlportable/models/Models.dart';
import 'package:sciencebowlportable/globals.dart';
import 'package:random_string/random_string.dart';
import 'dart:convert';

// source:
// https://stackoverflow.com/questions/60397701/using-flutter-app-to-run-socketserver-and-communicate-with-other-phone-via-socke

class Server {
  Server({this.onError, this.onData});

  Uint8ListCallback onData;
  DynamicCallback onError;
  ServerSocket server;
  bool running = false;
  var sockets = <String, Socket>{};

  start() async {
    runZoned(() async {
      server = await ServerSocket.bind('0.0.0.0', PORT);
      this.running = true;
      server.listen(onRequest);
      this.onData(Uint8List.fromList('Server listening on port 4040'.codeUnits));
      }, onError: (e) {
        this.onError(e);
      });
  }

  stop() async {
    await this.server.close();
    this.server = null;
    this.running = false;
  }

  sendAll(String message) {
    sockets.forEach((userID, socket) => {
      socket.write(message),
    });
  }

  onRequest(Socket socket) {
    print(socket);
    socket.write(json.encode({"type" : "Connected"}));
    socket.listen((Uint8List data) {
      var msg = json.decode(String.fromCharCodes(data));
      if (msg["type"]=="uniqueID") {
        sockets[msg["ID"]] = socket;
        socket.write(json.encode({"type": "recieved"}));
        print(msg["ID"]);
        print(socket);
      } else {
        this.onData(data);
      }
    });
  }

  String ip2key(String input) {
    input = fixip(input);
    String random_part = randomAlphaNumeric(3);
    String key;
    if (input[1] == '9')
    {
      key = (random_part + HEX.encode([int.parse(input[12] + input[13] + input[14])]));
    }
    return key;
  }

  String fixip(String input) {
    int i = 8;
    String a = '';
    String b = '';

    while(input[i]!= '.') {
      a = a + input[i];
      i++;
    }

    if(a.length ==1) {
      a = '00' + a;
    } else if(a.length ==2) {
      a = '0' + a;
    }

    i++;

    while(i< input.length) {
      b = b + input[i];
      i++;
    }

    if(b.length ==1) {
      b = '00' + b;
    } else if(b.length ==2)
    {
      b = '0' + b;
    }
    return '192.168.'+a+'.'+b;
  }
}