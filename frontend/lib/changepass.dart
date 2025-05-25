import 'package:flutter/material.dart';

class EditPasswordScreen extends StatefulWidget {
  final VoidCallback onBack;
  final String imagePath;

  const EditPasswordScreen({
    super.key,
    required this.onBack,
    required this.imagePath,
  });

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool isSaving = false;
  bool showCurrentPassword = false;
  bool showNewPassword = false;
  String? currentPasswordError;

  final String hardcodedPassword = "password123"; // simulate stored password

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final currentPassword = currentPasswordController.text;
    final newPassword = newPasswordController.text;

    // Validate current password
    if (currentPassword != hardcodedPassword) {
      setState(() {
        currentPasswordError = "Mật khẩu hiện tại không đúng";
      });
      return;
    } else {
      setState(() {
        currentPasswordError = null; // clear error
        isSaving = true;
      });
    }

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cập nhật mật khẩu thành công')),
    );

    widget.onBack(); // Return to previous screen
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Header
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
                  padding: EdgeInsets.only(top: 40),
                  child: Text(
                    "Đổi mật khẩu",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Avatar
              Positioned(
                bottom: -50,
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
                  controller: currentPasswordController,
                  obscureText: !showCurrentPassword,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu hiện tại',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        showCurrentPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          showCurrentPassword = !showCurrentPassword;
                        });
                      },
                    ),
                    errorText: currentPasswordError,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: newPasswordController,
                  obscureText: !showNewPassword,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu mới',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        showNewPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          showNewPassword = !showNewPassword;
                        });
                      },
                    ),
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
          ),
        ],
      ),
    );
  }
}
