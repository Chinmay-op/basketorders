import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:basketorders/features/auth/presentation/login.dart';
import 'package:basketorders/features/auth/data/userrepository.dart';
import 'package:basketorders/features/auth/data/usermodel.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static SignUpController get instance => Get.find();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  final UserRepository userRepository = Get.put(UserRepository());

  Future<void> signUp() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String username = usernameController.text.trim();

    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        Usermodel newUser = Usermodel(
          id: user.uid,
          username: username,
          email: email,
        );

        await userRepository.createUser(newUser);
      }

      Get.snackbar("Success", "Account created");

      Get.offAll(() => LoginPage());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar("Error", "Password is too weak");
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar("Error", "Email already exists");
      } else {
        Get.snackbar("Error", e.message ?? "Signup failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();

    super.onClose();
  }
}
