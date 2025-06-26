import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ss_home/controller/alertNotificationController.dart';
// import 'package:ss_home/controller/alertNotificationController.dart';
import 'package:ss_home/models/alertNotification.dart';

class AlertNotificationWidget {
  Widget alertCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show SnackBar after adding an alert to Firebase
  Future<void> showSnackBar(
    BuildContext context,
    DateTime now,
    String alertType,
    String currentUser,
  ) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Alert :\n"
          "Date: ${now.toLocal().toIso8601String().split('T')[0]}\n"
          "Time: ${now.toLocal().toIso8601String().split('T')[1].split('.')[0]}\n"
          "Alert Type : $alertType\n"
          "Triggered by: $currentUser",
        ),
      ),
    );

    String alertID =
        FirebaseFirestore.instance.collection('Notification').doc().id;
    AlertNotificationModel alertNotification = AlertNotificationModel(
      alertID: alertID,
      alertTrigger: currentUser,
      alertType: alertType,
      alertTime: Timestamp.fromDate(now), // Save Timestamp
    );
    await alertNotificationController().addAlertNotification(alertNotification);
  }
}
