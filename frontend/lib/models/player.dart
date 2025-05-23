class Player {
  final String name;
  int level;
  final String rank;
  int rankPoint;
  final double elo;
  final String avatarPath;
  int score;

  Player({
    required this.name,
    required this.level,
    required this.rank,
    required this.rankPoint,
    required this.elo,
    required this.avatarPath,
    this.score = 0,
  });
}
