import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'uploadPolicy.dart';

class PolicyReview extends StatefulWidget {
  @override
  State<PolicyReview> createState() => _PolicyReviewState();
}

class _PolicyReviewState extends State<PolicyReview> {
  List<Document> documents = [];

  @override
  void initState() {
    super.initState();

    // Get the list of documents from Firebase Firestore.
    _getDocuments();
  }

  void _getDocuments() async {
    // Get the list of documents from Firebase Firestore.
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('documents').get();

    // Add the documents to the list.
    documents = querySnapshot.docs
        .map(
          (doc) => Document(
            fileName: doc['fileName'],
            fileUrl: doc['fileUrl'],
            status: DocumentStatus.values.firstWhere(
              (status) => status.toString() == doc['status'],
              orElse: () => DocumentStatus.pending,
            ),
          ),
        )
        .toList();

    // Update the UI with the list of documents.
    setState(() {
      documents = documents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Policy Review'),
      ),
      body: ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final document = documents[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              title: Text(document.fileName),
              subtitle: Text(document.fileUrl),
              trailing: _buildStatusWidget(document.status),
              onTap: () {
                // Show a dialog to approve or reject the document.
                _showDialog(document);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the UploadPolicy screen to upload a new policy.
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UploadPolicy()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatusWidget(DocumentStatus status) {
    String statusText;
    Color statusColor;

    switch (status) {
      case DocumentStatus.pending:
        statusText = 'Pending';
        statusColor = Colors.orange;
        break;
      case DocumentStatus.approved:
        statusText = 'Approved';
        statusColor = Colors.green;
        break;
      case DocumentStatus.rejected:
        statusText = 'Rejected';
        statusColor = Colors.red;
        break;
      default:
        statusText = '';
        statusColor = Colors.black;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Text(
        statusText,
        style: TextStyle(color: Colors.white),
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
        // Button to reject the document.
        ElevatedButton(
          child: Text('Reject'),
          onPressed: () {
            // Reject the document.
            _rejectDocument(document);

            // Close the dialog.
            Navigator.pop(context);
          },
        ),
      ],
    );

    // Show the dialog.
    showDialog(context: context, builder: (context) => dialog);
  }

  void _approveDocument(Document document) {
    // Update the status of the document to approved in Firebase Firestore.
    FirebaseFirestore.instance
        .collection('documents')
        .doc(document.fileName)
        .update({
      'status': DocumentStatus.approved.toString(),
    });

    // Update the status of the document in the local list.
    setState(() {
      document.status = DocumentStatus.approved;
    });
  }

  void _rejectDocument(Document document) {
    // Update the status of the document to rejected in Firebase Firestore.
    FirebaseFirestore.instance
        .collection('documents')
        .doc(document.fileName)
        .update({
      'status': DocumentStatus.rejected.toString(),
    });

    // Update the status of the document in the local list.
    setState(() {
      document.status = DocumentStatus.rejected;
    });
  }
}
