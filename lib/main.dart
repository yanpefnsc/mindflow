import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/task.dart';
import 'models/observation.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Registra os adapters
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(ObservationAdapter());

  // Abre as caixas (banco local)
  await Hive.openBox<Task>('tasks');
  await Hive.openBox<Observation>('observations');

  runApp(const MindFlowApp());
}

class MindFlowApp extends StatelessWidget {
  const MindFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData.dark(),
      home: const SplashScreen(
        nextScreen: WelcomeScreen(),
      ),
    );
  }
}