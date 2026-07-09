import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    super.initState();

    _nameController.text =
        FirebaseAuth.instance.currentUser?.displayName ?? "";
  }

  Future<void> saveProfile() async {
    if (_nameController.text.trim().isEmpty) return;

    setState(() {
      loading = true;
    });

    final newName = _nameController.text.trim();

    await FirebaseAuth.instance.currentUser!
        .updateDisplayName(newName);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "name": newName,
    });

    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      loading = false;
    });

    if (!mounted) return;

    if (mounted) {
      setState(() {});
    }
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xff121212) : const Color(0xffF6F7FB),

      appBar: AppBar(
        backgroundColor:
        isDark ? const Color(0xff121212) : const Color(0xffF6F7FB),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.black,
        ),
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [

            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.teal,
              child: Text(
                (_nameController.text.isEmpty
                    ? "U"
                    : _nameController.text[0])
                    .toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),


            const SizedBox(height: 35),

            TextField(
              controller: _nameController,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor:
                isDark ? const Color(0xff1F1F1F) : Colors.white,
                labelText: "Full Name",
                labelStyle: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              enabled: false,
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
              ),
              controller: TextEditingController(
                text: user?.email ?? "",
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor:
                isDark ? const Color(0xff1F1F1F) : Colors.white,
                labelText: "Email",
                labelStyle: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: loading ? null : saveProfile,
                child: loading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
                  "Save Changes",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}