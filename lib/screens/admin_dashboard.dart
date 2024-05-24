import 'package:flutter/material.dart';
import 'package:smarthomelogin/screens/signin_screen.dart';
import 'admin_screen.dart'; // Make sure to create this file
import 'lastrfid_use_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image.png'), // Add your background image in assets
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 255, 255, 255), backgroundColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                    textStyle: TextStyle(color: Colors.black),
                  ),
                  child: Text('Go to Admin Screen', style: TextStyle(color: Colors.black)),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginAttemptsScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 255, 255, 255), backgroundColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                    textStyle: TextStyle(color: Colors.black),
                  ),
                  child: Text('Go to Login Attempts Screen', style: TextStyle(color: Colors.black)),
                ),
                SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 255, 255, 255), backgroundColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                    textStyle: TextStyle(color: Colors.black),
                  ),
                  child: Text('Log out', style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}