import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ss_home/models/staff.dart';

class staffController {
  final CollectionReference staffCollection = FirebaseFirestore.instance
      .collection('staff');
  //add function
  Future<void> addStaff(StaffModel staff) async {
    await staffCollection.add(staff.toMap());
  }

  //fetch data function
  Stream<List<StaffModel>> getStaff() {
    return FirebaseFirestore.instance.collection('staff').snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return StaffModel.fromMap(doc.data(), doc.id); // 🔥 pass doc.id
      }).toList();
    });
  }

  //update function
  Future<void> updateStaff(StaffModel staff) async {
    await FirebaseFirestore.instance
        .collection('staff')
        .doc(staff.staffId)
        .update(staff.toMap());
  }

  Future<void> deleteStaff(String staffId) async {
    await staffCollection.doc(staffId).delete();
  }
}
