class GoalModel {
  final String id;
  final String title;
  final double targetAmount;
  double currentAmount;
  final DateTime deadline;

  GoalModel({
    required this.id,
    required this.title,
    required this.targetAmount,
    this.currentAmount = 0.0,
    required this.deadline,
  });

  double get percentage {
    if (targetAmount <= 0) return 0.0;
    final p = currentAmount / targetAmount;
    return p > 1.0 ? 1.0 : p;
  }

  bool get isCompleted => currentAmount >= targetAmount;

  int get daysLeft {
    final difference = deadline.difference(DateTime.now()).inDays;
    return difference < 0 ? 0 : difference;
  }
}