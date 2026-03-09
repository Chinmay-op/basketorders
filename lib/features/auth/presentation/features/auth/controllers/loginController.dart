import 'package:basketorders/features/auth/presentation/homepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static LoginController get instance => Get.find();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {
    String email = emailController.text;
    String password = passwordController.text;

    signInUser(email, password);
  }

  Future<void> signInUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      print('User logged in: ${user?.email}');

      Get.snackbar("Success", "Login successful");
      Get.offAll(() => HomePage());

      // navigate to home page later
      // Get.offAll(() => HomePage());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar("Error", "No user found with that email");
      } else if (e.code == 'wrong-password') {
        Get.snackbar("Error", "Wrong password");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
