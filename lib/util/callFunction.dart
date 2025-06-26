// lib/widgets/family_member_list.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:ss_home/models/familyMember.dart';
import 'package:ss_home/models/staff.dart';
import 'package:ss_home/models/systemAdmin.dart';
import 'package:fluttertoast/fluttertoast.dart'; // For displaying messages
import 'package:url_launcher/url_launcher.dart';

//Direct Phone call function
//Family Member List with phone number
class FamilyMemberList extends StatelessWidget {
  const FamilyMemberList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('familyMember').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Text('Error loading family members.');
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return const Text('No family members found.');
        }

        final familyMember =
            docs.map((doc) => FamilyMemberModel.fromDocument(doc)).toList();
        ;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: familyMember.length,
          itemBuilder: (context, index) {
            final member = familyMember[index];

            return ListTile(
              title: Text(member.familyMemName),
              subtitle: Text(
                '(${member.seniorName})\nPhone: ${member.familyMemPhoneNumber}',
              ),
              trailing: const Icon(Icons.call),
              onTap: () async {
                final phone = member.familyMemPhoneNumber.toString();
                if (phone.isNotEmpty) {
                  await FlutterPhoneDirectCaller.callNumber(phone);
                }
              },
            );
          },
        );
      },
    );
  }
}

//Staff List with phone number
class StaffList extends StatelessWidget {
  const StaffList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('staff').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Text('Error loading Staff.');
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return const Text('No staff data found.');
        }

        final staffInfo =
            docs.map((doc) => StaffModel.fromDocument(doc)).toList();

        return ListView.builder(
          shrinkWrap: true,
          itemCount: staffInfo.length,
          itemBuilder: (context, index) {
            final staff = staffInfo[index];

            return ListTile(
              title: Text(staff.staffName),
              subtitle: Text('(${staff.staffPhoneNum})'),
              trailing: const Icon(Icons.call),
              onTap: () async {
                final staffPhone = staff.staffPhoneNum.toString();
                if (staffPhone.isNotEmpty) {
                  await FlutterPhoneDirectCaller.callNumber(staffPhone);
                }
              },
            );
          },
        );
      },
    );
  }
}

//System Admin List with phone number
class SystemAdminList extends StatelessWidget {
  const SystemAdminList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('systemAdmin').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Text('Error loading System Admin.');
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return const Text('No system admin data found.');
        }

        final systemAdminInfo =
            docs.map((doc) => SystemAdmin.fromDocument(doc)).toList();
        ;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: systemAdminInfo.length,
          itemBuilder: (context, index) {
            final systemAdmin = systemAdminInfo[index];

            return ListTile(
              title: Text(systemAdmin.systemAdminName),
              subtitle: Text('(${systemAdmin.systemAdminPhoneNum})'),
              trailing: const Icon(Icons.call),
              onTap: () async {
                final systemAdminPhone =
                    systemAdmin.systemAdminPhoneNum.toString();
                if (systemAdminPhone.isNotEmpty) {
                  await FlutterPhoneDirectCaller.callNumber(systemAdminPhone);
                }
              },
            );
          },
        );
      },
    );
  }
}

class EmergencyList extends StatelessWidget {
  const EmergencyList({Key? key}) : super(key: key);

  // Function to make a phone call
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      // Use Fluttertoast for a user-friendly message
      Fluttertoast.showToast(
        msg:
            "Could not launch call to $phoneNumber. Please check your device settings.",
        toastLength:
            Toast.LENGTH_LONG, // Longer display time for important messages
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print('Could not launch $launchUri'); // Log for debugging
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define your static emergency contact
    const String emergencyName = "Emergency Services";
    const String emergencyNumber = "999";

    return ListTile(
      title: Text(emergencyName),
      subtitle: Text('(' + emergencyNumber + ')'),
      trailing: const Icon(Icons.call),
      onTap: () async {
        await _makePhoneCall(emergencyNumber);
      },
    );
  }
}
