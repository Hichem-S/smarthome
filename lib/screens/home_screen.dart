import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Accueil'), backgroundColor: Colors.grey[850]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bienvenue sur l\'application Smart Home !'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.stream),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
              child: Text('Accéder au stream'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.control),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
              child: Text('Contrôler les capteurs'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.data),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
              child: Text('Voir les données des capteurs'),
            ),
          ],
        ),
      ),
    );
  }
}
