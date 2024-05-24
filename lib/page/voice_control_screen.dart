import 'package:flutter/material.dart';
import 'chatscreen.dart';
import 'speechrec.dart';

class SpeechMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text(
          '',
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontFamily: '', // Custom font
            fontWeight: FontWeight.bold, // Make it bold
            letterSpacing: 2.0, // Add some letter spacing
            shadows: [
              Shadow(
                blurRadius: 5.0,
                color: Colors.black,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor:
            Colors.transparent, // Set the background color to transparent
        elevation: 0, // Remove the elevation
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage("assets/image.png"), // Add your image asset here
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildMenuButton(
                  text: 'Astrid AI Menu',
                  icon: Icons.psychology, // Icon suited for an AI assistant
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatScreen()),
                    );
                  },
                ),
                const SizedBox(height: 80),
                _buildMenuButton(
                  text: 'Trigger Words Menu',
                  icon: Icons.mic, // Normal mic icon
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SpeechScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(
      {required String text,
      required IconData icon,
      required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 350,
        height: 200,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Color.fromARGB(127, 255, 255, 255),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: Color.fromARGB(255, 0, 22, 4),
                size: 60), // Use provided icon
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 195, 255, 189),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
