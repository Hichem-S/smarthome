import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataScreen extends StatelessWidget {
  const DataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Sensor Data',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Welcome to the Data Screen. Here, you can view real-time information collected from your connected sensors. '
                  'This includes temperature, humidity, and motion detection.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('SmartHomeSensors')
                      .doc('SensorData')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const Text(
                        'No sensor data available.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                        ),
                      );
                    }

                    final data = snapshot.data!.data() as Map<String, dynamic>;

                    // Safely extract data
                    final double temperature =
                        (data['temperature'] ?? 0).toDouble();
                    final int humidity = (data['humidity'] ?? 0).toInt();
                    final int motion = (data['motion'] ?? 0).toInt();

                    // Convert motion to a human-readable format
                    final String motionStatus =
                        motion == 1 ? "Yes" : "No";

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          'Temperature: $temperature°C',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Humidity: $humidity%',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Motion Detected: $motionStatus',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


