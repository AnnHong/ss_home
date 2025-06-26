import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ss_home/models/alertNotification.dart';

class alertNotificationController {
  final CollectionReference alertNotificationCollection = FirebaseFirestore
      .instance
      .collection('Alert Notification');

  Future<void> addAlertNotification(
    AlertNotificationModel alertNotification,
  ) async {
    await alertNotificationCollection.add(alertNotification.toMap());
  }

  Stream<List<AlertNotificationModel>> getAlertNotificaton() {
    return FirebaseFirestore.instance
        .collection('Alert Notification')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return AlertNotificationModel.fromMap(
              doc.data(),
              doc.id,
            ); // 🔥 pass doc.id
          }).toList();
        });
  }
}
