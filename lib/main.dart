import 'package:flutter/material.dart';
import 'package:sciencebowlportable/screens/home.dart';
import 'package:sciencebowlportable/screens/onboarding.dart';
import 'package:sciencebowlportable/screens/result.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}


class _MyApp extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => MyHomePage(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/home': (context) => MyHomePage(),
        },
        // home: OnboardingScreen(),
          // home: Result()
    );
  }
}


// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         appBarTheme: AppBarTheme(
//           color: Color.fromARGB(200, 255, 255, 255),

//       ),
//         brightness: Brightness.light,
//         primaryColor: Color(0xFFF8B400),
//         accentColor: Colors.cyan[600],
//         primarySwatch: Colors.lightGreen,
//         fontFamily: 'Georgia',
//       ),
//       home: MyHomePage(title: 'Science Bowl Portable!'),
//     );
//   }
// }