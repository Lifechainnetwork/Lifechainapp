import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_model.dart';

class NotificationService extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  final String _notificationsKey = 'user_notifications';
  bool _isInitialized = false;

  List<NotificationModel> get notifications => _notifications;
  List<NotificationModel> get unreadNotifications => 
      _notifications.where((notification) => !notification.isRead).toList();
  
  int get unreadCount => unreadNotifications.length;

  NotificationService() {
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    if (!_isInitialized) {
      // In a real app, you would load from local storage or a backend
      // For demo purposes, we'll use the demo notifications
      _notifications = NotificationModel.getDemoNotifications();
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> addNotification(NotificationModel notification) async {
    _notifications.insert(0, notification);
    await _saveNotifications();
    notifyListeners();
  }

  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      await _saveNotifications();
      notifyListeners();
    }
  }

  Future<void> markAllAsRead() async {
    _notifications = _notifications.map((notification) => 
      notification.copyWith(isRead: true)).toList();
    await _saveNotifications();
    notifyListeners();
  }

  Future<void> removeNotification(String notificationId) async {
    _notifications.removeWhere((notification) => notification.id == notificationId);
    await _saveNotifications();
    notifyListeners();
  }

  Future<void> clearAllNotifications() async {
    _notifications.clear();
    await _saveNotifications();
    notifyListeners();
  }

  // This would save to SharedPreferences or a database in a real app
  Future<void> _saveNotifications() async {
    // Implementation would depend on your storage strategy
    // For demo purposes, this is a placeholder
    final prefs = await SharedPreferences.getInstance();
    // In a real app, you would serialize the notifications list
    await prefs.setInt(_notificationsKey, _notifications.length);
  }

  // Method to simulate receiving a new notification (for testing)
  void simulateNewNotification() {
    final newNotification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'New Reward Available',
      message: 'You have a new reward waiting to be claimed!',
      timestamp: DateTime.now(),
      type: NotificationType.reward,
    );
    
    addNotification(newNotification);
  }
}
