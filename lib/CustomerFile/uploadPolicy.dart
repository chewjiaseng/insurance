import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class UploadPolicy extends StatefulWidget {
  @override
  State<UploadPolicy> createState() => _UploadPolicyState();
}

class _UploadPolicyState extends State<UploadPolicy> {
  final _firebaseStorage = FirebaseStorage.instance;
  late String _fileName;
  String? _fileUrl;

  @override
  void initState() {
    super.initState();

    // Get the current user's uid.
    _fileName = FirebaseAuth.instance.currentUser!.uid;
  }

  void _uploadDocument() async {
    // Get the image file from the user's device.
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;

      // Upload the file to Firebase Storage.
      Reference ref = _firebaseStorage.ref().child(_fileName);
      UploadTask uploadTask = ref.putFile(File(file.path!));

      // Listen for the upload progress.
      uploadTask.snapshotEvents.listen((snapshot) {
        print(
            'Upload progress: ${snapshot.bytesTransferred}/${snapshot.totalBytes}');
      });

      // Once the upload is complete, get the download URL.
      try {
        TaskSnapshot taskSnapshot = await uploadTask;
        _fileUrl = await taskSnapshot.ref.getDownloadURL();

        // Update the UI with the download URL.
        setState(() {
          _fileUrl = _fileUrl;
        });

        // Show a successful uploaded message.
        _showSuccessMessage();
      } catch (e) {
        print('Error uploading document: $e');
      }
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Document uploaded successfully!')),
    );
  }
  
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Policy'),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/customerbg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Title
                Text(
                  'Please upload your policy document',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(13, 93, 32, 1),
                  ),
                ),
                SizedBox(height: 20),
                // Button to upload the document.
                ElevatedButton(
                  onPressed: _uploadDocument,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // Set the button color to green.
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                  ),
                  child: Text(
                    'Upload Policy',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DocumentReviewScreen extends StatefulWidget {
  @override
  State<DocumentReviewScreen> createState() => _DocumentReviewScreenState();
}

class _DocumentReviewScreenState extends State<DocumentReviewScreen> {
  List<Document> documents = [];

  @override
  void initState() {
    super.initState();

    // Get the list of documents from Firebase Storage.
    _getDocuments();
  }

  void _getDocuments() async {
    // Get the list of documents from Firestore.
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('documents').get();

    // Add the documents to the list.
    setState(() {
      documents = querySnapshot.docs
          .map((doc) => Document.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Review'),
      ),
      body: ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          Document document = documents[index];
          return ListTile(
            title: Text(document.fileName),
            subtitle: Text(document.fileUrl),
            onTap: () {
              // Show a dialog to approve or reject the document.
              _showDialog(document);
            },
          );
        },
      ),
    );
  }

  void _showDialog(Document document) {
    // Create a dialog.
    AlertDialog dialog = AlertDialog(
      title: Text('Approve or Reject Document'),
      content: Text(document.fileName),
      actions: <Widget>[
        // Button to approve the document.
        ElevatedButton(
          child: Text('Approve'),
          onPressed: () {
            // Approve the document.
            _approveDocument(document);

            // Close the dialog.
            Navigator.pop(context);
          },
        ),

        // Add other buttons or actions as needed.
      ],
    );

    // Show the dialog.
    showDialog(context: context, builder: (context) => dialog);
  }

  // Implement the _approveDocument function to handle document approval.
  void _approveDocument(Document document) {
    // Implement your logic to handle document approval here.
    // You can update the document status in Firestore or perform any other actions.
  }
}

class Document {
  final String fileName;
  final String fileUrl;

  Document({
    required this.fileName,
    required this.fileUrl,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      fileName: json['fileName'] ?? '',
      fileUrl: json['fileUrl'] ?? '',
    );
  }
}
