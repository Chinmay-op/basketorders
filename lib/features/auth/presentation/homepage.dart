import 'package:basketorders/features/auth/presentation/create_group_page.dart';
import 'package:basketorders/features/auth/presentation/features/auth/controllers/home_controller.dart';
import 'package:basketorders/features/auth/presentation/group_page.dart';
import 'package:basketorders/features/auth/presentation/join_group_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeController controller = Get.put(HomeController());

  /// Helper to get username from UID
  Future<String> getUsername(String uid) async {
    var doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    if (!doc.exists) return "Unknown";

    return doc["username"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffF5F7FA),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Home",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Welcome back",
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none, color: Colors.black54),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Your Groups title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Your Groups",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                TextButton(onPressed: () {}, child: const Text("See All")),
              ],
            ),

            const SizedBox(height: 10),

            /// GROUP LIST FROM FIRESTORE
            Expanded(
              child: StreamBuilder(
                stream: controller.getUserGroups(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var groups = snapshot.data!.docs;

                  if (groups.isEmpty) {
                    return const Center(child: Text("No groups yet"));
                  }

                  return ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      var group = groups[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GroupPage(groupId: group.id),
                            ),
                          );
                        },

                        child: FutureBuilder(
                          future: getUsername(
                            group["members"][group["turnIndex"]],
                          ),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const SizedBox();
                            }

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: groupCard(
                                title: group["groupName"],
                                next: snapshot.data!,
                                active: false,
                                items: "",
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            /// Create + Find group buttons
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    child: actionBox(Icons.add, "Create Group"),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateGroupPage(),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: GestureDetector(
                    child: actionBox(Icons.search, "Find Group"),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => JoinGroupPage()),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Alerts",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  /// Group Card Widget
  Widget groupCard({
    required String title,
    required String next,
    required bool active,
    required String items,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(blurRadius: 5, color: Colors.black12)],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const CircleAvatar(radius: 4, backgroundColor: Colors.green),
              const SizedBox(width: 6),
              Text("Next: $next"),
            ],
          ),

          if (active) ...[
            const Divider(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Active Order",
                  style: TextStyle(color: Colors.blue),
                ),
                Text(items, style: const TextStyle(color: Colors.blue)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Create / Find Group box
  Widget actionBox(IconData icon, String text) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.withOpacity(0.1),
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
