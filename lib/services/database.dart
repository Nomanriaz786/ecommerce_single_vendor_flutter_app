import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addRecord(Map<String, dynamic> personMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Person")
        .doc(id)
        .set(personMap);
  }

  Future<Stream<QuerySnapshot>> getPersonData() async {
    return FirebaseFirestore.instance.collection("Person").snapshots();
  }
}
