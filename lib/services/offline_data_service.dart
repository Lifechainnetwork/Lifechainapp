import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Service for managing offline data and caching
class OfflineDataService extends ChangeNotifier {
  static final OfflineDataService _instance = OfflineDataService._internal();
  factory OfflineDataService() => _instance;

  late SharedPreferences _prefs;
  bool _isInitialized = false;
  bool _isOfflineMode = false;

  // Cache keys
  static const String _tokensDataKey = 'cached_tokens_data';
  static const String _portfolioDataKey = 'cached_portfolio_data';
  static const String _transactionHistoryKey = 'cached_transaction_history';
  static const String _marketDataKey = 'cached_market_data';
  static const String _stakingDataKey = 'cached_staking_data';
  static const String _governanceDataKey = 'cached_governance_data';

  // Cache timestamps
  static const String _tokensCacheTimeKey = 'tokens_cache_timestamp';
  static const String _portfolioCacheTimeKey = 'portfolio_cache_timestamp';
  static const String _transactionCacheTimeKey = 'transaction_cache_timestamp';
  static const String _marketCacheTimeKey = 'market_cache_timestamp';
  static const String _stakingCacheTimeKey = 'staking_cache_timestamp';
  static const String _governanceCacheTimeKey = 'governance_cache_timestamp';

  // Cache expiry durations (in minutes)
  static const int _tokensCacheExpiry = 60; // 1 hour
  static const int _portfolioCacheExpiry = 30; // 30 minutes
  static const int _transactionCacheExpiry = 1440; // 24 hours
  static const int _marketCacheExpiry = 15; // 15 minutes
  static const int _stakingCacheExpiry = 60; // 1 hour
  static const int _governanceCacheExpiry = 120; // 2 hours

  bool get isOfflineMode => _isOfflineMode;

  OfflineDataService._internal() {
    _initService();
  }

  Future<void> _initService() async {
    if (_isInitialized) return;

    try {
      _prefs = await SharedPreferences.getInstance();

      // Check initial connectivity status
      final connectivityResult = await Connectivity().checkConnectivity();
      _isOfflineMode = connectivityResult == ConnectivityResult.none;

      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing OfflineDataService: $e');
    }
  }

  /// Set offline mode status
  void setOfflineMode(bool isOffline) {
    if (_isOfflineMode != isOffline) {
      _isOfflineMode = isOffline;
      notifyListeners();
    }
  }

  /// Cache tokens data
  Future<bool> cacheTokensData(List<dynamic> tokensData) async {
    await _initService();
    try {
      await _prefs.setString(_tokensDataKey, jsonEncode(tokensData));
      await _prefs.setInt(
        _tokensCacheTimeKey,
        DateTime.now().millisecondsSinceEpoch,
      );
      return true;
    } catch (e) {
      debugPrint('Error caching tokens data: $e');
      return false;
    }
  }

