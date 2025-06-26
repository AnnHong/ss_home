import 'package:cloud_firestore/cloud_firestore.dart';

class FamilyMemberModel {
  String familyMemId;
  String seniorName;
  String familyMemName;
  String familyMemPhoneNumber;
  String familyMemAddr;
  String familyMemPostCode;
  String familyMemCity;
  String familyMemState;

  FamilyMemberModel({
    required this.familyMemId,
    required this.seniorName,
    required this.familyMemName,
    required this.familyMemPhoneNumber,
    required this.familyMemAddr,
    required this.familyMemPostCode,
    required this.familyMemCity,
    required this.familyMemState,
  });

  factory FamilyMemberModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FamilyMemberModel(
      familyMemId: doc.id, // use document ID, not a field
      seniorName: data['seniorName'] ?? '',
      familyMemName: data['familyMemName'] ?? '',
      familyMemPhoneNumber: data['familyMemPhoneNumber'] ?? '',
      familyMemAddr: data['familyMemAddr'] ?? '',
      familyMemPostCode: data['familyMemPostCode'] ?? '',
      familyMemCity: data['familyMemCity'] ?? '',
      familyMemState: data['familyMemState'] ?? '',
    );
  }

  factory FamilyMemberModel.fromMap(Map<String, dynamic> data, String id) {
    return FamilyMemberModel(
      familyMemId: id, // pass in doc.id here
      seniorName: data['seniorName'] ?? '',
      familyMemName: data['familyMemName'] ?? '',
      familyMemPhoneNumber: data['familyMemPhoneNumber'] ?? '',
      familyMemAddr: data['familyMemAddr'] ?? '',
      familyMemPostCode: data['familyMemPostCode'] ?? '',
      familyMemCity: data['familyMemCity'] ?? '',
      familyMemState: data['familyMemState'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'seniorName': seniorName,
      'familyMemName': familyMemName,
      'familyMemPhoneNumber': familyMemPhoneNumber,
      'familyMemAddr': familyMemAddr,
      'familyMemPostCode': familyMemPostCode,
      'familyMemCity': familyMemCity,
      'familyMemState': familyMemState,
    };
  }
}
