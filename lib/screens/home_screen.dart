import 'package:flutter/material.dart';
import 'stream_screen.dart';
import 'control_screen.dart';
import 'data_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2; // Set initial index to "Home" in the middle

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueGrey[50], // Match background color with login screen
        child: IndexedStack(
          index: _selectedIndex,
          children: const [
            StreamScreen(),
            ControlScreen(),
            HomePage(),
            DataScreen(),
            ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.stream),
            label: 'Stream',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sensors),
            label: 'Control',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.data_usage),
            label: 'Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal[700],
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.blueGrey[50], // Same color as the background
        onTap: _onItemTapped,
        elevation: 0, // Remove shadow for a flat look
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          const Text(
            'Welcome to Smart Home!',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Step into the future with Smart Home—a complete IoT-based system designed to make your living space smarter, safer, and more efficient. '
            'Our platform integrates advanced technology, including an ESP32 camera module for real-time video streaming, and state-of-the-art sensors '
            'like DHT11 (for temperature and humidity), MQ5 (for gas detection), and PIR (for motion detection).',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'The system allows you to monitor your environment in real-time through a user-friendly interface. You’ll receive instant notifications in case of any anomalies, '
            'and you can even control actuators remotely, ensuring your home is always under your control.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Future enhancements include integrating AI to analyze video streams, enabling predictive analytics and advanced automation. '
            'Smart Home is not just a project; it’s a step towards redefining modern living!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
