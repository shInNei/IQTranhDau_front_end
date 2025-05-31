import 'package:flutter/material.dart';
import 'profile_edit.dart';
import 'changepass.dart';
import 'ranked.dart';
import 'login/login.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'models/player.dart';
import 'services/APICall.dart';
import 'package:frontend/constants.dart';
import 'services/auth_service.dart';
import 'models/playerutils.dart';


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
  Player? profileData;
  bool isLoading = true;

  String _currentSubscreen = 'main'; // 'main', 'update', 'password'

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    fetchProfile(context);
  });
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

  Future<void> fetchProfile(BuildContext context) async {


    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    // final currentUser = userProvider.currentUser;

    // if (currentUser == null) {
    //   throw Exception('No user is currently logged in');
    // }
    
    // print(currentUser.avatarPath);

    final api = ApiService(baseUrl: SERVER_URL, token: await AuthService.getToken());

    try {
      final user = await api.getCurrentUser();
      print(user);
      
      setState(() {
      profileData = user;
      isLoading = false;
      print('Profile data fetched successfully: $profileData');
    });
    } catch (e) {
      print('Error fetching profile: $e');
      setState(() {
        isLoading = false;
        profileData = null; // Handle error case
      });
    }

    await Future.delayed(const Duration(seconds: 2));
    // Simulate fetching profile data from an API or database

    // setState(() {
    //   profileData = currentUser;
    //   isLoading = false;
    // });
  }

  void _showSubscreen(String screen) {
    setState(() {
      _currentSubscreen = screen;
    });
  }

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
            AuthService.logout();
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


  Widget _buildSubscreen(Player data) {
    final rank = PlayerUtils.getRankFromElo(data.elo);

    if (_currentSubscreen == 'update') {
      return EditProfileScreen(
        onBack: () => _showSubscreen('main'),
        username: data.name,
        email: data.email,
        imagePath: data.avatarUrl,
      );
    } else if (_currentSubscreen == 'password') {
        return EditPasswordScreen(
        onBack: () => _showSubscreen('main'),
        imagePath: data.avatarUrl,
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
                backgroundImage: NetworkImage(data.avatarUrl),
              ),
            ),
          ],
        ),
        const SizedBox(height: 60),
        Text(
          data.name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          'Level ${data.exp}',
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
              rank,
              style: TextStyle(fontSize: 20, color: PlayerUtils.getRankColor(rank)),
            ),
            // Text(
            //   "${data['points']} điểm / ${data['maxPoints']}",
            //   style: const TextStyle(fontSize: 14),
            // ),
            Text(
              "Elo ${data.elo}",
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
