import 'package:flutter/material.dart';

class GoalModel {
  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime deadline;
  final String status;
  final String icon;
  final String color;
  final DateTime createdAt;

  int currentStreak;
  int longestStreak;
  DateTime? lastDepositDate;

  GoalModel({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
    required this.status,
    required this.icon,
    required this.color,
    required this.createdAt,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastDepositDate,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['_id'],
      name: json['name'],
      targetAmount: (json['targetAmount'] as num).toDouble(),
      currentAmount: (json['currentAmount'] as num).toDouble(),
      deadline: DateTime.parse(json['deadline']),
      status: json['status'],
      icon: json['icon'] ?? 'savings',
      color: json['color'] ?? '#1E88E5',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now().subtract(const Duration(days: 30)), // Fallback if missing
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      lastDepositDate: json['lastDepositDate'] != null ? DateTime.parse(json['lastDepositDate']) : null,
    );
  }

  double get progressPercentage {
    if (targetAmount <= 0) return 0;
    return (currentAmount / targetAmount) * 100;
  }

  String get pigTier {
    final progress = progressPercentage;
    if (progress < 25) return "Heo sơ sinh";
    if (progress < 50) return "Heo mới lớn";
    if (progress < 75) return "Heo trưởng thành";
    if (progress < 100) return "Heo vàng";
    return "Siêu heo";
  }

  IconData get iconData {
    switch (icon) {
      case 'flight_takeoff': return Icons.flight_takeoff;
      case 'directions_car': return Icons.directions_car;
      case 'home_outlined': return Icons.home_outlined;
      case 'laptop_mac': return Icons.laptop_mac;
      case 'favorite_outline': return Icons.favorite_outline;
      case 'celebration': return Icons.celebration;
      case 'school_outlined': return Icons.school_outlined;
      case 'fitness_center': return Icons.fitness_center;
      case 'restaurant': return Icons.restaurant;
      case 'shopping_bag_outlined': return Icons.shopping_bag_outlined;
      case 'more_horiz': return Icons.more_horiz;
      case 'savings':
      default:
        return Icons.savings;
    }
  }
}
