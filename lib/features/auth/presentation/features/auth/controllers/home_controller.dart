import 'package:basketorders/features/auth/data/grouprepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class HomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GroupRepository groupRepository = Get.put(GroupRepository());

  Stream<QuerySnapshot> getUserGroups() {
    String userId = _auth.currentUser!.uid;

    return groupRepository.getUserGroups(userId);
  }
}
