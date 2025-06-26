import 'package:cloud_firestore/cloud_firestore.dart';

class SeniorModel {
  String seniorId;
  String seniorName;
  int seniorAge;
  String seniorGender;
  double seniorTemp;
  int seniorBloodPressure_SYS;
  int seniorBloodPressure_DIA;
  int seniorHeartRate;
  int seniorSpO2;

  SeniorModel({
    required this.seniorId,
    required this.seniorName,
    required this.seniorAge,
    required this.seniorGender,
    required this.seniorTemp,
    required this.seniorBloodPressure_SYS,
    required this.seniorBloodPressure_DIA,
    required this.seniorHeartRate,
    required this.seniorSpO2,
  });

  factory SeniorModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SeniorModel(
      seniorId: doc.id, // use document ID, not a field
      seniorName: data['seniorName'] ?? '',
      seniorAge: data['seniorAge'] ?? 0,
      seniorGender: data['seniorGender'] ?? '',
      seniorTemp: data['seniorTemp'] ?? 0.0,
      seniorBloodPressure_SYS: data['seniorBloodPressure_SYS'] ?? 0,
      seniorBloodPressure_DIA: data['seniorBloodPressure_DIA'] ?? 0,
      seniorHeartRate: data['seniorHeartRate'] ?? 0,
      seniorSpO2: data['seniorSpO2'] ?? 0,
    );
  }

  factory SeniorModel.fromMap(Map<String, dynamic> data, String id) {
    return SeniorModel(
      seniorId: id, // use document ID, not a field
      seniorName: data['seniorName'] ?? '',
      seniorAge: data['seniorAge'] ?? 0,
      seniorGender: data['seniorGender'] ?? '',
      seniorTemp: data['seniorTemp'] ?? 0.0,
      seniorBloodPressure_SYS: data['seniorBloodPressure_SYS'] ?? 0,
      seniorBloodPressure_DIA: data['seniorBloodPressure_DIA'] ?? 0,
      seniorHeartRate: data['seniorHeartRate'] ?? 0,
      seniorSpO2: data['seniorSpO2'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'seniorName': seniorName,
      'seniorAge': seniorAge,
      'seniorGender': seniorGender,
      'seniorTemp': seniorTemp,
      'seniorBloodPressure_SYS': seniorBloodPressure_SYS,
      'seniorBloodPressure_DIA': seniorBloodPressure_DIA,
      'seniorHeartRate': seniorHeartRate,
      'seniorSpO2': seniorSpO2,
    };
  }
}
