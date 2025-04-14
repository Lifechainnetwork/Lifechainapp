import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

/// A utility class for managing application configuration and settings
class AppConfig {
  static AppConfig? _instance;
  static AppConfig get instance => _instance ?? (_instance = AppConfig._());

  // App information
  late final String appName;
  late final String packageName;
  late final String version;
  late final String buildNumber;
  
  // Device information
  late final String deviceModel;
  late final String deviceId;
  late final String deviceOS;
  late final String deviceOSVersion;
  
  // Network configuration
  late final String apiBaseUrl;
  late final String wsBaseUrl;
  late final int networkTimeoutSeconds;
  late final int maxRetryAttempts;
  
  // Feature flags
  final Map<String, bool> featureFlags = {};
  
  // App settings
  late bool analyticsEnabled;
  late bool notificationsEnabled;
  late bool biometricsEnabled;
  
  // Blockchain settings
  late final String defaultChainId;
  late final List<String> supportedChains;
  late final Map<String, String> rpcEndpoints;
  
  // Caching settings
  late final int cacheTTLSeconds;
  late final int maxCacheSizeMB;

  // Private constructor
  AppConfig._();
  
  /// Initialize the app configuration
  static Future<void> initialize() async {
    if (_instance != null) return;
    
    final config = AppConfig._();
    await config._loadConfig();
    _instance = config;
  }
  
  /// Load configuration from various sources
  Future<void> _loadConfig() async {
    // Load package info
    final packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
    
    // Load device info
    final deviceInfo = DeviceInfoPlugin();
    if (Theme.of(navigatorKey.currentContext!).platform == TargetPlatform.android) {
      final androidInfo = await deviceInfo.androidInfo;
      deviceModel = androidInfo.model;
      deviceId = androidInfo.id;
      deviceOS = 'Android';
      deviceOSVersion = androidInfo.version.release;
    } else {
      final iosInfo = await deviceInfo.iosInfo;
      deviceModel = iosInfo.model;
      deviceId = iosInfo.identifierForVendor ?? 'unknown';
      deviceOS = 'iOS';
      deviceOSVersion = iosInfo.systemVersion;
    }
    
    // Load configuration from assets
    await _loadConfigFromAssets();
    
    // Load user preferences
    await _loadUserPreferences();
  }
  
  /// Load configuration from assets
  Future<void> _loadConfigFromAssets() async {
    try {
      // Determine which config to load based on environment
      final configFileName = const bool.fromEnvironment('dart.vm.product') 
          ? 'assets/config/production.json' 
          : 'assets/config/development.json';
      
      final configString = await rootBundle.loadString(configFileName);
      final Map<String, dynamic> config = json.decode(configString);
      
      // Network config
      apiBaseUrl = config['network']['apiBaseUrl'] ?? 'https://api.lifechain.network';
      wsBaseUrl = config['network']['wsBaseUrl'] ?? 'wss://ws.lifechain.network';
      networkTimeoutSeconds = config['network']['timeoutSeconds'] ?? 30;
      maxRetryAttempts = config['network']['maxRetryAttempts'] ?? 3;
      
      // Feature flags
      if (config.containsKey('featureFlags')) {
        for (var entry in (config['featureFlags'] as Map<String, dynamic>).entries) {
          featureFlags[entry.key] = entry.value as bool;
        }
      }
      
      // Blockchain settings
      defaultChainId = config['blockchain']['defaultChainId'] ?? 'lifechain-mainnet';
      supportedChains = List<String>.from(config['blockchain']['supportedChains'] ?? ['lifechain-mainnet']);
      
      rpcEndpoints = {};
      if (config['blockchain']['rpcEndpoints'] != null) {
        for (var entry in (config['blockchain']['rpcEndpoints'] as Map<String, dynamic>).entries) {
          rpcEndpoints[entry.key] = entry.value as String;
        }
      }
      
      // Cache settings
      cacheTTLSeconds = config['cache']['ttlSeconds'] ?? 3600;
      maxCacheSizeMB = config['cache']['maxSizeMB'] ?? 50;
      
    } catch (e) {
      debugPrint('Error loading config from assets: $e');
      // Set default values if loading fails
      _setDefaultConfig();
    }
  }
  
  /// Load user preferences from shared preferences
  Future<void> _loadUserPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // User settings
      analyticsEnabled = prefs.getBool('analytics_enabled') ?? true;
      notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      biometricsEnabled = prefs.getBool('biometrics_enabled') ?? false;
      
    } catch (e) {
      debugPrint('Error loading user preferences: $e');
      // Set default values if loading fails
      analyticsEnabled = true;
      notificationsEnabled = true;
      biometricsEnabled = false;
    }
  }
  
  /// Set default configuration values
  void _setDefaultConfig() {
    // Network defaults
    apiBaseUrl = 'https://api.lifechain.network';
    wsBaseUrl = 'wss://ws.lifechain.network';
    networkTimeoutSeconds = 30;
    maxRetryAttempts = 3;
    
    // Blockchain defaults
    defaultChainId = 'lifechain-mainnet';
    supportedChains = ['lifechain-mainnet'];
    rpcEndpoints = {
      'lifechain-mainnet': 'https://rpc.lifechain.network',
    };
    
    // Cache defaults
    cacheTTLSeconds = 3600;
    maxCacheSizeMB = 50;
  }
  
  /// Save user preferences
  Future<bool> saveUserPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setBool('analytics_enabled', analyticsEnabled);
      await prefs.setBool('notifications_enabled', notificationsEnabled);
      await prefs.setBool('biometrics_enabled', biometricsEnabled);
      
      return true;
    } catch (e) {
      debugPrint('Error saving user preferences: $e');
      return false;
    }
  }
  
  /// Check if a feature is enabled
  bool isFeatureEnabled(String featureKey) {
    return featureFlags[featureKey] ?? false;
  }
  
  /// Get the RPC endpoint for a specific chain
  String getRpcEndpoint(String chainId) {
    return rpcEndpoints[chainId] ?? rpcEndpoints[defaultChainId] ?? 'https://rpc.lifechain.network';
  }
  
  /// Get app version with build number
  String get versionWithBuild => '$version+$buildNumber';
  
  /// Get full device info
  String get deviceInfo => '$deviceModel ($deviceOS $deviceOSVersion)';
}

// Global navigator key from main.dart
GlobalKey<NavigatorState> get navigatorKey => 
    _navigatorKey ?? (_navigatorKey = GlobalKey<NavigatorState>());
GlobalKey<NavigatorState>? _navigatorKey; 