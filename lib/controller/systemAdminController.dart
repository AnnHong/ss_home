import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ss_home/models/systemAdmin.dart';

class systemAdminController {
  final CollectionReference systemAdminCollection = FirebaseFirestore.instance
      .collection('systemAdmin');
  //add function
  Future<void> addSystemAdmin(SystemAdmin systemAdmin) async {
    await systemAdminCollection.add(systemAdmin.toMap());
  }
}
