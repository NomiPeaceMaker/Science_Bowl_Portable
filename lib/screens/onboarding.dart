import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sciencebowlportable/screens/login.dart';
import 'package:sciencebowlportable/utilities/sizeConfig.dart';
import 'package:sciencebowlportable/main.dart';
import 'package:sciencebowlportable/utilities/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Code inspired by https://github.com/MarcusNg/flutter_onboarding_ui/blob/master/lib/screens/onboarding_screen.dart

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 2;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
 
  final titleStyle = TextStyle(
    color: Colors.black,
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

  // Returns list of _indicator widgets that is placed at the bottom of screen 
  // Determines active screen
  List<Widget> _buildPageIndicator() {
    print('initScreen $initScreen');
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  // Returns a single oval shape at the bottom of the screen. 
  // helper for _buildPageIndicator() method   
  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0, 
      width: isActive ? 24.0 : 16.0,    // if current screen is active then return an elongated oval
      decoration: BoxDecoration(
        color: isActive ? themeColor : Colors.grey[300],    // if current screen is active then color the oval orange else make it grey
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
            // Make background of page
              decoration: BoxDecoration(
                  color: themeColor,

                  // Background is orange and white in ratio 2 : 1 
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [themeColor, Colors.white],
                    stops: [0.66, 0.66],     
                  )),
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.safeBlockVertical * 5.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerRight,
                        child: FlatButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            initScreen = prefs.getInt("initScreen");
                            await prefs.setInt("initScreen", 1);
                            print('initScreen $initScreen');
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          },
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                      // Container that contains the swipeable onboarding objects
                      Container(
                        height: SizeConfig.safeBlockVertical * 80,
                        child: PageView(
                          physics: ClampingScrollPhysics(),
                          controller: _pageController,
                          onPageChanged: (int page) {
                            setState(() {
                              _currentPage = page;
                            });
                          },
                          // Each child is a screen
                          // Screen1 : Padding (...)
                          // Screen2 : Padding (...) and so on
                          children: <Widget>[
                            // Each screen contains text and image field
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: SizeConfig.safeBlockVertical * 3,
                                    horizontal:
                                        SizeConfig.safeBlockHorizontal * 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Center(
                                      child: Image(
                                        image: AssetImage(
                                            'assets/onboarding0.png'),
                                        height:
                                            SizeConfig.safeBlockVertical * 40,
                                        width:
                                            SizeConfig.safeBlockHorizontal * 60,
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            SizeConfig.safeBlockVertical * 3),
                                    Center(
                                      child: Text(
                                        'Play the science bowl\nanywhere from your phone!',
                                        style: subtitleStyle,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            SizeConfig.safeBlockVertical * 14),
                                    Center(
                                      child: Text(
                                        'Play Anywhere!',
                                        style: titleStyle,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                )),
                            // Padding(
                            //     padding: EdgeInsets.symmetric(
                            //         vertical: SizeConfig.safeBlockVertical * 3,
                            //         horizontal:
                            //             SizeConfig.safeBlockHorizontal * 5),
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: <Widget>[
                            //         Center(
                            //           child: Image(
                            //             image: AssetImage(
                            //                 'assets/onboarding1.png'),
                            //             height:
                            //                 SizeConfig.safeBlockVertical * 40,
                            //             width:
                            //                 SizeConfig.safeBlockHorizontal * 60,
                            //           ),
                            //         ),
                            //         SizedBox(
                            //             height:
                            //                 SizeConfig.safeBlockVertical * 3),
                            //         Center(
                            //           child: Text(
                            //             'SBP makes rich statistics to\nhelp you improve your game!',
                            //             style: subtitleStyle,
                            //             textAlign: TextAlign.center,
                            //           ),
                            //         ),
                            //         SizedBox(
                            //             height:
                            //                 SizeConfig.safeBlockVertical * 14),
                            //         Center(
                            //           child: Text(
                            //             'Improve Your Game!',
                            //             style: titleStyle,
                            //             textAlign: TextAlign.center,
                            //           ),
                            //         ),
                            //       ],
                            //     )),
                            Padding(
                                padding: EdgeInsets.all(40.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Center(
                                      child: Image(
                                        image: AssetImage(
                                            'assets/onboarding2.png'),
                                        height:
                                            SizeConfig.safeBlockVertical * 40,
                                        width:
                                            SizeConfig.safeBlockHorizontal * 60,
                                      ),
                                    ),

                                    SizedBox(
                                        height: SizeConfig.safeBlockVertical *
                                            2), // CHANGE THIS
                                    Center(
                                      child: ClipOval(
                                        child: RaisedButton(
                                          elevation: 10.0,
                                          shape: StadiumBorder(),
                                          child: Icon(
                                            Icons.play_arrow,
                                            size: 40.0,
                                            color: const Color(0xFFF8B400),
                                          ),
                                          color: Colors.white,
                                          padding: new EdgeInsets.all(30.0),
                                          onPressed: () async {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            initScreen =
                                                prefs.getInt("initScreen");
                                            await prefs.setInt("initScreen", 1);
                                            print('initScreen $initScreen');
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Login()),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            SizeConfig.safeBlockVertical * 3),
                                    Center(
                                      child: Text(
                                        'Lets get Started!',
                                        style: titleStyle,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildPageIndicator(),
                      ),
                    ],
                  )))),
    );
  }
}
