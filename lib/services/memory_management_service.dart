import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

// Memory pressure levels
enum MemoryPressure { normal, moderate, critical }

// Cache item class to store typed data
class CacheItem {
  final dynamic value;
  final int size;
  final int timestamp;

  CacheItem({required this.value, required this.size, required this.timestamp});

  CacheItem copyWith({int? newTimestamp}) {
    return CacheItem(
      value: value,
      size: size,
      timestamp: newTimestamp ?? timestamp,
    );
  }
}

class MemoryManagementService {
  // Singleton pattern
  static final MemoryManagementService _instance =
      MemoryManagementService._internal();
  factory MemoryManagementService() => _instance;
  MemoryManagementService._internal();

  // Cache constants
  static const int MAX_IMAGE_CACHE_SIZE = 50 * 1024 * 1024; // 50 MB
  static const int MAX_CACHE_ENTRIES = 100;
  static const Duration CACHE_EXPIRY = Duration(days: 1);

  // Background tasks
  final List<Timer> _activeTimers = [];
  bool _isLowPowerMode = false;
  bool _isBackgroundRestricted = false;

  // Memory pressure status
  MemoryPressure _currentMemoryPressure = MemoryPressure.normal;

  // Cache management
  DateTime _lastCacheCleanup = DateTime.now();
  int _estimatedMemoryUsage = 0;
  final Map<String, CacheItem> _cache = {};

  // Getters for external access
  bool get isLowPowerMode => _isLowPowerMode;
  bool get isBackgroundRestricted => _isBackgroundRestricted;
  MemoryPressure get currentMemoryPressure => _currentMemoryPressure;

  // Initialize service
  Future<void> initialize() async {
    // Set image cache size limits
    PaintingBinding.instance.imageCache.maximumSize = MAX_CACHE_ENTRIES;
    PaintingBinding.instance.imageCache.maximumSizeBytes = MAX_IMAGE_CACHE_SIZE;

    // Check system power mode
    await _checkPowerMode();

    // Schedule periodic cleanup
    _schedulePeriodicCleanup();

    // Register memory pressure listener
    _setupMemoryPressureDetection();
  }

  // Power mode detection - important for battery optimization
  Future<void> _checkPowerMode() async {
    try {
      const platform = MethodChannel(
        'com.lifechain.wallet/battery_optimization',
      );
      _isLowPowerMode = await platform.invokeMethod('isLowPowerMode') ?? false;
      _isBackgroundRestricted =
          await platform.invokeMethod('isBackgroundRestricted') ?? false;
    } catch (e) {
      debugPrint('Failed to get power mode: $e');
      _isLowPowerMode = false;
      _isBackgroundRestricted = false;
    }
  }

  // Memory pressure detection
  void _setupMemoryPressureDetection() {
    const channel = MethodChannel('com.lifechain.wallet/memory_pressure');
    channel.setMethodCallHandler((call) async {
      if (call.method == 'onMemoryPressure') {
        final String level = call.arguments['level'];
        switch (level) {
          case 'moderate':
            _currentMemoryPressure = MemoryPressure.moderate;
            _handleModeratePressure();
            break;
          case 'critical':
            _currentMemoryPressure = MemoryPressure.critical;
            _handleCriticalPressure();
            break;
          default:
            _currentMemoryPressure = MemoryPressure.normal;
        }
      }
      return null;
    });
  }

