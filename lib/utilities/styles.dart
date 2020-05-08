//This document contains all styles that appear or might appear in more than one occasion in the application

import 'package:flutter/material.dart';

// Standard color to indicate action disabled (light Grey)
final disableColor = Colors.grey[400];

// Primary color (Orange) of the application
final themeColor = Color(0xFFF8B400);

// Style for appbars in the application
final appBarStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'Roboto',
);

// Used on text in dialog boxes when CONFIRMING a high-stakes action 
// instance include going back to home from moderator screen
final exitstyle = TextStyle(
  color: Colors.red,
  fontSize: 16.0,
);

// Used on text in dialog boxes when REVERTING a high-stakes action 
// instance include NOT going back to home
final staystyle = TextStyle(
  color: Colors.grey[700],
  fontSize: 16.0,
);

// Login button style in login.dart
final loginButtonText = TextStyle(
  color: Colors.white,
  fontSize: 21.0,
);