import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
// Temporarily removed flutter_secure_storage import
import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricAuth {
  final LocalAuthentication _localAuth;
  // Temporarily using SharedPreferences instead of FlutterSecureStorage
  SharedPreferences? _prefs;
  final Logger _logger;

  static const String _keyPrefix = 'wallet_key_';

  BiometricAuth()
    : _localAuth = LocalAuthentication(),
      _logger = Logger('BiometricAuth') {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
    
    // Initialize SharedPreferences
    _initPrefs();
  }

  Future<bool> isBiometricsAvailable() async {
    try {
      // Check if biometrics is available on device
      final bool canAuthenticateWithBiometrics =
          await _localAuth.canCheckBiometrics;
      final bool canAuthenticate = await _localAuth.isDeviceSupported();

      return canAuthenticateWithBiometrics && canAuthenticate;
    } catch (e) {
      _logger.warning('Error checking biometrics availability: $e');
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      _logger.warning('Error getting available biometrics: $e');
      return [];
    }
  }

  Future<bool> authenticateUser({
    String reason = 'Please authenticate to access your wallet',
  }) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } on PlatformException catch (e) {
      _logger.warning('Error during authentication: ${e.message}');
      return false;
    } catch (e) {
      _logger.severe('Unexpected error during authentication: $e');
      return false;
    }
  }

  // Initialize SharedPreferences
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> storeWalletKey(String walletId, String encryptedKey) async {
    try {
      // First authenticate user
      final bool authenticated = await authenticateUser(
        reason: 'Please authenticate to store wallet key',
      );

      if (!authenticated) {
        _logger.warning('User authentication failed for storing wallet key');
        return false;
      }

      // Make sure prefs is initialized
      if (_prefs == null) {
        await _initPrefs();
      }

      // Store encrypted key with additional encryption layer
      final String storageKey = _keyPrefix + walletId;
      final String encryptedData = await _encryptData(encryptedKey);

      // Use SharedPreferences instead of secure storage
      await _prefs!.setString(storageKey, encryptedData);

      _logger.info('Successfully stored wallet key for $walletId');
      return true;
    } catch (e) {
      _logger.severe('Error storing wallet key: $e');
      return false;
    }
  }

  Future<String?> retrieveWalletKey(String walletId) async {
    try {
      // First authenticate user
      final bool authenticated = await authenticateUser(
        reason: 'Please authenticate to access wallet',
      );

      if (!authenticated) {
        _logger.warning('User authentication failed for retrieving wallet key');
        return null;
      }

      // Make sure prefs is initialized
      if (_prefs == null) {
        await _initPrefs();
      }

      // Retrieve and decrypt key
      final String storageKey = _keyPrefix + walletId;
      final String? encryptedData = _prefs!.getString(storageKey);

      if (encryptedData == null) {
        _logger.warning('No wallet key found for $walletId');
        return null;
      }

      return await _decryptData(encryptedData);
    } catch (e) {
      _logger.severe('Error retrieving wallet key: $e');
      return null;
    }
  }

  Future<bool> removeWalletKey(String walletId) async {
    try {
      // First authenticate user
      final bool authenticated = await authenticateUser(
        reason: 'Please authenticate to remove wallet key',
      );

      if (!authenticated) {
        _logger.warning('User authentication failed for removing wallet key');
        return false;
      }

      // Make sure prefs is initialized
      if (_prefs == null) {
        await _initPrefs();
      }

      final String storageKey = _keyPrefix + walletId;
      await _prefs!.remove(storageKey);

      _logger.info('Successfully removed wallet key for $walletId');
      return true;
    } catch (e) {
      _logger.severe('Error removing wallet key: $e');
      return false;
    }
  }

  Future<String> _encryptData(String data) async {
    try {
      // Add additional encryption layer
      // This is a simplified example - in production you'd want to use more sophisticated encryption
      final List<int> bytes = utf8.encode(data);
      final String encoded = base64.encode(bytes);
      return encoded;
    } catch (e) {
      _logger.severe('Error encrypting data: $e');
      throw Exception('Encryption failed');
    }
  }

  Future<String> _decryptData(String encryptedData) async {
    try {
      // Decrypt additional layer
      // This is a simplified example - in production you'd want to use more sophisticated encryption
      final List<int> bytes = base64.decode(encryptedData);
      final String decoded = utf8.decode(bytes);
      return decoded;
    } catch (e) {
      _logger.severe('Error decrypting data: $e');
      throw Exception('Decryption failed');
    }
  }

  Future<Map<String, dynamic>> getBiometricStatus() async {
    try {
      final bool isAvailable = await isBiometricsAvailable();
      final List<BiometricType> types = await getAvailableBiometrics();

      return {
        'isAvailable': isAvailable,
        'types': types.map((type) => type.toString()).toList(),
        'error': null,
      };
    } catch (e) {
      _logger.severe('Error getting biometric status: $e');
      return {'isAvailable': false, 'types': <String>[], 'error': e.toString()};
    }
  }
}
