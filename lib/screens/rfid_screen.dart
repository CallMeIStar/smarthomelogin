import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nfc_manager/nfc_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:smarthomelogin/screens/home_screen.dart';
import 'package:smarthomelogin/screens/signin_screen.dart';

class RfidScreen extends StatefulWidget {
  final String email;

  RfidScreen({required this.email});

  @override
  _RfidScreenState createState() => _RfidScreenState();
}

class _RfidScreenState extends State<RfidScreen> {
  String _nfcTagInfo = 'Scan a tag';
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _startNfcSession();
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

  void _startNfcSession() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (isAvailable) {
      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        List<int>? identifier;
        String tagType = 'Unknown tag type';

        var nfcA = NfcA.from(tag);
        var nfcB = NfcB.from(tag);
        var nfcF = NfcF.from(tag);
        var nfcV = NfcV.from(tag);
        var isoDep = IsoDep.from(tag);
        var mifareClassic = MifareClassic.from(tag);
        var mifareUltralight = MifareUltralight.from(tag);
        var ndef = Ndef.from(tag);

        if (nfcA != null) {
          identifier = nfcA.identifier;
          tagType = 'NFC Type A';
        } else if (nfcB != null) {
          identifier = nfcB.identifier;
          tagType = 'NFC Type B';
        } else if (nfcF != null) {
          identifier = nfcF.identifier;
          tagType = 'NFC Type F';
        } else if (nfcV != null) {
          identifier = nfcV.identifier;
          tagType = 'NFC Type V';
        } else if (isoDep != null) {
          identifier = isoDep.identifier;
          tagType = 'ISO-DEP';
        } else if (mifareClassic != null) {
          identifier = mifareClassic.identifier;
          tagType = 'MIFARE Classic';
        } else if (mifareUltralight != null) {
          identifier = mifareUltralight.identifier;
          tagType = 'MIFARE Ultralight';
        }

        if (identifier != null) {
          String tagId = identifier
              .map((e) => e.toRadixString(16).padLeft(2, '0'))
              .join()
              .toUpperCase();
          setState(() {
            _nfcTagInfo = 'Tag Type: $tagType\nTag ID: $tagId';
          });

          // Verify NFC Tag ID with API
          _verifyNfcTag(widget.email, tagId);
        } else {
          setState(() {
            _nfcTagInfo = 'Unknown tag type';
          });
        }

        NfcManager.instance.stopSession();
      });
    } else {
      setState(() {
        _nfcTagInfo = 'NFC is not available';
      });
    }
  }

  void _verifyNfcTag(String email, String tagId) async {
    final response = await http.get(
        Uri.parse('https://hsapi1234.azurewebsites.net/api/rfid/GetAllUsers'));

    if (response.statusCode == 200) {
      List<dynamic> users = json.decode(response.body);

      var user = users.firstWhere(
          (user) => user['uid'] == tagId && user['email'] == email,
          orElse: () => null);

      if (user != null) {
        if (user['isStolen'] == true) {
          // RFID is stolen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Access Denied - RFID Stolen')),
          );
          _postLoginAttempt(DateTime.now(), 'Stolen', email);
        } else {
          // RFID is valid
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Access Granted')),
          );
          _postLoginAttempt(DateTime.now(), 'Success', email);
        }
      } else {
        // RFID is invalid
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Access Denied - Wrong RFID or Email')),
        );
        _postLoginAttempt(DateTime.now(), 'Failed', email);
      }
    } else {
// Error fetching users
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error verifying RFID')),
      );
      _postLoginAttempt(DateTime.now(), 'Failed', email);
    }
  }

  void _postLoginAttempt(DateTime timestamp, String success, String email) {
    FirebaseFirestore.instance.collection('info').add({
      'timestamp': timestamp,
      'success': success,
      'email': email,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage("assets/monstera.png"), // Add your image asset here
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            _nfcTagInfo,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
