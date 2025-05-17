import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final VoidCallback onBack;
  final String username;
  final String email;
  final String imagePath;

  const EditProfileScreen({
    super.key,
    required this.onBack,
    required this.username,
    required this.email,
    required this.imagePath,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController usernameController;
  late TextEditingController emailController;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.username);
    emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() {
      isSaving = true;
    });

    // Validate inputs for Update Profiles
    final updatedUsername = usernameController.text;
    final updatedEmail = emailController.text;

    // Simulate API call (replace with real backend call)
    await Future.delayed(const Duration(seconds: 2));

    // TODO: Handle success/failure with real API response

    setState(() {
      isSaving = false;
    });

    // Optionally, show confirmation or go back
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cập nhật thành công')),
    );

    widget.onBack(); // go back to main profile screen
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
  clipBehavior: Clip.none,
  children: [
    // Gradient header
    Container(
      height: 125,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal, Colors.green],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
    const Center(
          child: Padding(
            padding: EdgeInsets.only(top:0),
            child: Text(
              "Chỉnh sửa thông tin",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
    ),
    // Profile image - half overlapping header
    Positioned(
      bottom: -50, // Half of radius (50) to make it overlap
      left: MediaQuery.of(context).size.width / 2 - 60,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: widget.imagePath.startsWith('http')
                ? NetworkImage(widget.imagePath)
                : AssetImage(widget.imagePath) as ImageProvider,
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.camera_alt,
                    size: 16, color: Colors.orange),
                onPressed: () {
                  // TODO: Add image picking logic
                },
              ),
            ),
          ),
        ],
      ),
    ),
  ],
),

 
          const SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên người dùng',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: isSaving ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    minimumSize: const Size(double.infinity, 0),
                  ),
                  child: isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Xác Nhận"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
