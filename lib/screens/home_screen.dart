import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smarthomelogin/page/energy_info_screen.dart';
import 'package:smarthomelogin/page/luminosity_control_screen.dart';
import 'package:smarthomelogin/page/security_settings_screen.dart';
import 'package:smarthomelogin/page/telemetry_info_screen.dart';
import 'package:smarthomelogin/page/voice_control_screen.dart';
import 'package:smarthomelogin/screens/signin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Home Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TelemetryInfoScreen()),
                );
              },
              child: Text('Telemetry Info'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecuritySettingsScreen()),
                );
              },
              child: Text('Security Settings'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VoiceControlScreen()),
                );
              },
              child: Text('Voice Control'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EnergyInfoScreen()),
                );
              },
              child: Text('Energy Info'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LuminosityControlScreen()),
                );
              },
              child: Text('Luminosity Control'),
            ),
            Spacer(),
            ElevatedButton(
              child: Text("Logout"),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  print("Signed Out");
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignInScreen()));
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}