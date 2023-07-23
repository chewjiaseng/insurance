import 'package:flutter/material.dart';

class ActivityLogsPage extends StatelessWidget {
  final String userName;
  final List<String> activityLogs;

  ActivityLogsPage({
    required this.userName,
    required this.activityLogs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Logs for $userName'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (activityLogs.isEmpty)
              Text('No activity logs found.')
            else
              Expanded(
                child: ListView.builder(
                  itemCount: activityLogs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(activityLogs[index]),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
