import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smarthomelogin/utils/user.dart';
import 'dart:convert';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse('https://hsapi1234.azurewebsites.net/api/rfid/GetAllUsers'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      setState(() {
        users = body.map((dynamic item) => User.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

Future<void> updateIsValidated(String email, String id, bool isValidated) async {
  final url = 'https://hsapi1234.azurewebsites.net/api/Rfid/validate/$email/$id?isValidated=$isValidated';
  final response = await http.put(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    print('Updated isValidated successfully');
  } else {
    print('Failed to update isValidated: ${response.body}');
  }
}

Future<void> updateIsStolen(String email, String id, bool isStolen) async {
  final url = 'https://hsapi1234.azurewebsites.net/api/Rfid/stolen/$email/$id?isStolen=$isStolen';
  final response = await http.put(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    print('Updated isStolen successfully');
  } else {
    print('Failed to update isStolen: ${response.body}');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Screen'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text(user.email),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('UID: ${user.uid}'),
                Row(
                  children: [
                    Text('Validated: '),
                    Switch(
                      value: user.isValidated,
                      onChanged: (value) {
                        setState(() {
                          user.isValidated = value;
                        });
                        updateIsValidated(user.email, user.id, value);
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Stolen: '),
                    Switch(
                      value: user.isStolen,
                      onChanged: (value) {
                        setState(() {
                          user.isStolen = value;
                        });
                        updateIsStolen(user.email, user.id, value);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
