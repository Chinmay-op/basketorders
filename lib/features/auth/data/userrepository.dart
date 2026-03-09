import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'usermodel.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<void> createUser(Usermodel user) async {
    await _db.collection("users").doc(user.id).set(user.toJson());

    Get.snackbar("Success", "User stored in database");
  }
}
