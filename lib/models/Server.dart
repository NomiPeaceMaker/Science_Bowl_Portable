import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import "package:hex/hex.dart";
import 'package:sciencebowlportable/models/Models.dart';
import 'package:sciencebowlportable/globals.dart';
import 'package:random_string/random_string.dart';
import 'dart:convert';

class Server {

  Server({this.onError, this.onData});

  Uint8ListCallback onData;
  DynamicCallback onError;
  ServerSocket server;
  bool running = false;
  List<Socket> sockets = [];

  start() async {
    print("STARTIED LISTENING!");
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
    for (Socket socket in sockets) {
      print(message);
      print(socket.address);
      socket.write(message);
    }
  }

//  broadCast(String message) {
//    this.onData(Uint8List.fromList('Broadcasting : $message'.codeUnits));
//    for (Socket socket in sockets) {
//      socket.write( message );
//    }
//  }

  onRequest(Socket socket) {
    print("New User");
    print(socket);
    socket.write(json.encode({"type" : "Connected"}));
    socketDataStreamController.add(json.encode({"type" : "newUserConnected"}));
    print("Sending connect message to client.");
    if (!sockets.contains(socket)) {
      sockets.add(socket);
    }
    socket.listen((Uint8List data) {
      this.onData(data);
    });

    socket.drain().then((_) {
      print('Player left');
      socket.close();
    });
  }

  String ip2key(String input)
  {
    input = fixip(input);
    String random_part = randomAlphaNumeric(3);
    String key;
    if (input[1] == '9')
    {
      key = (random_part + HEX.encode([int.parse(input[12] + input[13] + input[14])]));
    }
    return key;
  }

  String fixip(String input)
  {
    int i = 8;
    String a = '';
    // int a1;
    String b = '';
    // int b1;

    while(input[i]!= '.')
    {
      a = a + input[i];
      i++;
    }

    if(a.length ==1)
    {
      a = '00' + a;
    }
    if(a.length ==2)
    {
      a = '0' + a;
    }

    i++;

    while(i< input.length)
    {
      b = b + input[i];
      i++;
    }

    if(b.length ==1)
    {
      b = '00' + b;
    }
    if(b.length ==2)
    {
      b = '0' + b;
    }
    return '192.168.'+a+'.'+b;
  }

}