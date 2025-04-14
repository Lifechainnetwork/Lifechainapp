import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'offline_data_service.dart';

/// Service responsible for managing data synchronization
class SyncManager extends ChangeNotifier {
  static final SyncManager _instance = SyncManager._internal();
  factory SyncManager() => _instance;

  final OfflineDataService _offlineDataService = OfflineDataService();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  bool _isSyncing = false;
  bool _lastConnectionStatus = true;
  DateTime? _lastSyncTime;

  bool get isSyncing => _isSyncing;
  DateTime? get lastSyncTime => _lastSyncTime;

  SyncManager._internal() {
    _initSyncManager();
  }

  Future<void> _initSyncManager() async {
    // Initialize connectivity monitoring
    _listenForConnectivityChanges();
  }

  /// Setup connectivity change listener
  void _listenForConnectivityChanges() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      ConnectivityResult result,
    ) async {
      final isConnected = result != ConnectivityResult.none;

      // If we were offline and now we're online, trigger a sync
      if (!_lastConnectionStatus && isConnected) {
        debugPrint('Network connection restored. Starting sync process...');
        await syncDataWithServer();
      }

      // Update offline mode in offline data service
      _offlineDataService.setOfflineMode(!isConnected);

      _lastConnectionStatus = isConnected;
    });
  }

  /// Manually trigger a sync with the server
  Future<bool> syncDataWithServer() async {
    if (_isSyncing) {
      debugPrint('Sync already in progress. Skipping.');
      return false;
    }

    _isSyncing = true;
    notifyListeners();

    bool success = false;

    try {
      // 1. Sync pending transactions
      await _syncPendingTransactions();

      // 2. Refresh token data and cache it
      await _refreshAndCacheTokenData();

      // 3. Refresh portfolio data and cache it
      await _refreshAndCachePortfolioData();

      // 4. Refresh transaction history and cache it
      await _refreshAndCacheTransactionHistory();

      // 5. Refresh market data and cache it
      await _refreshAndCacheMarketData();

      // 6. Refresh staking data and cache it
      await _refreshAndCacheStakingData();

      // 7. Refresh governance data and cache it
      await _refreshAndCacheGovernanceData();

      _lastSyncTime = DateTime.now();
      success = true;

      debugPrint('Data sync completed successfully');
    } catch (e) {
      debugPrint('Error during data sync: $e');
      success = false;
    } finally {
      _isSyncing = false;
      notifyListeners();
    }

    return success;
  }

  /// Sync pending transactions with the server
  Future<void> _syncPendingTransactions() async {
    // This would use LCNTokenService's _processPendingTransactions method
    // For now, we'll use a placeholder
    await Future.delayed(const Duration(milliseconds: 300));
    debugPrint('Pending transactions synced');
  }

  /// Refresh and cache token data
  Future<void> _refreshAndCacheTokenData() async {
    try {
      // In a real app, this would fetch data from an API
      // For demo, we'll create placeholder data
      final tokensData = [
        {
          'id': 'lcn',
          'name': 'Lifechain',
          'symbol': 'LCN',
          'currentPrice': 2.45,
          'priceChange24h': 5.67,
          'marketCap': 245000000,
          'volume24h': 12500000,
          'circulatingSupply': 100000000,
          'totalSupply': 250000000,
          'updatedAt': DateTime.now().toIso8601String(),
        },
        // Other tokens would be here
      ];

      // Cache the data
      await _offlineDataService.cacheTokensData(tokensData);

      debugPrint('Token data refreshed and cached');
    } catch (e) {
      debugPrint('Error refreshing token data: $e');
    }
  }

  /// Refresh and cache portfolio data
  Future<void> _refreshAndCachePortfolioData() async {
    try {
      // In a real app, this would fetch data from an API
      // For demo, we'll create placeholder data
      final portfolioData = {
        'totalValue': 12567.89,
        'percentChange24h': 2.34,
        'tokens': [
          {
            'symbol': 'LCN',
            'balance': 5000,
            'value': 12250,
            'percentage': 97.5,
          },
          // Other tokens would be here
        ],
        'updatedAt': DateTime.now().toIso8601String(),
      };

      // Cache the data
      await _offlineDataService.cachePortfolioData(portfolioData);

      debugPrint('Portfolio data refreshed and cached');
    } catch (e) {
      debugPrint('Error refreshing portfolio data: $e');
    }
  }

  /// Refresh and cache transaction history
  Future<void> _refreshAndCacheTransactionHistory() async {
    try {
      // In a real app, this would fetch data from an API
      // For demo, we'll create placeholder data
      final transactions = [
        {
          'id': 'tx1',
          'type': 'Transfer',
          'amount': 100,
          'token': 'LCN',
          'from': '0x123...abc',
          'to': '0x456...def',
          'timestamp':
              DateTime.now()
                  .subtract(const Duration(days: 1))
                  .toIso8601String(),
          'status': 'Completed',
          'hash': '0x789...ghi',
        },
        // Other transactions would be here
      ];

      // Cache the data
      await _offlineDataService.cacheTransactionHistory(transactions);

      debugPrint('Transaction history refreshed and cached');
    } catch (e) {
      debugPrint('Error refreshing transaction history: $e');
    }
  }

  /// Refresh and cache market data
  Future<void> _refreshAndCacheMarketData() async {
    try {
      // In a real app, this would fetch data from an API
      // For demo, we'll create placeholder data
      final marketData = {
        'marketCap': 1234567890,
        'volume24h': 987654321,
        'dominance': {'LCN': 65.43, 'ETH': 12.34, 'BTC': 10.11},
        'gainers': [
          {'symbol': 'TOKEN1', 'change': 12.34},
          {'symbol': 'TOKEN2', 'change': 9.87},
        ],
        'losers': [
          {'symbol': 'TOKEN3', 'change': -5.67},
          {'symbol': 'TOKEN4', 'change': -3.21},
        ],
        'updatedAt': DateTime.now().toIso8601String(),
      };

      // Cache the data
      await _offlineDataService.cacheMarketData(marketData);

      debugPrint('Market data refreshed and cached');
    } catch (e) {
      debugPrint('Error refreshing market data: $e');
    }
  }

  /// Refresh and cache staking data
  Future<void> _refreshAndCacheStakingData() async {
    try {
      // In a real app, this would fetch data from an API
      // For demo, we'll create placeholder data
      final stakingData = {
        'pools': [
          {
            'id': 'pool1',
            'name': 'LCN Staking Pool',
            'apy': 12.5,
            'lockPeriodDays': 30,
            'totalStaked': 1250000,
            'userStaked': 500,
            'userRewards': 15.75,
          },
          // Other pools would be here
        ],
        'totalStaked': 1250500,
        'totalRewards': 15.75,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      // Cache the data
      await _offlineDataService.cacheStakingData(stakingData);

      debugPrint('Staking data refreshed and cached');
    } catch (e) {
      debugPrint('Error refreshing staking data: $e');
    }
  }

  /// Refresh and cache governance data
  Future<void> _refreshAndCacheGovernanceData() async {
    try {
      // In a real app, this would fetch data from an API
      // For demo, we'll create placeholder data
      final governanceData = {
        'proposals': [
          {
            'id': 'prop1',
            'title': 'Community Fund Allocation',
            'description': 'Proposal to allocate 1M LCN to community projects',
            'status': 'Active',
            'votingPowerFor': 500000,
            'votingPowerAgainst': 200000,
            'votingPowerAbstain': 50000,
            'startTime':
                DateTime.now()
                    .subtract(const Duration(days: 3))
                    .toIso8601String(),
            'endTime':
                DateTime.now().add(const Duration(days: 4)).toIso8601String(),
          },
          // Other proposals would be here
        ],
        'userVotingPower': 1000,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      // Cache the data
      await _offlineDataService.cacheGovernanceData(governanceData);

      debugPrint('Governance data refreshed and cached');
    } catch (e) {
      debugPrint('Error refreshing governance data: $e');
    }
  }

  /// Add this service to the app's providers
  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
