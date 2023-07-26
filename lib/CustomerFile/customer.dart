import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'PointAndReward.dart';
import 'BoosterPackagesPage.dart';
import 'uploadPolicy.dart';
import '../login.dart'; // Replace this with the path to your login page if necessary
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:insuranceapp/ConsultantFile/ShareAppsPage.dart';

class Customer extends StatefulWidget {
  const Customer({Key? key});

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  String? _userName;
  String? _profileImageUrl; // Nullable variable for profile image URL

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _showTermsAndConditionsDialog();
  }

  void _showTermsAndConditionsDialog() async {
    print("Entering _showTermsAndConditionsDialog()");

    String role = 'customer';
    final snapshot = await FirebaseFirestore.instance
        .collection('termsAndConditions')
        .doc(role)
        .get();
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
                height: MediaQuery.of(context).size.height *
                    0.8, // Set the height as per your requirement
                width: MediaQuery.of(context).size.width *
                    0.8, // Set the width as per your requirement
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
      String fileName = 'Customer_Term_Condition.pdf'; // Adjust filename here
      File pdfFile = File('$appDocPath/$fileName');

      bool fileExists = await pdfFile.exists();
      if (!fileExists) {
        // Download the PDF if it doesn't exist in the app directory
        final pdfData = await firebase_storage.FirebaseStorage.instance
            .refFromURL(downloadURL)
            .getData();
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

  Future<void> _fetchUserData() async {
    try {
      // Get the current user ID from FirebaseAuth
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch the user document from Firestore using the user ID
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          // Get the user's real name from the document data
          setState(() {
            _userName = userDoc['name'];

            // Check if the 'profileImageUrl' field exists in the document and has a valid value
            if (userDoc.data()!.containsKey('profileImageUrl') &&
                userDoc['profileImageUrl'] != null &&
                userDoc['profileImageUrl'].toString().isNotEmpty) {
              _profileImageUrl = userDoc['profileImageUrl'];
            } else {
              // If the 'profileImageUrl' field is empty or doesn't exist, set the variable to null
              _profileImageUrl = null;
            }
          });
        }
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  // Load profile image based on the URL's prefix
  Widget _loadProfileImage() {
    if (_profileImageUrl != null && _profileImageUrl!.startsWith('http')) {
      return Image.network(
        _profileImageUrl!,
        width: 500,
        height: 200,
        fit: BoxFit.cover,
      );
    } else {
      // If _profileImageUrl is null or the URL is not valid, return an empty container
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/customerbg.png', // Background image path
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_profileImageUrl !=
                        null) // Only show the banner if _profileImageUrl is not null
                      Container(
                        width: 500,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent,
                          // Add a transparent color when no profile image is available
                        ),
                        child: _loadProfileImage(),
                      ),
                    CircleAvatar(
                      // Display profile picture here if available
                      // Replace this with the actual profile picture
                      radius: 50,
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  _userName ?? 'Unknown User',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to the ShareAppsPage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShareAppsPage(),
                              ),
                            );
                          },
                          icon: Icon(Icons.person_add, color: Colors.black),
                          label: Text('Invite Friends',
                              style: TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(160, 60),
                            primary: Color(0xF5F6F0F0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to the upload policy page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UploadPolicy(),
                              ),
                            );
                          },
                          icon: Icon(Icons.upload_file, color: Colors.black),
                          label: Text('Upload Policy',
                              style: TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(160, 60),
                            primary: Color(0xF5F6F0F0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to the booster package page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BoosterPackagesPage(),
                              ),
                            );
                          },
                          icon: Icon(Icons.shopping_bag, color: Colors.black),
                          label: Text('Booster Package',
                              style: TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(160, 60),
                            primary: Color(0xF5F6F0F0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to the Point and reward page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PointAndRewardPage(),
                              ),
                            );
                          },
                          icon: Icon(Icons.star, color: Colors.black),
                          label: Text('Point & Reward',
                              style: TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(160, 60),
                            primary: Color(0xF5F6F0F0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
