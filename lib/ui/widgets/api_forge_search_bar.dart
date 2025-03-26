import 'package:flutter/material.dart';

class ApiForgeSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final Widget? suffixIcon;

  const ApiForgeSearchBar({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search endpoints (e.g., /pet or GET)',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: suffixIcon,
        ),
        onChanged: onChanged,
      ),
    );
  }
}