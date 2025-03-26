import 'package:flutter/material.dart';

class NoSpecLoadedScreen extends StatelessWidget {
  const NoSpecLoadedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('No specification loaded'),
      ),
    );
  }
}