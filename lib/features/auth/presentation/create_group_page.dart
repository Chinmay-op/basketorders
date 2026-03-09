import 'package:basketorders/features/auth/presentation/features/auth/controllers/create_group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateGroupPage extends StatelessWidget {
  CreateGroupPage({super.key});

  final controller = Get.put(CreateGroupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Group")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller.groupNameController,
              decoration: const InputDecoration(labelText: "Group Name"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                controller.createGroup();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple, // button color
                foregroundColor: Colors.white, // text color
              ),
              child: const Text("Create Group"),
            ),
          ],
        ),
      ),
    );
  }
}
