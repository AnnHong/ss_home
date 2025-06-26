import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ss_home/models/senior.dart';
// adjust import path as needed

class SeniorController {
  final CollectionReference seniorCollection = FirebaseFirestore.instance
      .collection('senior');

  Future<void> addSenior(SeniorModel seniorModel) async {
    await seniorCollection.doc(seniorModel.seniorId).set(seniorModel.toMap());
  }

  Stream<List<SeniorModel>> getSenior() {
    try {
      return FirebaseFirestore.instance
          .collection('senior')
          .snapshots()
          .map(
            (snapshot) =>
                snapshot.docs
                    .map((doc) => SeniorModel.fromDocument(doc))
                    .toList(),
          );
    } catch (e) {
      print("Firestore error: $e");
      return Stream.value([]);
    }
  }

  //update function
  Future<void> updateSenior(SeniorModel senior) async {
    await FirebaseFirestore.instance
        .collection('senior')
        .doc(senior.seniorId)
        .update(senior.toMap());
  }
}
