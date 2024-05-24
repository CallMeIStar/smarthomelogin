import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:smarthomelogin/screens/signin_screen.dart';
import 'package:smarthomelogin/utils/homeuser.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<homeuser> users = [];
  Map<String, List<homeuser>> emailGroups = {};
  Map<String, List<homeuser>> uidGroups = {};

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response = await http.get(
        Uri.parse('https://hsapi1234.azurewebsites.net/api/rfid/GetAllUsers'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      setState(() {
        users = body.map((dynamic item) => homeuser.fromJson(item)).toList();
        groupUsers();
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  void groupUsers() {
    emailGroups = {};
    uidGroups = {};
    for (var user in users) {
      if (!emailGroups.containsKey(user.email)) {
        emailGroups[user.email] = [];
      }
      emailGroups[user.email]!.add(user);

      if (!uidGroups.containsKey(user.uid)) {
        uidGroups[user.uid] = [];
      }
      uidGroups[user.uid]!.add(user);
    }
  }

  Future<void> updateIsValidated(String email, bool isValidated) async {
    for (var user in emailGroups[email]!) {
      final url =
          'https://hsapi1234.azurewebsites.net/api/Rfid/validate/${user.email}/${user.id}?isValidated=$isValidated';
      final response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Updated isValidated successfully for ${user.id}');
      } else {
        print('Failed to update isValidated for ${user.id}: ${response.body}');
      }
    }
  }

  Future<void> updateIsStolen(String uid, bool isStolen) async {
    for (var user in uidGroups[uid]!) {
      final url =
          'https://hsapi1234.azurewebsites.net/api/Rfid/stolen/${user.email}/${user.id}?isStolen=$isStolen';
      final response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Updated isStolen successfully for ${user.id}');
      } else {
        print('Failed to update isStolen for ${user.id}: ${response.body}');
      }
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Center(
          child: Text(
            'Admin Screen',
            style: TextStyle(fontSize: 24, color: Colors.white), // Increased font size
          ),
        ),              
        backgroundColor: const Color.fromARGB(0, 33, 149, 243),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/deliciosa.png'), // Path to your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
            child: ListView(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: emailGroups.keys.map((email) {
                          bool isValidated = emailGroups[email]!
                              .every((user) => user.isValidated);
                          String uidList = emailGroups[email]!
                              .map((user) => user.uid)
                              .join(', ');
                          return ListTile(
                            title: Text(
                              email,
                              style: TextStyle(
                                  color: Colors
                                      .white), // Text color white for better visibility
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'UIDs: $uidList',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Row(
                                  children: [
                                    Text('Validated: ',
                                        style: TextStyle(color: Colors.white)),
                                    Switch(
                                      value: isValidated,
                                      onChanged: (value) {
                                        setState(() {
                                          for (var user
                                              in emailGroups[email]!) {
                                            user.isValidated = value;
                                          }
                                        });
                                        updateIsValidated(email, value);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: uidGroups.keys.map((uid) {
                          bool isStolen =
                              uidGroups[uid]!.every((user) => user.isStolen);
                          return ListTile(
                            title: Text(
                              'UID: $uid',
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Row(
                              children: [
                                Text('Stolen: ',
                                    style: TextStyle(color: Colors.white)),
                                Switch(
                                  value: isStolen,
                                  onChanged: (value) {
                                    setState(() {
                                      for (var user in uidGroups[uid]!) {
                                        user.isStolen = value;
                                      }
                                    });
                                    updateIsStolen(uid, value);
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
