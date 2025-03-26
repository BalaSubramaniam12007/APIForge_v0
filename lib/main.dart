import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/core.dart';
import 'providers/providers.dart';
import 'ui/ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SpecProvider()),
      ],
      child: MaterialApp(
        title: 'ApiForge',
        theme: AppTheme.theme, 
        home: const HomeScreen(),
      ),
    );
  }
}