  // Image cache management with smarter caching policy
  void clearImageCache() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
    _lastCacheCleanup = DateTime.now();
  }

  // Partial image cache clearing (only old/unused images)
  void trimImageCache() {
    // Keep track of cache size before and after to measure effectiveness
    final beforeSize = PaintingBinding.instance.imageCache.currentSizeBytes;

    // Only clear non-live images
    PaintingBinding.instance.imageCache.clear();

    final afterSize = PaintingBinding.instance.imageCache.currentSizeBytes;
    debugPrint('Trimmed image cache: ${beforeSize - afterSize} bytes freed');
  }

  // Memory pressure handlers
  void _handleModeratePressure() {
    debugPrint('Moderate memory pressure detected');
    // Free non-essential caches
    trimImageCache();
    _clearOldCachedFiles();

    // Adjust image quality
    _downgradeImageQuality();
  }

  void _handleCriticalPressure() {
    debugPrint('Critical memory pressure detected');
    // Aggressive cache clearing
    clearImageCache();
    _clearAllCachedFiles();
    _cache.clear();
    _estimatedMemoryUsage = 0;

    // Cancel non-essential background tasks
    _cancelBackgroundTasks();
  }

  // Background task management
  Timer scheduleBackgroundTask(
    Duration duration,
    void Function() callback, {
    bool criticalTask = false,
  }) {
    // Don't schedule non-critical tasks in low power mode
    if (_isLowPowerMode && !criticalTask) {
      debugPrint('Skipping non-critical background task in low power mode');
      // Return a dummy timer that does nothing
      return Timer(Duration.zero, () {});
    }

    late Timer timer;
    timer = Timer(duration, () {
      // Check if app is still in a good state to perform work
      if (!_isBackgroundRestricted || criticalTask) {
        callback();
      } else {
        debugPrint('Skipping background task due to background restrictions');
      }

      // Remove from active timers
      _activeTimers.remove(timer);
    });

    _activeTimers.add(timer);
    return timer;
  }

  // Cancel a specific background task
  void cancelBackgroundTask(Timer timer) {
    timer.cancel();
    _activeTimers.remove(timer);
  }

  // Cancel all non-critical background tasks
  void _cancelBackgroundTasks() {
    for (var timer in List.from(_activeTimers)) {
      timer.cancel();
    }
    _activeTimers.clear();
  }

  // Periodic cleanup of cached resources
  void _schedulePeriodicCleanup() {
    const cleanupInterval = Duration(minutes: 30);
    scheduleBackgroundTask(cleanupInterval, () {
      _performPeriodicCleanup();
      _schedulePeriodicCleanup(); // Schedule next cleanup
    }, criticalTask: true);
  }

  Future<void> _performPeriodicCleanup() async {
    // Only clean up if last cleanup was more than 6 hours ago
    // to avoid too frequent disk operations
    final now = DateTime.now();
    if (now.difference(_lastCacheCleanup) > const Duration(hours: 6)) {
      await _clearOldCachedFiles();
      _lastCacheCleanup = now;
    }

    // Trim memory cache based on usage pattern
    _trimCache();
  }

  // File caching management
  Future<void> _clearOldCachedFiles() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final files = cacheDir.listSync();

      int bytesFreed = 0;

      for (var file in files) {
        if (file is File) {
          final stat = file.statSync();
          final lastModified = stat.modified;

          // If file is older than cache expiry, delete it
          if (DateTime.now().difference(lastModified) > CACHE_EXPIRY) {
            bytesFreed += stat.size;
            await file.delete();
          }
        }
      }

      debugPrint('Cleared $bytesFreed bytes of old cached files');
    } catch (e) {
      debugPrint('Error clearing old cached files: $e');
    }
  }

  Future<void> _clearAllCachedFiles() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final files = cacheDir.listSync();

      for (var file in files) {
        if (file is File) {
          await file.delete();
        }
      }

      debugPrint('Cleared all cached files');
    } catch (e) {
      debugPrint('Error clearing all cached files: $e');
    }
  }

  // In-memory caching with size limiting
  void cacheObject(String key, dynamic value, {int? estimatedSize}) {
    // Estimate memory usage if size not provided
    final sizeEstimate = estimatedSize ?? _estimateObjectSize(value);

    // Check if we need to make room for the new cache entry
    if (_estimatedMemoryUsage + sizeEstimate > 10 * 1024 * 1024) {
      // 10 MB limit
      _trimCache();
    }

    // Store the item with its size and timestamp
    final item = CacheItem(
      value: value,
      size: sizeEstimate,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    _cache[key] = item;
    _estimatedMemoryUsage += sizeEstimate;
  }

  dynamic getCachedObject(String key) {
    final item = _cache[key];
    if (item == null) return null;

    // Update access timestamp on hit
    final updatedItem = item.copyWith(
      newTimestamp: DateTime.now().millisecondsSinceEpoch,
    );
    _cache[key] = updatedItem;

    return item.value;
  }

  void removeCachedObject(String key) {
    final item = _cache[key];
    if (item != null) {
      _estimatedMemoryUsage -= item.size;
      _cache.remove(key);
    }
  }

  void _trimCache() {
    if (_cache.isEmpty) return;

    // Sort items by timestamp, oldest first
    final entries =
        _cache.entries.toList()
          ..sort((a, b) => a.value.timestamp.compareTo(b.value.timestamp));

    // Remove oldest items until we're under 70% of our limit
    final targetSize = 7 * 1024 * 1024; // 7MB (70% of 10MB)

    for (var entry in entries) {
      if (_estimatedMemoryUsage <= targetSize) break;

      _estimatedMemoryUsage -= entry.value.size;
      _cache.remove(entry.key);
    }
  }

  // Estimate size of an object in bytes (very rough approximation)
  int _estimateObjectSize(dynamic object) {
    if (object == null) return 8;
    if (object is int) return 8;
    if (object is double) return 8;
    if (object is bool) return 1;
    if (object is String) return object.length * 2; // UTF-16 encoding

    if (object is List) {
      return object.fold<int>(
        0,
        (sum, item) => sum + _estimateObjectSize(item),
      );
    }

    if (object is Map) {
      return object.entries.fold<int>(
        0,
        (sum, entry) =>
            sum +
            _estimateObjectSize(entry.key) +
            _estimateObjectSize(entry.value),
      );
    }

    // Default estimate for complex objects
    return 100;
  }

  // Adjust image quality based on memory pressure
  void _downgradeImageQuality() {
    // This is a placeholder - in a real app, you might adjust image
    // resolution or quality settings across the app.
    debugPrint('Adjusting image quality due to memory pressure');
  }

  // Battery optimization request
  Future<bool> requestBatteryOptimization() async {
    try {
      const platform = MethodChannel(
        'com.lifechain.wallet/battery_optimization',
      );
      return await platform.invokeMethod('requestBatteryOptimization') ?? false;
    } catch (e) {
      debugPrint('Failed to request battery optimization: $e');
      return false;
    }
  }

  // Cleanup stale data
  Future<void> removeStaleData() async {
    await _clearOldCachedFiles();
    _trimCache();
  }
}
