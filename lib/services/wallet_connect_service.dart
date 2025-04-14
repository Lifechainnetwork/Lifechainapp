import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum WalletType {
  metamask,
  trustWallet,
  coinbaseWallet,
  ledger,
  trezor,
  phantom,
  walletConnect
}

class WalletInfo {
  final String address;
  final WalletType type;
  final String chainId;
  final bool isConnected;

  WalletInfo({
    required this.address,
    required this.type,
    required this.chainId,
    this.isConnected = false,
  });

  factory WalletInfo.fromJson(Map<String, dynamic> json) {
    return WalletInfo(
      address: json['address'] as String,
      type: WalletType.values.firstWhere(
        (e) => e.toString() == 'WalletType.${json['type']}',
        orElse: () => WalletType.walletConnect,
      ),
      chainId: json['chainId'] as String,
      isConnected: json['isConnected'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'type': type.toString().split('.').last,
      'chainId': chainId,
      'isConnected': isConnected,
    };
  }
}

class WalletConnectService extends ChangeNotifier {
  WalletInfo? _connectedWallet;
  bool _isInitialized = false;
  bool _isConnecting = false;
  String? _lastError;
  final List<WalletInfo> _recentWallets = [];

  // Getters
  WalletInfo? get connectedWallet => _connectedWallet;
  bool get isConnected => _connectedWallet != null && _connectedWallet!.isConnected;
  bool get isInitialized => _isInitialized;
  bool get isConnecting => _isConnecting;
  String? get lastError => _lastError;
  List<WalletInfo> get recentWallets => _recentWallets;

