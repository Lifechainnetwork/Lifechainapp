import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider with ChangeNotifier {
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  bool _isInitialized = false;

  ConnectivityProvider() {
    _initConnectivity();
  }

  ConnectivityResult get connectivityResult => _connectivityResult;

  bool get isConnected => 
      _connectivityResult != ConnectivityResult.none;

  bool get isOnMobileNetwork => 
      _connectivityResult == ConnectivityResult.mobile;

  bool get isOnWiFi => 
      _connectivityResult == ConnectivityResult.wifi;

  bool get isEthernet => 
      _connectivityResult == ConnectivityResult.ethernet;

  Future<void> _initConnectivity() async {
    if (_isInitialized) return;

    try {
      final result = await Connectivity().checkConnectivity();
      _updateConnectionStatus(result);
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing connectivity monitoring: $e');
    }
  }

  void updateConnectivityStatus(ConnectivityResult result) {
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    if (_connectivityResult != result) {
      _connectivityResult = result;
      notifyListeners();
      _logConnectionStatus();
    }
  }

  void _logConnectionStatus() {
    String connectionStatus = 'Unknown';
    
    switch (_connectivityResult) {
      case ConnectivityResult.wifi:
        connectionStatus = 'Connected to WiFi';
        break;
      case ConnectivityResult.mobile:
        connectionStatus = 'Connected to Mobile Data';
        break;
      case ConnectivityResult.ethernet:
        connectionStatus = 'Connected to Ethernet';
        break;
      case ConnectivityResult.bluetooth:
        connectionStatus = 'Connected via Bluetooth';
        break;
      case ConnectivityResult.vpn:
        connectionStatus = 'Connected via VPN';
        break;
      case ConnectivityResult.none:
        connectionStatus = 'No network connection';
        break;
      default:
        connectionStatus = 'Unknown connection status';
    }
    
    debugPrint('Network Status: $connectionStatus');
  }
} 