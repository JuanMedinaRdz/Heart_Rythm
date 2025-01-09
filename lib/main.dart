import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hearth_rythm/firebase_options.dart';
import 'package:hearth_rythm/src/core/services/firebase_service.dart';
import 'src/router/router.dart';
import 'package:timezone/data/latest.dart' as tz;

// Instancia global de notificaciones locales
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  // Inicializar notificaciones locales
  const AndroidInitializationSettings androidInitSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings = InitializationSettings(
    android: androidInitSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
  );

  // Inicializa Firebase
  await FirebaseService.initializeFirebase(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Suscribirte a topic 'allNotes' (o pedir token)
  await FirebaseMessaging.instance.subscribeToTopic("all_notes");
  // O, si quisieras el token para algo específico:
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // print('FCM token: $fcmToken');
final token = await FirebaseMessaging.instance.getToken();
print("FCM token: $token");
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  print("Nueva notificación en primer plano: ${message.notification?.title}");
  // Puedes mostrar un diálogo o una notificación local
});

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
