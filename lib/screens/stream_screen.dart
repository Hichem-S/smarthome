import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StreamScreen extends StatelessWidget {
  const StreamScreen({super.key});

  // Function to launch the browser with the ESP32-CAM stream URL
  void _openCameraStream() async {
    const String url =
        'http://192.168.156.205/'; // Replace with your ESP32-CAM stream URL
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Log or handle the error
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Smart Home Live Feed',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Monitor your home in real-time with a live video feed directly from your ESP32-CAM. Stay updated and secure no matter where you are.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _openCameraStream, // Launch the browser when pressed
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                icon: const Icon(Icons.videocam),
                label: const Text('Open Camera Stream'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
