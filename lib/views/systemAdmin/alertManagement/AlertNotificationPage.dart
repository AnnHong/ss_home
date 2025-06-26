import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  // Helper function to get the right icon for each alert type
  IconData _getIconForAlertType(String alertType) {
    // ... no changes to this function
    switch (alertType.toLowerCase()) {
      case 'need ambulance':
        return Icons.emergency_outlined;
      case 'fire':
        return Icons.local_fire_department_outlined;
      case 'need police':
        return Icons.local_police_outlined;
      case 'need assistance':
        return Icons.help_outline;
      default:
        return Icons.notifications_outlined;
    }
  }

  // Helper function to get the right color for each alert type
  Color _getColorForAlertType(String alertType) {
    // ... no changes to this function
    switch (alertType.toLowerCase()) {
      case 'need ambulance':
        return Colors.red.shade600;
      case 'fire':
        return Colors.orange.shade700;
      case 'need police':
        return Colors.blue.shade600;
      case 'need assistance':
        return Colors.grey.shade600;
      default:
        return Colors.grey;
    }
  }

  // Helper function for smart "time ago" formatting
  String _formatTimestamp(DateTime timestamp) {
    // ... no changes to this function
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return DateFormat('HH:ss\nd MMM yyyy').format(timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('Alert Notification')
                .orderBy('alertTime', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No notifications',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final notifications = snapshot.data!.docs;
          final count = notifications.length;
          final titleText = "Recent Alerts ($count)";

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // The title showing the count of notifications.
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  titleText,
                  style: const TextStyle(
                    fontSize: 24, // Larger font for a title
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // NEW: A visual separator.
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(thickness: 1.0),
              ),

              // NEW: The list is now wrapped in an Expanded widget.
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8.0),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    var notification =
                        notifications[index].data() as Map<String, dynamic>;

                    // --- All the logic for building the card is unchanged ---
                    var alertType =
                        notification['alertType'] ?? 'No Alert Type';
                    var trigger = notification['alertTrigger'] ?? 'Unknown';
                    var timestamp =
                        (notification['alertTime'] as Timestamp?)?.toDate() ??
                        DateTime.now();

                    final alertColor = _getColorForAlertType(alertType);
                    final alertIcon = _getIconForAlertType(alertType);
                    final formattedTime = _formatTimestamp(timestamp);

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 6.0,
                      ),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Row(
                        children: [
                          Container(width: 8, color: alertColor),
                          Expanded(
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              leading: Icon(
                                alertIcon,
                                color: alertColor,
                                size: 36,
                              ),
                              title: Text(
                                alertType,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              subtitle: Text(
                                'Triggered by: $trigger',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              trailing: Text(
                                formattedTime,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
