import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_app/view/on_boarding/started_view.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/view/login/complete_profile_view.dart';
import 'package:fitness_app/view/login/login_view.dart';
import 'package:fitness_app/view/login/welcome_view.dart';
import 'package:fitness_app/view/on_boarding/on_boarding_view.dart';
import 'package:fitness_app/view/on_boarding/started_view.dart';
import 'common/colo_extension.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter is initialized before Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness 3 in 1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: TColor.primaryColor1,
        fontFamily: "Poppins",
      ),
      home: const StartedView(), // You can change this to a splash screen if needed
    );
  }
}
