import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'splash_screen.dart';

void main() {
  runApp(WTMSApp());
}

class WTMSApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WTMS',
      theme: ThemeData(primarySwatch: Colors.teal),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // Default screen
      routes: {
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}
