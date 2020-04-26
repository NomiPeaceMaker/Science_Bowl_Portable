import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sciencebowlportable/screens/login.dart';

// Code inspired by https://github.com/MarcusNg/flutter_onboarding_ui/blob/master/lib/screens/onboarding_screen.dart

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final titleStyle = TextStyle(
    color : Colors.black,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
    fontSize: 24.0,
    height: 1.5,
     
  );

  final subtitleStyle = TextStyle(
    color: Colors.white,
    fontSize: 18.0,
    height: 1.2,
  );

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Color(0xFFF8B400) : Colors.grey[300],
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8B400),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF8B400), Colors.white],
              stops: [0.66,0.66],
            )
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                
                Container(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () =>
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    ),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 560,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/onboarding0.png'
                                ),
                                height: 250,
                                width: 250,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Center(
                              child: Text(
                                'Play the science bowl\nanywhere from your phone!',
                                style: subtitleStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 109.0),
                            Center(
                              child: Text(
                                'Play Anywhere!',
                                style: titleStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),

                          ],
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/onboarding1.png'
                                ),
                                height: 250,
                                width: 250,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Center(
                              child: Text(
                                'SBP makes rich statistics to\nhelp you improve your game!',
                                style: subtitleStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 109.0),
                            Center(
                              child: Text(
                                'Improve Your Game!',
                                style: titleStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),

                          ],
                        )
                      ),
                       Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/onboarding2.png'
                                ),
                                height: 250,
                                width: 250,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Center(
                              child: Text(
                                'Play the science bowl\nanywhere from your phone!',
                                style: subtitleStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 109.0),
                            Center(
                              child: Text(
                                'Lets Get Started!',
                                style: titleStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
              ],
            )
          )
        )
      ),
    );
  }
}