  /// Get cached tokens data
  Future<List<dynamic>?> getCachedTokensData() async {
    await _initService();
    try {
      final jsonData = _prefs.getString(_tokensDataKey);
      if (jsonData == null) return null;

      // Check if cache is expired
      final cacheTime = _prefs.getInt(_tokensCacheTimeKey) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - cacheTime > _tokensCacheExpiry * 60 * 1000 && !_isOfflineMode) {
        return null; // Cache expired and we're online
      }

      return jsonDecode(jsonData) as List<dynamic>;
    } catch (e) {
      debugPrint('Error getting cached tokens data: $e');
      return null;
    }
  }

  /// Cache portfolio data
  Future<bool> cachePortfolioData(Map<String, dynamic> portfolioData) async {
    await _initService();
    try {
      await _prefs.setString(_portfolioDataKey, jsonEncode(portfolioData));
      await _prefs.setInt(
        _portfolioCacheTimeKey,
        DateTime.now().millisecondsSinceEpoch,
      );
      return true;
    } catch (e) {
      debugPrint('Error caching portfolio data: $e');
      return false;
    }
  }

  /// Get cached portfolio data
  Future<Map<String, dynamic>?> getCachedPortfolioData() async {
    await _initService();
    try {
      final jsonData = _prefs.getString(_portfolioDataKey);
      if (jsonData == null) return null;

      // Check if cache is expired
      final cacheTime = _prefs.getInt(_portfolioCacheTimeKey) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - cacheTime > _portfolioCacheExpiry * 60 * 1000 &&
          !_isOfflineMode) {
        return null; // Cache expired and we're online
      }

      return jsonDecode(jsonData) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error getting cached portfolio data: $e');
      return null;
    }
  }

  /// Cache transaction history
  Future<bool> cacheTransactionHistory(List<dynamic> transactions) async {
    await _initService();
    try {
      await _prefs.setString(_transactionHistoryKey, jsonEncode(transactions));
      await _prefs.setInt(
        _transactionCacheTimeKey,
        DateTime.now().millisecondsSinceEpoch,
      );
      return true;
    } catch (e) {
      debugPrint('Error caching transaction history: $e');
      return false;
    }
  }

  /// Get cached transaction history
  Future<List<dynamic>?> getCachedTransactionHistory() async {
    await _initService();
    try {
      final jsonData = _prefs.getString(_transactionHistoryKey);
      if (jsonData == null) return null;

      // Check if cache is expired
      final cacheTime = _prefs.getInt(_transactionCacheTimeKey) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - cacheTime > _transactionCacheExpiry * 60 * 1000 &&
          !_isOfflineMode) {
        return null; // Cache expired and we're online
      }

      return jsonDecode(jsonData) as List<dynamic>;
    } catch (e) {
      debugPrint('Error getting cached transaction history: $e');
      return null;
    }
  }

  /// Cache market data
  Future<bool> cacheMarketData(Map<String, dynamic> marketData) async {
    await _initService();
    try {
      await _prefs.setString(_marketDataKey, jsonEncode(marketData));
      await _prefs.setInt(
        _marketCacheTimeKey,
        DateTime.now().millisecondsSinceEpoch,
      );
      return true;
    } catch (e) {
      debugPrint('Error caching market data: $e');
      return false;
    }
  }

  /// Get cached market data
  Future<Map<String, dynamic>?> getCachedMarketData() async {
    await _initService();
    try {
      final jsonData = _prefs.getString(_marketDataKey);
      if (jsonData == null) return null;

      // Check if cache is expired
      final cacheTime = _prefs.getInt(_marketCacheTimeKey) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - cacheTime > _marketCacheExpiry * 60 * 1000 && !_isOfflineMode) {
        return null; // Cache expired and we're online
      }

      return jsonDecode(jsonData) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error getting cached market data: $e');
      return null;
    }
  }

  /// Cache staking data
  Future<bool> cacheStakingData(Map<String, dynamic> stakingData) async {
    await _initService();
    try {
      await _prefs.setString(_stakingDataKey, jsonEncode(stakingData));
      await _prefs.setInt(
        _stakingCacheTimeKey,
        DateTime.now().millisecondsSinceEpoch,
      );
      return true;
    } catch (e) {
      debugPrint('Error caching staking data: $e');
      return false;
    }
  }

  /// Get cached staking data
  Future<Map<String, dynamic>?> getCachedStakingData() async {
    await _initService();
    try {
      final jsonData = _prefs.getString(_stakingDataKey);
      if (jsonData == null) return null;

      // Check if cache is expired
      final cacheTime = _prefs.getInt(_stakingCacheTimeKey) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - cacheTime > _stakingCacheExpiry * 60 * 1000 &&
          !_isOfflineMode) {
        return null; // Cache expired and we're online
      }

      return jsonDecode(jsonData) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error getting cached staking data: $e');
      return null;
    }
  }

  /// Cache governance data
  Future<bool> cacheGovernanceData(Map<String, dynamic> governanceData) async {
    await _initService();
    try {
      await _prefs.setString(_governanceDataKey, jsonEncode(governanceData));
      await _prefs.setInt(
        _governanceCacheTimeKey,
        DateTime.now().millisecondsSinceEpoch,
      );
      return true;
    } catch (e) {
      debugPrint('Error caching governance data: $e');
      return false;
    }
  }

  /// Get cached governance data
  Future<Map<String, dynamic>?> getCachedGovernanceData() async {
    await _initService();
    try {
      final jsonData = _prefs.getString(_governanceDataKey);
      if (jsonData == null) return null;

      // Check if cache is expired
      final cacheTime = _prefs.getInt(_governanceCacheTimeKey) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - cacheTime > _governanceCacheExpiry * 60 * 1000 &&
          !_isOfflineMode) {
        return null; // Cache expired and we're online
      }

      return jsonDecode(jsonData) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error getting cached governance data: $e');
      return null;
    }
  }

  /// Check if cached data is available
  bool hasCachedData(String cacheKey) {
    return _prefs.containsKey(cacheKey);
  }

  /// Check if cached data is fresh
  bool isCacheFresh(String timestampKey, int expiryMinutes) {
    final cacheTime = _prefs.getInt(timestampKey) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    return (now - cacheTime) <= (expiryMinutes * 60 * 1000);
  }

  /// Clear all cached data
  Future<bool> clearAllCachedData() async {
    await _initService();
    try {
      await _prefs.remove(_tokensDataKey);
      await _prefs.remove(_portfolioDataKey);
      await _prefs.remove(_transactionHistoryKey);
      await _prefs.remove(_marketDataKey);
      await _prefs.remove(_stakingDataKey);
      await _prefs.remove(_governanceDataKey);

      await _prefs.remove(_tokensCacheTimeKey);
      await _prefs.remove(_portfolioCacheTimeKey);
      await _prefs.remove(_transactionCacheTimeKey);
      await _prefs.remove(_marketCacheTimeKey);
      await _prefs.remove(_stakingCacheTimeKey);
      await _prefs.remove(_governanceCacheTimeKey);

      return true;
    } catch (e) {
      debugPrint('Error clearing cached data: $e');
      return false;
    }
  }
}
