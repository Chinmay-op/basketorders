import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  RxInt selectedTab = 0.obs;

  TextEditingController itemController = TextEditingController();

  /// STREAM GROUP DOCUMENT
  Stream<DocumentSnapshot> getGroup(String groupId) {
    return _db.collection("groups").doc(groupId).snapshots();
  }

  /// NEXT TURN LOGIC
  Future<void> nextTurn(String groupId, List members, int turnIndex) async {
    int nextIndex = turnIndex + 1;

    if (nextIndex >= members.length) {
      nextIndex = 0;
    }

    await _db.collection("groups").doc(groupId).update({
      "turnIndex": nextIndex,
    });
  }

  /// GET ITEMS STREAM
  Stream<QuerySnapshot> getItems(String groupId) {
    return _db
        .collection("groups")
        .doc(groupId)
        .collection("items")
        .orderBy("createdAt")
        .snapshots();
  }

  /// ADD ITEM
  Future<void> addItem(String groupId, String itemName) async {
    if (itemName.trim().isEmpty) return;

    await _db.collection("groups").doc(groupId).collection("items").add({
      "name": itemName,
      "createdAt": Timestamp.now(),
    });
  }

  @override
  void onClose() {
    itemController.dispose();
    super.onClose();
  }
}
