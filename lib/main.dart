import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const TeslaConnectorApp());
}

class TeslaConnectorApp extends StatelessWidget {
  const TeslaConnectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tesla Connector',
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}