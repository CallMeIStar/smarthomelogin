import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
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

  @override
  void initState() {
    super.initState();
    _startNfcSession();
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
          String tagId = identifier.map((e) => e.toRadixString(16).padLeft(2, '0')).join().toUpperCase();
          setState(() {
            _nfcTagInfo = 'Tag Type: $tagType\nTag ID: $tagId';
          });

          // Verify NFC Tag ID with Firebase
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
    var userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .where('NFCid', isEqualTo: tagId)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      // NFC Tag is valid
                Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Access Granted')),
      );
    } else {
      // NFC Tag is invalid
                      Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Access Denied - Wrong RFID')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NFC Reader'),
      ),
      body: Center(
        child: Text(
          _nfcTagInfo,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

