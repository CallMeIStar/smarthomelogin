import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smarthomelogin/screens/signin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: FirebaseOptions(
    apiKey: 'AIzaSyAhmmosySvY8aEGn6o1FXP39GHdCZtgy4g',
    appId: '1:487547264893:android:5a1bc8c6ae4613618d7614',
    messagingSenderId: '487547264893',
    projectId: 'smarthomelogin-hands',
  )
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Home',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignInScreen(),
    );
  }
}