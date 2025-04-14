class Quest {
  final String title;
  final String description;
  final DateTime date;
  final bool isCompleted;
  final double reward;

  Quest({
    required this.title,
    required this.description,
    required this.date,
    required this.isCompleted,
    required this.reward,
  });

  static List<Quest> getDemoQuests() {
    return [
      Quest(
        title: 'Introduce friends and assist friends with KYC',
        description: 'Invite your friends to join the platform and help them complete KYC verification',
        date: DateTime(2024, 5, 12),
        isCompleted: true,
        reward: 0,
      ),
      Quest(
        title: 'Successfully introduced by F1s in your network',
        description: 'You were successfully introduced by a first-level connection',
        date: DateTime(2024, 5, 12),
        isCompleted: true,
        reward: 0,
      ),
      Quest(
        title: 'Complete the mission milestone',
        description: 'Finish all required tasks in the current mission',
        date: DateTime(2024, 5, 12),
        isCompleted: false,
        reward: 0,
      ),
      Quest(
        title: 'Continuous operation 7 days',
        description: 'Keep your account active for 7 consecutive days',
        date: DateTime(2024, 5, 12),
        isCompleted: false,
        reward: 3.00,
      ),
      Quest(
        title: 'Top 1000 miners with highest hashrate',
        description: 'Maintain your mining performance to be among the top 1000 miners',
        date: DateTime(2024, 5, 12),
        isCompleted: false,
        reward: 0,
      ),
    ];
  }
}
