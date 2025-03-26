import 'package:flutter/material.dart';
import '../screens/screens.dart';

class SpecHeader extends StatelessWidget {
  final String title;

  const SpecHeader({Key? key, required this.title}) : super(key: key);

  @override
Widget build(BuildContext context) {
  return Material(
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black54),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
          ),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    ),
  );
}
}