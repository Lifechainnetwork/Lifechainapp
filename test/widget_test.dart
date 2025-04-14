// Lifechain App Widget Tests
//
// This file contains widget tests for the Lifechain app components.
// These tests verify that our UI components render correctly and
// respond to user interactions as expected.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

// Import app components
import 'package:my_app/widgets/custom_card.dart';
import 'package:my_app/widgets/custom_button.dart';
import 'package:my_app/widgets/animated_button.dart';
import 'package:my_app/widgets/error_widget.dart';
import 'package:my_app/theme/theme_provider.dart';
import 'package:my_app/services/notification_service.dart';
import 'package:my_app/models/notification_model.dart';

// Mock providers for testing
class MockThemeProvider extends ChangeNotifier implements ThemeProvider {
  bool _isDarkMode = true;
  
  @override
  bool get isDarkMode => _isDarkMode;
  
  @override
  ThemeData get currentTheme => _isDarkMode ? ThemeData.dark() : ThemeData.light();
  
  @override
  ThemeData get darkTheme => ThemeData.dark();
  
  @override
  ThemeData get lightTheme => ThemeData.light();
  
  @override
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  
  @override
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class MockNotificationService extends ChangeNotifier implements NotificationService {
  List<NotificationModel> _notifications = [];
  
  @override
  List<NotificationModel> get notifications => _notifications;
  
  @override
  List<NotificationModel> get unreadNotifications => 
      _notifications.where((notification) => !notification.isRead).toList();
  
  @override
  int get unreadCount => unreadNotifications.length;
  
  @override
  Future<void> addNotification(NotificationModel notification) async {
    _notifications.insert(0, notification);
    notifyListeners();
  }
  
  @override
  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }
  
  @override
  Future<void> markAllAsRead() async {
    _notifications = _notifications.map((notification) => 
      notification.copyWith(isRead: true)).toList();
    notifyListeners();
  }
  
  @override
  Future<void> removeNotification(String notificationId) async {
    _notifications.removeWhere((notification) => notification.id == notificationId);
    notifyListeners();
  }
  
  @override
  Future<void> clearAllNotifications() async {
    _notifications.clear();
    notifyListeners();
  }
  
  @override
  void simulateNewNotification() {
    final newNotification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Test Notification',
      message: 'This is a test notification',
      timestamp: DateTime.now(),
      type: NotificationType.system,
    );
    
    addNotification(newNotification);
  }
}

void main() {
  group('CustomCard Widget Tests', () {
    testWidgets('CustomCard renders correctly', (WidgetTester tester) async {
      // Build CustomCard widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomCard(
              child: const Text('Test Card'),
            ),
          ),
        ),
      );

      // Verify the card and its content are rendered
      expect(find.byType(CustomCard), findsOneWidget);
      expect(find.text('Test Card'), findsOneWidget);
    });
  });

  group('CustomButton Widget Tests', () {
    testWidgets('CustomButton renders correctly and responds to tap', (WidgetTester tester) async {
      bool buttonPressed = false;
      
      // Build CustomButton widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Test Button',
              onPressed: () {
                buttonPressed = true;
              },
            ),
          ),
        ),
      );

      // Verify the button is rendered
      expect(find.byType(CustomButton), findsOneWidget);
      expect(find.text('Test Button'), findsOneWidget);
      
      // Tap the button and verify the callback was called
      await tester.tap(find.byType(CustomButton));
      expect(buttonPressed, true);
    });
  });

  group('AnimatedButton Widget Tests', () {
    testWidgets('AnimatedButton renders correctly', (WidgetTester tester) async {
      // Build AnimatedButton widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedButton(
              text: 'Animated Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      // Verify the button is rendered
      expect(find.byType(AnimatedButton), findsOneWidget);
      expect(find.text('Animated Button'), findsOneWidget);
    });
    
    testWidgets('AnimatedButton shows loading state', (WidgetTester tester) async {
      // Build AnimatedButton widget with loading state
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedButton(
              text: 'Loading Button',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      // Verify the loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading Button'), findsNothing);
    });
  });

  group('ErrorWidget Tests', () {
    testWidgets('CustomErrorWidget renders correctly', (WidgetTester tester) async {
      // Build CustomErrorWidget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomErrorWidget(
              message: 'Error Message',
              details: 'Error Details',
              onRetry: () {},
            ),
          ),
        ),
      );

      // Verify the error widget content
      expect(find.text('Error Message'), findsOneWidget);
      expect(find.text('Error Details'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
    });
  });

  group('ThemeProvider Tests', () {
    testWidgets('ThemeProvider toggles theme correctly', (WidgetTester tester) async {
      final mockThemeProvider = MockThemeProvider();
      
      // Build a widget with ThemeProvider
      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeProvider>.value(
          value: mockThemeProvider,
          child: Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return MaterialApp(
                theme: themeProvider.currentTheme,
                home: Scaffold(
                  body: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        themeProvider.toggleTheme();
                      },
                      child: Text(themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode'),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Verify initial state
      expect(find.text('Dark Mode'), findsOneWidget);
      
      // Tap to toggle theme
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      
      // Verify theme was toggled
      expect(mockThemeProvider.isDarkMode, false);
    });
  });

  group('NotificationService Tests', () {
    testWidgets('NotificationService adds and removes notifications', (WidgetTester tester) async {
      final mockNotificationService = MockNotificationService();
      
      // Add a test notification
      await mockNotificationService.addNotification(
        NotificationModel(
          id: '1',
          title: 'Test Notification',
          message: 'This is a test',
          timestamp: DateTime.now(),
          type: NotificationType.system,
        ),
      );
      
      // Verify notification was added
      expect(mockNotificationService.notifications.length, 1);
      expect(mockNotificationService.unreadCount, 1);
      
      // Mark notification as read
      await mockNotificationService.markAsRead('1');
      
      // Verify notification was marked as read
      expect(mockNotificationService.unreadCount, 0);
      
      // Remove notification
      await mockNotificationService.removeNotification('1');
      
      // Verify notification was removed
      expect(mockNotificationService.notifications.length, 0);
    });
  });
}
