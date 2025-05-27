import 'package:flutter/material.dart';
import 'profile_edit.dart';
import 'changepass.dart';
import 'ranked.dart';
import 'login/login.dart';

class ProfileScreen extends StatefulWidget {
  final bool resetToMain;
  final VoidCallback? onResetComplete;

  const ProfileScreen({
    super.key,
    this.resetToMain = false,
    this.onResetComplete,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? profileData;
  bool isLoading = true;

  String _currentSubscreen = 'main'; // 'main', 'update', 'password'

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.resetToMain && !oldWidget.resetToMain) {
      setState(() {
        _currentSubscreen = 'main';
      });

      // Notify parent that reset has completed
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onResetComplete?.call();
      });
    }
  }

  Future<void> fetchProfile() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      profileData = {
        'username': 'Sun',
        'email': 'sun@example.com',
        'level': 30,
        'rank': 'Tập sự',
        'elo': 76.87,
        'points': 75,
        'maxPoints': 100,
        'avatar': 'https://i.imgur.com/zL4Krbz.png',
      };
      isLoading = false;
    });
  }

  void _showSubscreen(String screen) {
    setState(() {
      _currentSubscreen = screen;
    });
  }

  @override
@override
Widget build(BuildContext context) {
  if (isLoading) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  final data = profileData!;

  // If subscreen is 'rank', return Scaffold without AppBar
  if (_currentSubscreen == 'rank') {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildSubscreen(data),
    );
  }

  // Otherwise, return Scaffold with AppBar
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      automaticallyImplyLeading: false,
      leading: _currentSubscreen != 'main'
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                _showSubscreen('main');
              },
            )
          : null,
      title: const Text(''),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        TextButton(
          onPressed: () {
            // Logout logic
            print("User logged out");
            Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.teal.withAlpha((0.7 * 255).toInt()),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Đăng Xuất',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 16),
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    ),
    body: _buildSubscreen(data),
  );
}


  Widget _buildSubscreen(Map<String, dynamic> data) {
    if (_currentSubscreen == 'update') {
      return EditProfileScreen(
        onBack: () => _showSubscreen('main'),
        username: data['username'],
        email: data['email'],
        imagePath: data['avatar'],
      );
    } else if (_currentSubscreen == 'password') {
        return EditPasswordScreen(
        onBack: () => _showSubscreen('main'),
        imagePath: data['avatar'],
      );
    } else if (_currentSubscreen == 'rank') {
      return RankedScreen(
        onBack: () => _showSubscreen('main'),
      );
    }

    // Main profile screen
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
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
            Positioned(
              bottom: -50,
              left: MediaQuery.of(context).size.width / 2 - 60,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(data['avatar']),
              ),
            ),
          ],
        ),
        const SizedBox(height: 60),
        Text(
          data['username'],
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          'Level ${data['level']}',
          style: const TextStyle(fontSize: 18, color: Colors.orange),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                _showSubscreen('rank');
              },
              icon: const Icon(Icons.leaderboard),
              label: const Text("Xếp hạng"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black87),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.lock),
              label: const Text("Thành tích"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Column(
          children: [
            const Icon(Icons.school, size: 80, color: Colors.teal),
            Text(
              data['rank'],
              style: const TextStyle(fontSize: 16, color: Colors.purple),
            ),
            Text(
              "${data['points']} điểm / ${data['maxPoints']}",
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              "Elo ${data['elo'].toStringAsFixed(2)}%",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () => _showSubscreen('update'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size(300, 50),
          ),
          child: const Text("Thay Đổi Thông Tin"),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => _showSubscreen('password'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size(300, 50),
          ),
          child: const Text("Đổi Mật Khẩu"),
        ),
      ],
    );
  }
}
