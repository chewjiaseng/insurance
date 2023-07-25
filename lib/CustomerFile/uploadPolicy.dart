import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

// Enum to represent the status of each document.
enum DocumentStatus {
  pending,
  approved,
  rejected,
}

// Class to represent each uploaded document.
class Document {
  final String fileName;
  final String fileUrl;
  DocumentStatus status;

  Document(
      {required this.fileName,
      required this.fileUrl,
      this.status = DocumentStatus.pending});
}

class UploadPolicy extends StatefulWidget {
  @override
  State<UploadPolicy> createState() => _UploadPolicyState();
}

class _UploadPolicyState extends State<UploadPolicy> {
  final _firebaseStorage = FirebaseStorage.instance;
  String? _fileName; // Make it nullable
  String? _fileUrl; // Make it nullable
  DocumentStatus _documentStatus =
      DocumentStatus.pending; // Initial status is pending.

  @override
  void initState() {
    super.initState();

    // Get the current user's uid (You may want to retrieve it from FirebaseAuth if you have that implemented).
    _fileName = 'user_uid_here';
  }

  void _uploadDocument() async {
    // Get the image file from the user's device.
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null && result.files.isNotEmpty) {
      File imageFile = File(result.files.single.path!);

      // Upload the image file to Firebase Storage.
      Reference ref = _firebaseStorage.ref().child(_fileName!);
      UploadTask uploadTask = ref.putFile(imageFile);

      // Listen for the upload changes.
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress =
            (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        print('Upload progress: $progress %');
      });

      // Once the upload is complete, get the download URL and set the status to pending.
      uploadTask.whenComplete(() async {
        _fileUrl = await ref.getDownloadURL();

        // Update the UI with the download URL.
        setState(() {
          _fileUrl = _fileUrl;
          _documentStatus = DocumentStatus.pending;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Policy'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal,
              Colors.teal.shade200,
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Column(
            children: <Widget>[
              // Button to upload the image.
              ElevatedButton(
                child: Text('Upload Image'),
                onPressed: _uploadDocument,
              ),

              // If the file URL is available, display it.
              if (_fileUrl != null) Image.network(_fileUrl!),

              // Display the status of the document.
              Text('Document Status: ${getStatusText(_documentStatus)}'),
            ],
          ),
        ),
      ),
    );
  }

  String getStatusText(DocumentStatus status) {
    switch (status) {
      case DocumentStatus.pending:
        return 'Pending';
      case DocumentStatus.approved:
        return 'Approved';
      case DocumentStatus.rejected:
        return 'Rejected';
      default:
        return '';
    }
  }
}
