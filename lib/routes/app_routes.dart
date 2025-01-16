import 'package:flutter/material.dart';
import 'package:smart_home/screens/AddClientPage.dart';
import 'package:smart_home/screens/ViewClientsPage.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/stream_screen.dart';
import '../screens/control_screen.dart';
import '../screens/data_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/update_profile_screen.dart';
import '../screens/admin_dashboard.dart';
import '../screens/AddClientPage.dart';
import '../screens/ViewClientsPage.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String stream = '/stream';
  static const String control = '/control';
  static const String data = '/data';
  static const String profile = '/profile';
  static const String updateProfile = '/update-profile';
  static const String adminDashboard = '/adminDashboard';
  static const String addclient = '/addclient';
  static const String viewclient = '/viewclient';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => LoginScreen(),
      register: (context) => RegisterScreen(),
      home: (context) => const HomeScreen(),
      stream: (context) => const StreamScreen(),
      control: (context) => const ControlScreen(),
      data: (context) => const DataScreen(),
      profile: (context) => const ProfileScreen(),
      updateProfile: (context) => const UpdateProfileScreen(),
      adminDashboard: (context) => const AdminDashboard(),
      addclient: (context) => AddClientPage(),
      viewclient: (context) => const ViewClientsPage(),
    };
  }
}
