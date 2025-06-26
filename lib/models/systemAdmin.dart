import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SystemAdmin {
  final String systemAdminID;
  final String systemAdminName;
  final String systemAdminEmail;
  final String systemAdminPhoneNum;
  final String systemAdminSecPassword;

  SystemAdmin({
    required this.systemAdminID,
    required this.systemAdminName,
    required this.systemAdminEmail,
    required this.systemAdminPhoneNum,
    required this.systemAdminSecPassword,
  });

  factory SystemAdmin.fromJson(Map<String, dynamic> json) => SystemAdmin(
    systemAdminID: json['systemAdminID'],
    systemAdminName: json['systemAdminName'],
    systemAdminEmail: json['systemAdminEmail'],
    systemAdminPhoneNum: json['systemAdminPhoneNum'],
    systemAdminSecPassword: json['systemAdminSecPassword'],
  );

  Map<String, dynamic> toJson() => {
    'systemAdminID': systemAdminID,
    'systemAdminName': systemAdminName,
    'systemAdminEmail': systemAdminEmail,
    'systemAdminPhoneNum': systemAdminPhoneNum,
    'systemAdminSecPassword': systemAdminSecPassword,
  };

  factory SystemAdmin.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SystemAdmin(
      systemAdminID: doc.id, // use document ID, not a field
      systemAdminName: data['systemAdminName'] ?? '',
      systemAdminEmail: data['systemAdminEmail'] ?? '',
      systemAdminPhoneNum: data['systemAdminPhoneNum'] ?? '',
      systemAdminSecPassword: data['systemAdminSecPassword'] ?? '',
    );
  }

  factory SystemAdmin.fromMap(Map<String, dynamic> data, String id) {
    return SystemAdmin(
      systemAdminID: id, // pass in doc.id here
      systemAdminName: data['systemAdminName'] ?? '',
      systemAdminEmail: data['systemAdminEmail'] ?? '',
      systemAdminPhoneNum: data['systemAdminPhoneNum'] ?? '',
      systemAdminSecPassword: data['systemAdminSecPassword'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'systemAdminID': systemAdminID,
      'systemAdminName': systemAdminName,
      'systemAdminEmail': systemAdminEmail,
      'systemAdminPhoneNum': systemAdminPhoneNum,
      'systemAdminSecPassword': systemAdminSecPassword,
    };
  }
}
