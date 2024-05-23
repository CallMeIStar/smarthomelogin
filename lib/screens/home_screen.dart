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
  String? userEmail;

  @override
  void initState() {
    super.initState();
    fetchUserEmail();
  }

  void fetchUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF0685AA), // Button background color
      padding: EdgeInsets.symmetric(vertical: 16.0),
      textStyle: TextStyle(fontSize: 16.0, color: Color(0xFFF2F8FF)), // Text color
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Home Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (userEmail != null) ...[
              Text(
                'Logged in as: $userEmail',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
            ],
            ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TelemetryInfoScreen()),
                );
              },
              child: Text('Telemetry Info', style: TextStyle(color: Color(0xFFF2F8FF)),),
            ),
            SizedBox(height: 16.0), // Space between buttons
            ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecuritySettingsScreen()),
                );
              },
              child: Text('Security Settings', style: TextStyle(color: Color(0xFFF2F8FF)),),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SpeechMenu()),
                );
              },
              child: Text('Voice Control', style: TextStyle(color: Color(0xFFF2F8FF)),),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EnergyInfoScreen()),
                );
              },
              child: Text('Energy Info', style: TextStyle(color: Color(0xFFF2F8FF)),),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LuminosityControlScreen()),
                );
              },
              child: Text('Luminosity Control', style: TextStyle(color: Color(0xFFF2F8FF)),),
            ),
            Spacer(),
            ElevatedButton(
              style: buttonStyle,
              child: Text("Logout", style: TextStyle(color: Color(0xFFF2F8FF)),),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  print("Signed Out");
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
