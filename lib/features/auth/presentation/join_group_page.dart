import 'package:basketorders/features/auth/presentation/features/auth/controllers/join_group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JoinGroupPage extends StatelessWidget {
  JoinGroupPage({super.key});

  final controller = Get.put(JoinGroupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Find Group")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: controller.joinCodeController,
              decoration: const InputDecoration(labelText: "Enter Join Code"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                controller.joinGroup();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple, // button color
                foregroundColor: Colors.white, // text color
              ),
              child: const Text("Join Group"),
            ),
          ],
        ),
      ),
    );
  }
}
