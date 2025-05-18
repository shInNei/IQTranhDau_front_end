import '../models/player.dart';
import '../models/room.dart';

final players = <Player>[
  Player(
    name: 'Sun',
    level: 30,
    rank: 'Tập sự',
    elo: 76.87,
    avatarPath: 'assets/images/sun.jpg',
  ),
  Player(
    name: 'Top1',
    level: 90,
    rank: 'Master',
    elo: 100.0,
    avatarPath: 'assets/images/avatar.jpg',
  ),
  Player(
    name: 'Mèo Lười',
    level: 45,
    rank: 'Thách đấu',
    elo: 92.3,
    avatarPath: 'assets/images/meo_luoi.jpg',
  ),
  Player(
    name: 'Bạch Hổ',
    level: 60,
    rank: 'Cao thủ',
    elo: 85.5,
    avatarPath: 'assets/images/bach_ho.jpg',
  ),
];

/// Giả định user đang đăng nhập
final currentUser = players[0];

/// Danh sách phòng sẵn có
final rooms = <Room>[
  Room(id: '2001222', host: players[2], opponent: null),
  Room(id: '20902112', host: players[0], opponent: players[3]),
  Room(id: '20902111', host: players[3], opponent: null),
  Room(id: '20901101', host: players[0], opponent: null),
  Room(id: '20901100', host: players[2], opponent: null),
  Room(id: '2080229', host: players[1], opponent: null),
  Room(id: '2070458', host: players[3], opponent: null),
  Room(id: '2050259', host: players[0], opponent: null),
];
