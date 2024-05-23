import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:smarthomelogin/screens/signin_screen.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool showProgress = false;
  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpassController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool _isObscure = true;
  bool _isObscure2 = true;
  String _nfcTagId = 'Scan a tag';
  File? file;
  var _currentItemSelected = "Member";
  var role = "Member";

  @override
  void initState() {
    super.initState();
    _startNfcSession();
  }

 void _startNfcSession() async {
  // Clear existing NFC session
  await NfcManager.instance.stopSession();

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
          _nfcTagId = tagId;
        });
      }

      NfcManager.instance.stopSession();
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(31, 64, 104, 1.000),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Color.fromRGBO(31, 64, 104, 1.000),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(12),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 80),
                        Text(
                          "Register",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 40,
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(height: 50),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Email',
                            enabled: true,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) {
                            if (value!.length == 0) {
                              return "Email cannot be empty";
                            }
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return ("Please enter a valid email");
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          obscureText: _isObscure,
                          controller: passwordController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                }),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 255, 255, 255),
                            hintText: 'Password',
                            enabled: true,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 15.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) {
                            RegExp regex = new RegExp(r'^.{6,}$');
                            if (value!.isEmpty) {
                              return "Password cannot be empty";
                            }
                            if (!regex.hasMatch(value)) {
                              return ("please enter valid password min. 6 character");
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          obscureText: _isObscure2,
                          controller: confirmpassController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure2
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _isObscure2 = !_isObscure2;
                                  });
                                }),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Confirm Password',
                            enabled: true,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 15.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) {
                            if (confirmpassController.text !=
                                passwordController.text) {
                              return "Password did not match";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: [
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              elevation: 5.0,
                              height: 40,
                              onPressed: () {
                                setState(() {
                                  showProgress = true;
                                });
                                signUp(emailController.text,
                                    passwordController.text, role);
                                registerUser(
                                  emailController.text,
                                  _nfcTagId
                                );
                                     
                              },
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              color: Colors.white,
                            ),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              elevation: 5.0,
                              height: 40,
                              onPressed: () {
                                CircularProgressIndicator();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                );
                              },
                              child: Text(
                                "I already have an account",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              color: Colors.white,
                            ),
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: _startNfcSession,
                                  child: Text('Start NFC Scan'),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "NFC Tag ID: $_nfcTagId",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
Future<void> registerUser(String email, String uid) async {
  final url = 'https://hsapi1234.azurewebsites.net/api/rfid/RegisterUser/$email/$uid';
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'Email': email,
      'Uid': uid,
    }),
  );

  if (response.statusCode == 201) {
    Map<String, dynamic> user = jsonDecode(response.body);
    print(user);
  } else {
    print('Failed to register user');
  }
}

void signUp(String email, String password, String role) async {
  if (_formkey.currentState!.validate()) {
    if (_nfcTagId == 'Scan a tag') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('NFC Tag Required'),
            content: Text('Please scan an NFC tag before registering.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore(email, role)})
          .catchError((e) {});
    }
  }
}

postDetailsToFirestore(String email, String role) async {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  var user = _auth.currentUser;
  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  ref.doc(user!.uid).set({
    'email': emailController.text,
    'role': role,
    'NFCid': _nfcTagId, // Add NFC tag ID here
  });
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
  );
}
}
