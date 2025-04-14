class StakeData {
  final int totalParticipants;
  final int totalSubmissions;
  final double totalLcnStaked;
  final double totalProfit;
  final double userLcnStaked;
  final double userProfit;

  StakeData({
    required this.totalParticipants,
    required this.totalSubmissions,
    required this.totalLcnStaked,
    required this.totalProfit,
    required this.userLcnStaked,
    required this.userProfit,
  });

  static StakeData demoData() {
    return StakeData(
      totalParticipants: 156206,
      totalSubmissions: 252975,
      totalLcnStaked: 56376359,
      totalProfit: 1353538,
      userLcnStaked: 0,
      userProfit: 0,
    );
  }
}
