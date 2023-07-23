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
        title: Text('Activity Logs: $userName'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Container(
              color: const Color.fromARGB(255, 0, 42, 212), 
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Activity Logs :',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Set text color for visibility
                ),
              ),
            ),
            SizedBox(height: 8),
            if (activityLogs.isEmpty)
              Expanded(
                child: Center(
                  child: Text('No activity logs found.'),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: activityLogs.length,
                  itemBuilder: (context, index) {
                    // Check if the log is related to "Role Assigned" or "User Blocked"
                    bool isRoleAssignedLog = activityLogs[index].contains('Role Assigned');
                    bool isUserBlockedLog = activityLogs[index].contains('User Blocked');

                    Color logColor = Colors.black; // Default black color for other logs
                    if (isUserBlockedLog) {
                      logColor = Color(0xFF62A7C5); // Default green for other "Role Assigned" logs
                      
                    } else if (isRoleAssignedLog) {
                      logColor = Color(0xFF1E7CC4); // Orange for User Blocked logs
                    }

                    return Container(
                      color: logColor,
                      padding: EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(
                          activityLogs[index],
                          style: TextStyle(
                            color: Colors.white, // Set text color for visibility
                            fontWeight: isRoleAssignedLog || isUserBlockedLog ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
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
