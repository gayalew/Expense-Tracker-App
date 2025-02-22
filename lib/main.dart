import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spendwise/app_view.dart';
import 'package:spendwise/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyAppView(),
    );
  }
}
