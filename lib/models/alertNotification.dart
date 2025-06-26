import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AlertNotificationModel {
  String alertID;
  String alertTrigger;
  String alertType;
  Timestamp alertTime; // Firestore Timestamp for alert time

  AlertNotificationModel({
    required this.alertID,
    required this.alertTrigger,
    required this.alertType,
    required this.alertTime,
  });

  factory AlertNotificationModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    Timestamp alertTime = data['alertTime'];
    return AlertNotificationModel(
      alertID: doc.id, // Document ID
      alertTrigger: data['alertTrigger'] ?? '',
      alertType: data['alertType'] ?? '',
      alertTime: alertTime,
    );
  }

  factory AlertNotificationModel.fromMap(Map<String, dynamic> data, String id) {
    Timestamp alertTime = data['alertTime'];
    return AlertNotificationModel(
      alertID: id,
      alertTrigger: data['alertTrigger'] ?? '',
      alertType: data['alertType'] ?? '',
      alertTime: alertTime,
    );
  }

  // Convert model to map for Firestore saving
  Map<String, dynamic> toMap() {
    return {
      'alertTrigger': alertTrigger,
      'alertType': alertType,
      'alertTime': alertTime,
    };
  }

  // Method to format alertDate as 'yyyy-MM-dd'
  String getFormattedDate() {
    DateTime dateTime = alertTime.toDate();
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  // Method to format alertTime as 'HH:mm:ss'
  String getFormattedTime() {
    return DateFormat('HH:mm:ss').format(alertTime.toDate());
  }
}
