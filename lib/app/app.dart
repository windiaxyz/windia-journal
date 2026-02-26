import 'package:flutter/material.dart';

import '../features/common/main_shell.dart';

class AuraPalApp extends StatelessWidget {
  const AuraPalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AuraPal',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const MainShell(),
    );
  }
}
