import 'package:flutter/material.dart';
import '../screens/screens.dart';

class Sidebar extends StatelessWidget {
  final String currentRoute;

  const Sidebar({Key? key, required this.currentRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Icon(
              Icons.api,
              color: Colors.white,
              size: 32,
            ),
          ),
          _buildNavItem(
            context,
            icon: Icons.home,
            tooltip: 'Home',
            isActive: currentRoute == '/home',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String tooltip,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: IconButton(
          icon: Icon(
            icon,
            color: isActive ? Colors.white : Colors.white70,
            size: 28,
          ),
          onPressed: onTap,
          style: isActive
              ? ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white24),
                )
              : null,
        ),
      ),
    );
  }
}