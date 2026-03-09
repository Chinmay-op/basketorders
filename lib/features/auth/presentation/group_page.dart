import 'package:basketorders/features/auth/presentation/features/auth/controllers/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupPage extends StatelessWidget {
  final String groupId;

  GroupPage({super.key, required this.groupId});

  final GroupController controller = Get.put(GroupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Group")),

      body: StreamBuilder(
        stream: controller.getGroup(groupId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var group = snapshot.data!;

          String groupName = group["groupName"];
          String joinCode = group["joinCode"];
          List members = group["members"];
          int turnIndex = group["turnIndex"];

          return Column(
            children: [
              const SizedBox(height: 20),

              /// TOGGLE
              Obx(
                () => ToggleButtons(
                  isSelected: [
                    controller.selectedTab.value == 0,
                    controller.selectedTab.value == 1,
                  ],
                  onPressed: (index) {
                    controller.selectedTab.value = index;
                  },
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("Overview"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("Responsibility"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Obx(() {
                  /// OVERVIEW TAB
                  if (controller.selectedTab.value == 0) {
                    return Padding(
                      padding: const EdgeInsets.all(20),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            groupName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text("Join Code: $joinCode"),

                          const SizedBox(height: 20),

                          const Text(
                            "Members",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 10),

                          ...members.map(
                            (uid) => FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(uid)
                                  .get(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const ListTile(
                                    title: Text("Loading..."),
                                  );
                                }

                                var user = snapshot.data!;
                                String username = user["username"];

                                return ListTile(
                                  leading: const Icon(Icons.person),
                                  title: Text(username),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  /// RESPONSIBILITY TAB

                  String currentUser = members[turnIndex];

                  String loggedUser = FirebaseAuth.instance.currentUser!.uid;
                  bool isMyTurn = loggedUser == currentUser;

                  List queue = [
                    ...members.sublist(turnIndex),
                    ...members.sublist(0, turnIndex),
                  ];

                  return Padding(
                    padding: const EdgeInsets.all(20),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Text(
                          "Next Order Responsibility",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// CURRENT USER
                        FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection("users")
                              .doc(currentUser)
                              .get(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Text("Loading...");
                            }

                            String username = snapshot.data!["username"];

                            return Text(
                              "Current: $username",
                              style: const TextStyle(fontSize: 16),
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Queue",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 10),

                        ...queue.map(
                          (uid) => FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection("users")
                                .doc(uid)
                                .get(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const ListTile(
                                  title: Text("Loading..."),
                                );
                              }

                              String username = snapshot.data!["username"];

                              return ListTile(
                                leading: const Icon(Icons.circle, size: 10),
                                title: Text(username),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Items",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 10),

                        /// ITEM LIST
                        Expanded(
                          child: StreamBuilder(
                            stream: controller.getItems(groupId),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              var items = snapshot.data!.docs;

                              if (items.isEmpty) {
                                return const Text("No items added");
                              }

                              return ListView.builder(
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  var item = items[index];

                                  return ListTile(
                                    leading: const Icon(Icons.shopping_cart),
                                    title: Text(item["name"]),
                                  );
                                },
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// ORDER PICKED UP BUTTON
                        if (isMyTurn)
                          ElevatedButton(
                            onPressed: () {
                              controller.nextTurn(groupId, members, turnIndex);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            child: const Text("Order Picked Up"),
                          )
                        else
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Waiting for responsible person to pick up order",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),

                        const SizedBox(height: 10),

                        /// ADD ITEM FIELD
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller.itemController,
                                decoration: const InputDecoration(
                                  hintText: "Add item",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            IconButton(
                              icon: const Icon(
                                Icons.add_circle,
                                color: Colors.blue,
                                size: 32,
                              ),
                              onPressed: () {
                                controller.addItem(
                                  groupId,
                                  controller.itemController.text,
                                );

                                controller.itemController.clear();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}
