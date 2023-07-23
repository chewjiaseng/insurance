import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

class ShareAppsPage extends StatelessWidget {
  const ShareAppsPage({Key? key}) : super(key: key);

  Future<void> _shareAppWithContact(Contact contact) async {
    final String message = 'Check out this awesome app!\n\n'
        'Download the app from the Play Store or App Store: [INSERT APP LINK HERE]';
    await Share.share(
      message,
      subject: 'App Share', // Subject (not used in Android)
    );
  }

  Future<void> _selectContactAndShare(BuildContext context) async {
    Iterable<Contact> contacts = await ContactsService.getContacts();
    if (contacts.isEmpty) {
      // Handle the case when no contacts are available
      return;
    }

    // Check and request the READ_CONTACTS permission
    var status = await Permission.contacts.request();
    if (!status.isGranted) {
      // Handle the case when the permission is not granted
      return;
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select a contact to share the app with:'),
          content: SingleChildScrollView(
            child: ListBody(
              children: contacts
                  .map(
                    (contact) => ListTile(
                      title: Text(contact.displayName ?? ''),
                      onTap: () {
                        Navigator.pop(context);
                        _shareAppWithContact(contact);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share Apps'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _selectContactAndShare(context),
          child: Text('Share App'),
        ),
      ),
    );
  }
}
