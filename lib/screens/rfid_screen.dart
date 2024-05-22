import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

class RfidScreen extends StatefulWidget {
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
