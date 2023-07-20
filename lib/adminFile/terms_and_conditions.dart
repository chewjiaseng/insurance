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
    FilePickerResult? result = await FilePicker.platform.pickFiles();

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
        title: Text('Upload Term & Condition'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _selectFile,
              child: Text('Select File'),
            ),
            SizedBox(height: 16),
            if (_selectedFile != null)
              Text('Selected File: ${_selectedFile!.path}'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadFile,
              child: _isUploading ? CircularProgressIndicator() : Text('Upload File'),
            ),
          ],
        ),
      ),
    );
  }
}
