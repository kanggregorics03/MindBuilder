import 'package:flutter/material.dart';

import 'features/recommend/ui/akinator_style_screen.dart';

class MindBuilderApp extends StatelessWidget {
  const MindBuilderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mind Builder',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF126E82)),
      ),
      home: const AkinatorStyleScreen(),
    );
  }
}
