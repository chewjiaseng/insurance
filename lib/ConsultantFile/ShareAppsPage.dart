import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

class ShareAppsPage extends StatefulWidget {
  const ShareAppsPage({Key? key}) : super(key: key);

  @override
  _ShareAppsPageState createState() => _ShareAppsPageState();
}

class _ShareAppsPageState extends State<ShareAppsPage> {
  List<Contact> _contacts = [];
  Contact? _selectedContact;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    // Check and request the READ_CONTACTS permission
    var status = await Permission.contacts.request();
    if (!status.isGranted) {
      // Handle the case when the permission is not granted
      return;
    }

    Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts.toList();
      _contacts.sort((a, b) =>
          a.displayName?.toLowerCase().compareTo(b.displayName?.toLowerCase() ?? '') ?? 0);
    });
  }

  Future<void> _shareAppWithContact(Contact contact) async {
    final String message = 'Check out this awesome app!\n\n'
        'Download the app from the Play Store or App Store: [INSERT APP LINK HERE]';
    await Share.share(
      message,
      subject: 'App Share', // Subject (not used in Android)
    );
  }

  void _showContactDialog(BuildContext context, Contact contact) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Share App with ${contact.displayName ?? 'Contact'}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                ListTile(
                  leading: _buildContactAvatar(contact),
                  title: Text(contact.displayName ?? 'N/A'),
                  subtitle: Text(contact.phones?.first.value ?? 'N/A'),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _shareAppWithContact(contact);
                        Navigator.pop(context); // Close the dialog after sharing
                      },
                      child: Text('Share'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactAvatar(Contact contact) {
    if (contact.avatar != null && contact.avatar!.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: MemoryImage(contact.avatar!),
      );
    } else {
      return CircleAvatar(
        child: Text(contact.displayName?[0] ?? ''),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share Apps'),
        backgroundColor: Colors.teal, // Set app bar color
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
        child: _contacts.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  final contact = _contacts[index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      leading: _buildContactAvatar(contact),
                      title: Text(contact.displayName ?? 'N/A'),
                      subtitle: Text(contact.phones?.first.value ?? 'N/A'),
                      onTap: () {
                        setState(() {
                          _selectedContact = contact;
                        });
                        _showContactDialog(context, contact);
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ShareAppsPage(),
  ));
}
