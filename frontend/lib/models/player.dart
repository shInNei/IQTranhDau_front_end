import 'dart:math';

// class Player {
//   final int id;
//   final String name;
//   int level;
//   final String rank;
//   int rankPoint;
//   double elo;
//   final String avatarPath;
//   int score;

//   Player({
//     required this.id,
//     required this.name,
//     this.level = 0,
//     this.rank = '',
//     this.rankPoint = 0,
//     this.elo = 0.0,
//     this.avatarPath = '',
//     this.score = 0,
//   });

//   factory Player.fromJson(Map<String, dynamic> json) {
//     return Player(
//       id: json['id'] as int,
//       name: json['name'] as String,
//       level: json['level'] ?? 0,
//       rank: json['rank'] ?? '',
//       rankPoint: json['rankPoint'] ?? 0,
//       elo: (json['elo'] ?? 0.0).toDouble(),
//       avatarPath: json['avatarPath'] ?? '',
//       score: json['score'] ?? 0,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'level': level,
//       'rank': rank,
//       'rankPoint': rankPoint,
//       'elo': elo,
//       'avatarPath': avatarPath,
//       'score': score,
//     };
//   }
// }

// New Player class that suit backend
class Player {
  final int id;
  final String name;
  int level;
  String rank;
  int rankPoint;
  int elo;
  String avatarPath;
  int score;

  Player({
    required this.id,
    required this.name,
    this.level = 0,
    this.rank = '',
    this.rankPoint = 0,
    this.elo = 0,
    this.avatarPath = '',
    this.score = 0,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as int,
      name: json['name'] as String,
      level: json['level'] ?? 0,
      rank: json['rank'] ?? '',
      rankPoint: json['rankPoint'] ?? 0,
      elo: json['elo'] ?? 0,
      avatarPath: json['avatarPath'] ?? '',
      score: json['score'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'rank': rank,
      'rankPoint': rankPoint,
      'elo': elo,
      'avatarPath': avatarPath,
      'score': score,
    };
  }
}
