import 'package:flutter/material.dart';
import 'src/router/router.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'hearth_rythm',
      theme: ThemeData.dark(),
    );
  }
}
