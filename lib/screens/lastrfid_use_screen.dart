import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginAttempt {
  final DateTime timestamp;
  final String success;
  final String email;

  LoginAttempt({required this.timestamp, required this.success, required this.email});

  factory LoginAttempt.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return LoginAttempt(
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      success: data['success'],
      email: data['email'],
    );
  }
}


class LoginAttemptsScreen extends StatefulWidget {
  @override
  _LoginAttemptsScreenState createState() => _LoginAttemptsScreenState();
}

class _LoginAttemptsScreenState extends State<LoginAttemptsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<LoginAttempt>> _getLoginAttempts() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('info')
        .orderBy('timestamp', descending: true)
        .get();

    return querySnapshot.docs.map((doc) => LoginAttempt.fromFirestore(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Attempts'),
      ),
      body: FutureBuilder<List<LoginAttempt>>(
        future: _getLoginAttempts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No login attempts found'));
          } else {
            List<LoginAttempt> attempts = snapshot.data!;
            return ListView.builder(
              itemCount: attempts.length,
              itemBuilder: (context, index) {
                LoginAttempt attempt = attempts[index];
                String formattedTimestamp = (attempt.timestamp.toString());
                return ListTile(
                  title: Text(formattedTimestamp),
                  subtitle: Text('${attempt.success} - ${attempt.email}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
