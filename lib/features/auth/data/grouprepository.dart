import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'groupmodel.dart';

class GroupRepository extends GetxController {
  static GroupRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<void> createGroup(GroupModel group) async {
    await _db.collection("groups").doc(group.id).set(group.toJson());

    Get.snackbar("Success", "Group created");
  }

  Stream<QuerySnapshot> getUserGroups(String userId) {
    return _db
        .collection("groups")
        .where("members", arrayContains: userId)
        .snapshots();
  }
}
