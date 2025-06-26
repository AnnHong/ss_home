import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ss_home/models/familyMember.dart';

class familyMemberController {
  final CollectionReference familyMemCollection = FirebaseFirestore.instance
      .collection('familyMember');
  //add function
  Future<void> addFamilyMember(FamilyMemberModel familyMember) async {
    await familyMemCollection.add(familyMember.toMap());
  }

  //fetch data function
  Stream<List<FamilyMemberModel>> getFamilyMembers() {
    return FirebaseFirestore.instance
        .collection('familyMember')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return FamilyMemberModel.fromMap(
              doc.data(),
              doc.id,
            ); // 🔥 pass doc.id
          }).toList();
        });
  }

  //update function
  Future<void> updateFamilyMember(FamilyMemberModel member) async {
    await FirebaseFirestore.instance
        .collection('familyMember')
        .doc(member.familyMemId)
        .update(member.toMap());
  }
}
