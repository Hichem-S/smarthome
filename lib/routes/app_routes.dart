import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/stream_screen.dart';
import '../screens/control_screen.dart';
import '../screens/data_screen.dart';
import '../screens/profile_screen.dart'; // Import the profile screen

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String stream = '/stream';
  static const String control = '/control';
  static const String data = '/data';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => LoginScreen(),
      register: (context) => RegisterScreen(),
      home: (context) => HomeScreen(),
      stream: (context) => StreamScreen(),
      control: (context) => ControlScreen(),
      data: (context) => DataScreen(),
      profile: (context) =>
          ProfileScreen(), // Correct reference to ProfileScreen
    };
  }
}
