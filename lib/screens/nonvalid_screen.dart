import 'package:flutter/material.dart';
import 'package:smarthomelogin/screens/signin_screen.dart';

class NonValidScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/image.png', // Replace with your image asset path
              fit: BoxFit.cover,
            ),
          ),
          // Black overlay with 0.5 opacity
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          // Content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Your email is not validated. Please contact the Adminstrator.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                IconButton(
                  icon: Icon(Icons.logout, color: Colors.black),
                  onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(127, 255, 255, 255)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
