import 'package:cloud_firestore/cloud_firestore.dart';

class RecordingModel {
  String recordingID;
  String recordingName;
  String recordingTime;
  String recordingURL;

  RecordingModel({
    required this.recordingID,
    required this.recordingName,
    required this.recordingTime,
    required this.recordingURL,
  });

  factory RecordingModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RecordingModel(
      recordingID: doc.id, // use document ID, not a field
      recordingName: data['recordingName'] ?? '',
      recordingTime: data['recordingTime'] ?? '',
      recordingURL: data['recordingURL'] ?? '',
    );
  }

  factory RecordingModel.fromMap(Map<String, dynamic> data, String id) {
    return RecordingModel(
      recordingID: id, // pass in doc.id here
      recordingName: data['recordingName'] ?? '',
      recordingTime: data['recordingTime'] ?? '',
      recordingURL: data['recordingURL'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'recordingName': recordingName,
      'recordingTime': recordingTime,
      'recordingURL': recordingURL,
    };
  }
}
