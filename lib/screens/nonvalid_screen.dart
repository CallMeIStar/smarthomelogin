import 'package:flutter/material.dart';

class NonValidScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email Not Validated'),
      ),
      body: Center(
        child: Text(
          'Your email is not validated. Please contact support.',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
