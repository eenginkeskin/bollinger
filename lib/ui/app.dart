import 'package:flutter/material.dart';
import 'package:bollinger/core/theme/app_theme.dart';
import 'package:bollinger/ui/screens/home_screen.dart';

class BollingerApp extends StatelessWidget {
  const BollingerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bollinger',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
