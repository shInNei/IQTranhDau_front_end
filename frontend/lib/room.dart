import 'package:flutter/material.dart';
import 'data/data.dart';
import './models/player.dart';
import './models/room.dart';

class RoomScreen extends StatelessWidget {
  final Room room;
  const RoomScreen({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final isHost = room.host.name == currentUser.name;
    final hasOpponent = room.opponent != null;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE3E7FF), Color(0xFFFFFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Header
                Row(
                  children: [
                    const Text(
                      'Phòng chờ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 66, 49, 5),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, size: 32),
                      onPressed: () {
                        // If the user is the host, remove the room from the rooms list
                        if (isHost) {
                          rooms.removeWhere((r) => r.id == room.id);
                        }
                        // Navigate back to LobbyScreen
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ID: ${room.id}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Host card
                PlayerCard(player: room.host),

                const SizedBox(height: 24),
                // Opponent or placeholder
                if (hasOpponent)
                  Stack(
                    children: [
                      PlayerCard(player: room.opponent!),
                      if (isHost)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              // Host removes opponent (update room in the list)
                              final updatedRoom = Room(
                                id: room.id,
                                host: room.host,
                                opponent: null, // Remove opponent
                              );
                              final roomIndex = rooms.indexWhere(
                                (r) => r.id == room.id,
                              );
                              if (roomIndex != -1) {
                                rooms[roomIndex] = updatedRoom;
                              }
                              // Navigate back and refresh the RoomScreen with updated room
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RoomScreen(room: updatedRoom),
                                ),
                              );
                            },
                            child: const CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 12,
                              child: Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  )
                else
                  PlaceholderCard(),

                const Spacer(),

                // Button dưới cùng
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          hasOpponent
                              ? (isHost ? Colors.black : Colors.blueGrey)
                              : Colors.blueGrey,
                    ),
                    child: Text(
                      hasOpponent
                          ? (isHost ? '⚔️ Bắt đầu' : 'Chờ chủ phòng bắt đầu')
                          : 'Đang chờ đối thủ...',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
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

/// Widget dùng chung để render 1 Player card
class PlayerCard extends StatelessWidget {
  final Player player;
  const PlayerCard({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(player.avatarPath),
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Căn giữa theo chiều ngang
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    player.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Level ${player.level}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    player.rank,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ELO ${player.elo.toStringAsFixed(2)}%',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder khi chưa có opponent
class PlaceholderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                greyBar(width: 120),
                const SizedBox(height: 8),
                greyBar(width: 180),
                const SizedBox(height: 8),
                greyBar(width: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget greyBar({required double width}) =>
      Container(width: width, height: 16, color: Colors.grey.shade300);
}