  // Initialize the service
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _isInitialized = true;
      await _loadSavedWallets();
      notifyListeners();
    } catch (e) {
      _lastError = 'Failed to initialize wallet service: $e';
      notifyListeners();
    }
  }

  // Connect to a wallet
  Future<bool> connectWallet(WalletType type, {String? chainId}) async {
    if (_isConnecting) return false;
    
    _isConnecting = true;
    _lastError = null;
    notifyListeners();
    
    try {
      // In a real implementation, this would connect to the actual wallet
      // For demo purposes, we'll simulate a successful connection
      await Future.delayed(const Duration(seconds: 2));
      
      final String demoAddress = _getDemoAddressForWallet(type);
      final String actualChainId = chainId ?? '0x1'; // Default to Ethereum mainnet
      
      _connectedWallet = WalletInfo(
        address: demoAddress,
        type: type,
        chainId: actualChainId,
        isConnected: true,
      );
      
      // Add to recent wallets
      _addToRecentWallets(_connectedWallet!);
      
      // Save to preferences
      await _saveWalletInfo();
      
      _isConnecting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _lastError = 'Failed to connect wallet: $e';
      _isConnecting = false;
      notifyListeners();
      return false;
    }
  }

  // Disconnect wallet
  Future<void> disconnectWallet() async {
    if (_connectedWallet == null) return;
    
    try {
      // In a real implementation, this would disconnect from the actual wallet
      // For demo purposes, we'll simulate a successful disconnection
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Update recent wallets list
      final index = _recentWallets.indexWhere(
        (w) => w.address == _connectedWallet!.address
      );
      
      if (index >= 0) {
        _recentWallets[index] = WalletInfo(
          address: _connectedWallet!.address,
          type: _connectedWallet!.type,
          chainId: _connectedWallet!.chainId,
          isConnected: false,
        );
      }
      
      _connectedWallet = null;
      
      // Save to preferences
      await _saveWalletInfo();
      
      notifyListeners();
    } catch (e) {
      _lastError = 'Failed to disconnect wallet: $e';
      notifyListeners();
    }
  }

  // Switch chain
  Future<bool> switchChain(String chainId) async {
    if (_connectedWallet == null) return false;
    
    try {
      // In a real implementation, this would request a chain switch in the wallet
      // For demo purposes, we'll simulate a successful chain switch
      await Future.delayed(const Duration(milliseconds: 800));
      
      _connectedWallet = WalletInfo(
        address: _connectedWallet!.address,
        type: _connectedWallet!.type,
        chainId: chainId,
        isConnected: true,
      );
      
      // Update recent wallets list
      final index = _recentWallets.indexWhere(
        (w) => w.address == _connectedWallet!.address
      );
      
      if (index >= 0) {
        _recentWallets[index] = _connectedWallet!;
      }
      
      // Save to preferences
      await _saveWalletInfo();
      
      notifyListeners();
      return true;
    } catch (e) {
      _lastError = 'Failed to switch chain: $e';
      notifyListeners();
      return false;
    }
  }

  // Sign message
  Future<String?> signMessage(String message) async {
    if (_connectedWallet == null) return null;
    
    try {
      // In a real implementation, this would request the wallet to sign a message
      // For demo purposes, we'll simulate a signature
      await Future.delayed(const Duration(seconds: 1));
      
      // Generate a fake signature
      final signature = '0x${_generateFakeSignature(message, _connectedWallet!.address)}';
      
      return signature;
    } catch (e) {
      _lastError = 'Failed to sign message: $e';
      notifyListeners();
      return null;
    }
  }

  // Send transaction
  Future<String?> sendTransaction({
    required String to,
    required String value,
    String? data,
  }) async {
    if (_connectedWallet == null) return null;
    
    try {
      // In a real implementation, this would send a transaction through the wallet
      // For demo purposes, we'll simulate a transaction
      await Future.delayed(const Duration(seconds: 2));
      
      // Generate a fake transaction hash
      final txHash = '0x${_generateFakeTransactionHash()}';
      
      return txHash;
    } catch (e) {
      _lastError = 'Failed to send transaction: $e';
      notifyListeners();
      return null;
    }
  }

  // Get balance
  Future<String> getBalance() async {
    if (_connectedWallet == null) return '0';
    
    try {
      // In a real implementation, this would query the blockchain for the balance
      // For demo purposes, we'll return a fake balance
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Generate a fake balance based on the wallet address
      final balance = _generateFakeBalance(_connectedWallet!.address);
      
      return balance;
    } catch (e) {
      _lastError = 'Failed to get balance: $e';
      notifyListeners();
      return '0';
    }
  }

  // Private methods
  Future<void> _loadSavedWallets() async {
    final prefs = await SharedPreferences.getInstance();
    final walletJson = prefs.getString('wallet_info');
    final recentWalletsJson = prefs.getString('recent_wallets');
    
    if (walletJson != null) {
      try {
        final Map<String, dynamic> walletData = jsonDecode(walletJson);
        _connectedWallet = WalletInfo.fromJson(walletData);
        
        // Verify if the wallet is still connected (in a real app, this would check with the wallet)
        if (_connectedWallet!.isConnected) {
          // For demo, we'll assume it's still connected
        }
      } catch (e) {
        // Ignore parsing errors
        _connectedWallet = null;
      }
    }
    
    if (recentWalletsJson != null) {
      try {
        final List<dynamic> walletsData = jsonDecode(recentWalletsJson);
        _recentWallets.clear();
        _recentWallets.addAll(
          walletsData.map((data) => WalletInfo.fromJson(data as Map<String, dynamic>))
        );
      } catch (e) {
        // Ignore parsing errors
        _recentWallets.clear();
      }
    }
  }

  Future<void> _saveWalletInfo() async {
    final prefs = await SharedPreferences.getInstance();
    
    if (_connectedWallet != null) {
      prefs.setString('wallet_info', jsonEncode(_connectedWallet!.toJson()));
    } else {
      prefs.remove('wallet_info');
    }
    
    prefs.setString('recent_wallets', jsonEncode(_recentWallets.map((w) => w.toJson()).toList()));
  }

  void _addToRecentWallets(WalletInfo wallet) {
    // Remove if already exists
    _recentWallets.removeWhere((w) => w.address == wallet.address);
    
    // Add to the beginning of the list
    _recentWallets.insert(0, wallet);
    
    // Keep only the last 5 wallets
    if (_recentWallets.length > 5) {
      _recentWallets.removeLast();
    }
  }

  String _getDemoAddressForWallet(WalletType type) {
    // Generate deterministic addresses for demo purposes
    switch (type) {
      case WalletType.metamask:
        return '0x71C7656EC7ab88b098defB751B7401B5f6d8976F';
      case WalletType.trustWallet:
        return '0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D';
      case WalletType.coinbaseWallet:
        return '0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984';
      case WalletType.ledger:
        return '0x6B175474E89094C44Da98b954EedeAC495271d0F';
      case WalletType.trezor:
        return '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2';
      case WalletType.phantom:
        return '0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599';
      case WalletType.walletConnect:
        return '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48';
    }
  }

  String _generateFakeSignature(String message, String address) {
    final combinedInput = '$message:$address:${DateTime.now().millisecondsSinceEpoch}';
    final bytes = utf8.encode(combinedInput);
    final hash = base64Encode(bytes);
    return hash.replaceAll('=', '').replaceAll('+', 'f').replaceAll('/', 'a').substring(0, 128);
  }

  String _generateFakeTransactionHash() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final randomInput = 'tx:$timestamp:${_connectedWallet!.address}';
    final bytes = utf8.encode(randomInput);
    final hash = base64Encode(bytes);
    return hash.replaceAll('=', '').replaceAll('+', 'd').replaceAll('/', 'e').substring(0, 64);
  }

  String _generateFakeBalance(String address) {
    // Generate a deterministic balance based on the address
    final addressSum = address.codeUnits.fold(0, (sum, code) => sum + code);
    final baseBalance = (addressSum % 100) + 1;
    final decimals = (addressSum % 1000) / 1000;
    
    return (baseBalance + decimals).toStringAsFixed(4);
  }
}
