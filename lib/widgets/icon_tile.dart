import 'package:flutter/material.dart';

class IconTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const IconTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 30.0),
          Text(label, style: TextStyle(fontSize: 12))
        ],
      ),
    );
  }
}
