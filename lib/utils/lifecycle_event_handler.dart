import 'package:flutter/material.dart';

/// A utility class that listens to app lifecycle events
/// and provides callbacks for handling those events.
class LifecycleEventHandler extends WidgetsBindingObserver {
  final Future<void> Function()? resumeCallBack;
  final Future<void> Function()? suspendingCallBack;
  final Future<void> Function()? inactiveCallBack;
  final Future<void> Function()? detachedCallBack;
  final Future<void> Function()? hiddenCallBack;
  final Future<void> Function()? pausedCallBack;

  LifecycleEventHandler({
    this.resumeCallBack,
    this.suspendingCallBack,
    this.inactiveCallBack,
    this.detachedCallBack,
    this.hiddenCallBack,
    this.pausedCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        // App becomes visible and interactive again
        if (resumeCallBack != null) {
          await resumeCallBack!();
        }
        break;
      case AppLifecycleState.inactive:
        // App loses focus, but still visible
        // Examples: phone call coming in, app switch dialog
        if (inactiveCallBack != null) {
          await inactiveCallBack!();
        }
        break;
      case AppLifecycleState.paused:
        // App completely hidden but still in memory
        // App is in background
        if (pausedCallBack != null) {
          await pausedCallBack!();
        }
        // Since suspending is deprecated, we handle it with paused
        if (suspendingCallBack != null) {
          await suspendingCallBack!();
        }
        break;
      case AppLifecycleState.detached:
        // App is suspended, possibly terminated soon
        // e.g., when a NavigatorPage is dismissed on iOS
        if (detachedCallBack != null) {
          await detachedCallBack!();
        }
        break;
      default:
        // Handle newer AppLifecycleState values (like hidden) gracefully
        final stateString = state.toString();
        if (stateString == 'AppLifecycleState.hidden' && hiddenCallBack != null) {
          await hiddenCallBack!();
        }
        break;
    }
  }
}
