import 'levelprogress.dart';
import 'package:flutter/material.dart';

class PlayerUtils {
  // Define level thresholds (example: linear, or modify as needed)
  static int getLevelFromExp(int exp) {
    return (exp / 100).floor(); // 100 exp per level
  }

  static LevelProgress getLevelProgress(int exp) {
    int level = getLevelFromExp(exp);
    int currentExp = exp;
    int nextLevelExp = (level + 1) * 100;
    int prevLevelExp = level * 100;
    int progressExp = currentExp - prevLevelExp;
    int levelExpRange = nextLevelExp - prevLevelExp;
    int percent = ((progressExp / levelExpRange) * 100).floor();

    return LevelProgress(
      currentExp: progressExp,
      nextLevelExp: nextLevelExp - prevLevelExp,
      percent: percent,
    );
  }

  // Elo to rank mapping
  static String getRankFromElo(int elo) {
    if (elo >= 2500) return 'Thách đấu';
    if (elo >= 2000) return 'Cao thủ';
    if (elo >= 1500) return 'Kim cương';
    if (elo >= 1200) return 'Bạch kim';
    if (elo >= 1000) return 'Vàng';
    if (elo >= 800) return 'Bạc';
    if (elo >= 600) return 'Đồng';
    return 'Tập sự'; // beginner
  }

  static Color getRankColor(String rank) {
    switch (rank) {
      case 'Thách đấu':
        return Colors.redAccent;
      case 'Cao thủ':
        return Colors.purple;
      case 'Kim cương':
        return Colors.tealAccent;
      case 'Bạch kim':
        return Colors.lightBlueAccent;
      case 'Vàng':
        return Colors.yellow;
      case 'Bạc':
        return Colors.grey;
      case 'Đồng':
        return Colors.brown;
      case 'Tập sự':
        return Colors.green;
      default:
        return Colors.black;
    }
  }
}

