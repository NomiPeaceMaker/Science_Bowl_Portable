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
  var sockets = <String, Socket>{};
//  List<Socket> sockets = [];

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
    print("SEND ALL CALLED");
    sockets.forEach((userID, socket) => {
      print("SENDING $message TO $userID"),
      socket.write(message),
    });
//    for (Socket socket in sockets) {
//      print(message);
//      print(socket.address);
//      socket.write(message);
//    }
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
//    print("Sending connect message to client.");
//    if (!sockets.contains(socket)) {
//      sockets.add(socket);
//    }
    socket.listen((Uint8List data) {
      var msg = json.decode(String.fromCharCodes(data));
      if (msg["type"]=="uniqueID") {
        print("GOT UNIQUE ID MESSAGE FROM client");
        sockets[msg["ID"]] = socket;
        print(msg["ID"]);
        print(socket);
        socketDataStreamController.add(json.encode({"type" : "newUserConnected", "uniqueID":msg["ID"]}));
      } else {
        this.onData(data);
      }
    });
<<<<<<< HEAD
    // Recieve something here before you send something back

    // ASKING FOR Pin
    socket.write(json.encode({"pin" : "what_is_pin"}));
    socketDataStreamController.add(json.encode({"pin" : "what_is_pin"}));
    print("Asking client for pin");
    if (!sockets.contains(socket)) {
      sockets.add(socket);
    }
    socket.listen((Uint8List data) {
      this.onData(data);
    });
=======
//
//    socket.drain().then((_) {
//      print('Player left');
//      socket.close();
//    });
>>>>>>> f1b758f38ab50472ebde967391b4cefb0d927c95
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