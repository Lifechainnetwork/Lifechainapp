import 'package:flutter/material.dart';

enum NotificationType {
  transaction,
  reward,
  staking,
  farming,
  mining,
  governance,
  system,
  promotion
}

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;
  final String? actionLink;
  final Map<String, dynamic>? additionalData;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.actionLink,
    this.additionalData,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    NotificationType? type,
    bool? isRead,
    String? actionLink,
    Map<String, dynamic>? additionalData,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      actionLink: actionLink ?? this.actionLink,
      additionalData: additionalData ?? this.additionalData,
    );
  }

  IconData get icon {
    switch (type) {
      case NotificationType.transaction:
        return Icons.swap_horiz;
      case NotificationType.reward:
        return Icons.card_giftcard;
      case NotificationType.staking:
        return Icons.account_balance;
      case NotificationType.farming:
        return Icons.trending_up;
      case NotificationType.mining:
        return Icons.memory;
      case NotificationType.governance:
        return Icons.how_to_vote;
      case NotificationType.system:
        return Icons.info;
      case NotificationType.promotion:
        return Icons.campaign;
    }
  }

  Color get color {
    switch (type) {
      case NotificationType.transaction:
        return Colors.blue;
      case NotificationType.reward:
        return Colors.amber;
      case NotificationType.staking:
        return Colors.orange;
      case NotificationType.farming:
        return Colors.green;
      case NotificationType.mining:
        return Colors.indigo;
      case NotificationType.governance:
        return Colors.purple;
      case NotificationType.system:
        return Colors.grey;
      case NotificationType.promotion:
        return Colors.red;
    }
  }

  // Demo notifications for testing
  static List<NotificationModel> getDemoNotifications() {
    return [
      NotificationModel(
        id: '1',
        title: 'Mining Reward Received',
        message: 'You have received 5 LCN as a mining reward.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        type: NotificationType.mining,
      ),
      NotificationModel(
        id: '2',
        title: 'Staking Reward',
        message: 'Your staking position has generated 2.5 LCN in rewards.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.staking,
      ),
      NotificationModel(
        id: '3',
        title: 'New Governance Proposal',
        message: 'A new proposal "LCN Tokenomics Update" has been submitted for voting.',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        type: NotificationType.governance,
      ),
      NotificationModel(
        id: '4',
        title: 'Transaction Confirmed',
        message: 'Your transaction of 10 LCN has been confirmed.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.transaction,
        isRead: true,
      ),
      NotificationModel(
        id: '5',
        title: 'New Farming Pool Available',
        message: 'A new high-yield farming pool is now available with 120% APY.',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        type: NotificationType.farming,
        isRead: true,
      ),
      NotificationModel(
        id: '6',
        title: 'Limited Time Offer',
        message: 'Stake LCN now and get 10% bonus rewards for the next 7 days!',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        type: NotificationType.promotion,
        isRead: true,
      ),
    ];
  }
}
