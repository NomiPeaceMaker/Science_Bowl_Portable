import 'package:flutter/material.dart';
import 'package:science_bowl_portable/screens/onboarding.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
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


