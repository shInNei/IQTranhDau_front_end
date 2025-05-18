import 'player.dart';

// 3. Model Room, mỗi Room luôn có host, có thể có hoặc chưa có opponent
class Room {
  final String id;
  final Player host;
  final Player? opponent;

  Room({required this.id, required this.host, this.opponent});
}
