import 'package:flutter/material.dart';

class HomeRankScreen extends StatelessWidget {
  const HomeRankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Đấu Xếp Hạng',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/logo_2.png',
                height: 150,
              ),
              const SizedBox(height: 100),
              SizedBox(
                width: 240,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF1C1C3A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {},
                  child: const Text('Tham gia phòng', style: TextStyle(color: Colors.white),),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 240,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF1C1C3A),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {},
                  child: const Text('Tìm Trận', style: TextStyle(color: Colors.white),),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 240,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF1C1C3A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {},
                  child: const Text('Tạo phòng', style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 80, // lowered from 40
          right: 16,
          child: GestureDetector(
            onTap: () {
              print('Rank clicked');
            },
            child: Row(
              children: [
                const Icon(Icons.emoji_events, color: Colors.orange),
                const SizedBox(width: 4),
                Text(
                  'Bảng Xếp Hạng',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.purple.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
