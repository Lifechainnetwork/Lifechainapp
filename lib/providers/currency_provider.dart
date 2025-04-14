import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyProvider extends ChangeNotifier {
  String _currentCurrency = 'USD';
  final String _currencyKey = 'selectedCurrency';
  
  // Available currencies
  final List<String> availableCurrencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'CNY',
    'INR',
    'BTC',
    'ETH',
    'LCN',
  ];
  
  // Currency symbols
  final Map<String, String> currencySymbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
    'CNY': '¥',
    'INR': '₹',
    'BTC': '₿',
    'ETH': 'Ξ',
    'LCN': 'LCN',
  };

  String get currentCurrency => _currentCurrency;
  String get currentSymbol => currencySymbols[_currentCurrency] ?? '\$';

  CurrencyProvider() {
    _loadCurrencyFromPrefs();
  }

  Future<void> _loadCurrencyFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _currentCurrency = prefs.getString(_currencyKey) ?? 'USD';
    notifyListeners();
  }

  Future<void> setCurrency(String currency) async {
    if (availableCurrencies.contains(currency)) {
      _currentCurrency = currency;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currencyKey, currency);
      notifyListeners();
    }
  }
  
  // Format amount according to selected currency
  String formatAmount(double amount) {
    switch (_currentCurrency) {
      case 'BTC':
        return '${currencySymbols[_currentCurrency]} ${amount.toStringAsFixed(8)}';
      case 'ETH':
      case 'LCN':
        return '${currencySymbols[_currentCurrency]} ${amount.toStringAsFixed(6)}';
      case 'JPY':
      case 'CNY':
        return '${currencySymbols[_currentCurrency]} ${amount.toStringAsFixed(0)}';
      default:
        return '${currencySymbols[_currentCurrency]} ${amount.toStringAsFixed(2)}';
    }
  }
  
  // Convert amount between currencies (simplified for demo)
  double convertAmount(double amount, String fromCurrency, String toCurrency) {
    // This is a simplified conversion for demo purposes
    // In a real app, you would use real-time exchange rates
    
    // Convert to USD first (base currency)
    double amountInUSD;
    switch (fromCurrency) {
      case 'EUR':
        amountInUSD = amount * 1.09;
        break;
      case 'GBP':
        amountInUSD = amount * 1.29;
        break;
      case 'JPY':
        amountInUSD = amount * 0.0067;
        break;
      case 'CNY':
        amountInUSD = amount * 0.14;
        break;
      case 'INR':
        amountInUSD = amount * 0.012;
        break;
      case 'BTC':
        amountInUSD = amount * 60000;
        break;
      case 'ETH':
        amountInUSD = amount * 3000;
        break;
      case 'LCN':
        amountInUSD = amount * 5;
        break;
      default:
        amountInUSD = amount;
    }
    
    // Convert from USD to target currency
    switch (toCurrency) {
      case 'EUR':
        return amountInUSD / 1.09;
      case 'GBP':
        return amountInUSD / 1.29;
      case 'JPY':
        return amountInUSD / 0.0067;
      case 'CNY':
        return amountInUSD / 0.14;
      case 'INR':
        return amountInUSD / 0.012;
      case 'BTC':
        return amountInUSD / 60000;
      case 'ETH':
        return amountInUSD / 3000;
      case 'LCN':
        return amountInUSD / 5;
      default:
        return amountInUSD;
    }
  }
}
