import 'package:flutter/material.dart';
import 'package:hearth_rythm/firebase_options.dart';
import 'package:hearth_rythm/src/core/services/firebase_service.dart';
import 'src/router/router.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initializeFirebase(
    options: DefaultFirebaseOptions.currentPlatform
  ); //Inicializa Firebase 
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
