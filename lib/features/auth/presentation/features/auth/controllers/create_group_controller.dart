import 'package:basketorders/features/auth/data/groupmodel.dart';
import 'package:basketorders/features/auth/data/grouprepository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateGroupController extends GetxController {
  final groupNameController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GroupRepository groupRepository = Get.put(GroupRepository());

  Future<void> createGroup() async {
    String groupName = groupNameController.text.trim();

    if (groupName.isEmpty) {
      Get.snackbar("Error", "Enter group name");
      return;
    }

    String userId = _auth.currentUser!.uid;

    String groupId = FirebaseFirestore.instance.collection("groups").doc().id;

    String joinCode = generateJoinCode();

    GroupModel newGroup = GroupModel(
      id: groupId,
      groupName: groupName,
      createdBy: userId,
      members: [userId],
      joinCode: joinCode,
      turnIndex: 0,
    );

    await groupRepository.createGroup(newGroup);
  }

  String generateJoinCode() {
    return DateTime.now().millisecondsSinceEpoch.toString().substring(7);
  }

  @override
  void onClose() {
    groupNameController.dispose();
    super.onClose();
  }
}
