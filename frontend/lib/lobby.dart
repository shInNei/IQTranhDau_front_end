import 'package:flutter/material.dart';
import './data/data.dart';
import './models/room.dart';
import 'room.dart';
import 'home_rank.dart';

class LobbyScreen extends StatefulWidget {
  final bool autoCreate;
  const LobbyScreen({super.key, this.autoCreate = false});
  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  String _currentSubscreen = 'lobby';

  void _showSubscreen(String screen) {
    setState(() {
      _currentSubscreen = screen;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.autoCreate) {
      // chờ build xong mới push RoomScreen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _createRoom();
      });
    }
  }

  void _createRoom() {
    final newRoom = Room(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      host: currentUser,
      opponent: null,
    );
    rooms.insert(0, newRoom);
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => RoomScreen(room: newRoom)));
  }

  void _enterByCode() {
    showDialog(
      context: context,
      builder: (ctx) {
        final ctrl = TextEditingController();
        return AlertDialog(
          title: const Text('Nhập mã phòng'),
          content: TextField(
            controller: ctrl,
            decoration: const InputDecoration(hintText: 'ID phòng'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                final code = ctrl.text.trim();
                final found = rooms.firstWhere(
                  (r) => r.id == code,
                  orElse: () => Room(id: '', host: currentUser),
                );
                Navigator.pop(ctx);
                if (found.id.isNotEmpty) {
                  // giả lập join
                  final joined = Room(
                    id: found.id,
                    host: found.host,
                    opponent: currentUser,
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => RoomScreen(room: joined)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Không tìm thấy phòng')),
                  );
                }
              },
              child: const Text('Vào'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // scaffold sẽ tạo sẵn Material cho toàn screen
      backgroundColor: Colors.white,
      // nội dung chính
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3E7FF), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 8),
                // Hàng tiêu đề + count + nút thoát
                Row(
                  children: [
                    const Text(
                      'Sảnh chờ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${rooms.length}/200',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    // nút thoát
                    IconButton(
                      icon: const Icon(Icons.close, size: 32),
                      tooltip: 'Đóng sảnh chờ',
                      onPressed: () => _showSubscreen('ranked'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // List phòng
                Expanded(
                  child: ListView.separated(
                    itemCount: rooms.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) {
                      final r = rooms[i];
                      return InkWell(
                        onTap: () {
                          if (r.opponent == null) {
                            final joined = Room(
                              id: r.id,
                              host: r.host,
                              opponent: currentUser,
                            );
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => RoomScreen(room: joined),
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder:
                                  (ctx) => AlertDialog(
                                    title: const Text('Phòng đã đầy'),
                                    content: const Text(
                                      'Phòng này đã có đủ người chơi.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text('Đóng'),
                                      ),
                                    ],
                                  ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color:
                                      r.opponent == null
                                          ? Colors.green
                                          : Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(r.id, style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),
                // Buttons tạo/nhập phòng
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _createRoom,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFF1C1C3A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Ensure text color is white
                          ),
                        ),
                        child: const Text(
                          'Tạo phòng',
                          style: TextStyle(
                            color: Colors.white,
                          ), // Explicitly set text color
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ), // Increased spacing to match the screenshot
                    OutlinedButton(
                      onPressed: _enterByCode,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 12,
                        ),
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ), // Add border
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color:
                              Colors
                                  .black, // Ensure text color contrasts with background
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit,
                            color: Colors.black, // Icon color to match text
                            size: 24,
                          ),
                          SizedBox(width: 8), // Space between icon and text
                          Text(
                            'Nhập mã',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
