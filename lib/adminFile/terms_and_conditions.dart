import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';

class TermsAndConditionsPage extends StatefulWidget {
  @override
  _TermsAndConditionsPageState createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  File? _selectedFile;
  bool _isUploading = false;

  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('No file selected.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    String fileName = path.basename(_selectedFile!.path);
    firebase_storage.Reference storageRef = firebase_storage.FirebaseStorage.instance.ref().child(fileName);
    firebase_storage.UploadTask uploadTask = storageRef.putFile(_selectedFile!);

    await uploadTask.whenComplete(() {
      setState(() {
        _isUploading = false;
      });
    });

    String downloadURL = await storageRef.getDownloadURL();

    // Save the terms and conditions content to the Firebase database for the specific role
    String role = 'customer'; // You can get the role from the administrator's input
    FirebaseDatabase.instance.reference().child('termsAndConditions').child(role).set(downloadURL);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text('File uploaded successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Terms & Conditions'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/edituser.png'), // Replace with the path to your edituser.png image
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Text(
                'Please Upload Terms & Conditions',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromRGBO(46, 15, 147, 1)),
                textAlign: TextAlign.center,
              ),
              Text(
                'for Customers and Consultants',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF5969D3)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(223, 240, 255, 1), // Light blue color for the container
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: _selectFile,
                        child: Text('Select PDF File'),
                      ),
                      SizedBox(height: 16),
                      if (_selectedFile != null)
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFFBDD4FA), // White color for the selected file path text
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Selected File: ${_selectedFile!.path}',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black), // Black color for text
                          ),
                        ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _isUploading ? null : _uploadFile,
                        child: _isUploading
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(width: 8),
                                  Text('Uploading...'),
                                ],
                              )
                            : Text('Upload File'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
     ),
  );
 }
}