import 'package:cloud_firestore/cloud_firestore.dart';

class StaffModel {
  String staffId;
  String staffName;
  String staffIC;
  String staffPhoneNum;
  String staffPassword;

  StaffModel({
    required this.staffId,
    required this.staffName,
    required this.staffIC,
    required this.staffPhoneNum,
    required this.staffPassword,
  });

  factory StaffModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StaffModel(
      staffId: doc.id, // use document ID, not a field
      staffName: data['staffName'] ?? '',
      staffIC: data['staffIC'] ?? '',
      staffPhoneNum: data['staffPhoneNum'] ?? '',
      staffPassword: data['staffPassword'] ?? '',
    );
  }

  factory StaffModel.fromMap(Map<String, dynamic> data, String id) {
    return StaffModel(
      staffId: id, // pass in doc.id here
      staffName: data['staffName'] ?? '',
      staffIC: data['staffIC'] ?? '',
      staffPhoneNum: data['staffPhoneNum'] ?? '',
      staffPassword: data['staffPassword'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'staffName': staffName,
      'staffIC': staffIC,
      'staffPhoneNum': staffPhoneNum,
      'staffPassword': staffPassword,
    };
  }
}
