import 'package:flutter/material.dart';
import 'package:haru_to_moji_no_sekai/app/theme/app_theme.dart';
import 'package:haru_to_moji_no_sekai/features/home/presentation/home_screen.dart';

class HaruToMojiApp extends StatelessWidget {
  const HaruToMojiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Haru to Moji no Sekai',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomeScreen(),
    );
  }
}
