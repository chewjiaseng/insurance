import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

import '../login.dart';
import 'ShareAppsPage.dart';
import 'ViewCustomersPage.dart';
import 'ViewAvailableBoosterPackage.dart';
import 'ViewCustomerRewardPointsPage.dart';

class Agent extends StatefulWidget {
  const Agent({Key? key});

  @override
  State<Agent> createState() => _AgentState();
}

class _AgentState extends State<Agent> {
  String _consultantName = '';

  @override
  void initState() {
    super.initState();
    _getConsultantName();
    _showTermsAndConditionsDialog();
  }

   Future<void> _getConsultantName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var snapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        _consultantName = snapshot.get('name');
      });
    }
  }

  void _showTermsAndConditionsDialog() async {
    String role = 'agent';
    final snapshot = await FirebaseFirestore.instance.collection('termsAndConditions').doc(role).get();
    String downloadURL = snapshot['url'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hello, Please Read'),
        content: FutureBuilder<String>(
          future: _downloadAndSavePDF(downloadURL),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || snapshot.data == null) {
              return Text('Error downloading PDF');
            } else {
              return Container(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width * 0.8,
                child: PDFView(
                  filePath: snapshot.data!,
                ),
              );
            }
          },
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Agree and do not show again'),
          ),
        ],
      ),
    );
  }

  Future<String> _downloadAndSavePDF(String downloadURL) async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String fileName = 'Consultant_Term_Condition.pdf';
      File pdfFile = File('$appDocPath/$fileName');

      bool fileExists = await pdfFile.exists();
      if (!fileExists) {
        final pdfData = await firebase_storage.FirebaseStorage.instance.refFromURL(downloadURL).getData();
        if (pdfData != null) {
          await pdfFile.writeAsBytes(pdfData.buffer.asUint8List());
        } else {
          print('Failed to download PDF data');
          return '';
        }
      }

      return pdfFile.path;
    } catch (error) {
      print('Error downloading PDF: $error');
      return '';
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Consultant"),
      actions: [
        IconButton(
          onPressed: () {
            logout(context);
          },
          icon: Icon(Icons.logout),
        )
      ],
    ),
    body: Stack(
      children: [
        Image.asset(
          'assets/images/consultantbg.png',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
        Align(
          alignment: Alignment.center, // Center the content vertically
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/consultant.jpg'),
                ),
                SizedBox(height: 10),
                Text(
                  _consultantName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20), // Adjust spacing between avatar and buttons
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    children: [
                      _buildGridItem(Icons.person, 'View Customers', ViewCustomersPage(roleToRetrieve: 'customer')),
                      _buildGridItem(Icons.policy, 'View Available Booster Package', ViewAvailableBoosterPackage()),
                      _buildGridItem(Icons.shopping_bag, 'View Reward Point', ViewCustomerRewardPointsPage(roleToRetrieve: 'customer')),
                      _buildGridItem(Icons.email, 'Share Apps', ShareAppsPage()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

  
  Widget _buildGridItem(IconData iconData, String title, Widget destination) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
      },
      icon: Icon(iconData, color: Colors.black),
      label: Text(title, style: TextStyle(color: Colors.black)),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(160, 60),
        primary: Color(0xF5F6F0F0),
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}
