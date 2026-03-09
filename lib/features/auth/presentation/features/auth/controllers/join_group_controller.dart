import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JoinGroupController extends GetxController {
  final joinCodeController = TextEditingController();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> joinGroup() async {
    String code = joinCodeController.text.trim();

    if (code.isEmpty) {
      Get.snackbar("Error", "Enter join code");
      return;
    }

    try {
      var result = await _db
          .collection("groups")
          .where("joinCode", isEqualTo: code)
          .get();

      if (result.docs.isEmpty) {
        Get.snackbar("Error", "Group not found");
        return;
      }

      var groupDoc = result.docs.first;

      String userId = _auth.currentUser!.uid;

      await _db.collection("groups").doc(groupDoc.id).update({
        "members": FieldValue.arrayUnion([userId]),
      });

      Get.snackbar("Success", "Joined group");

      Get.back();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  void onClose() {
    joinCodeController.dispose();
    super.onClose();
  }
}
