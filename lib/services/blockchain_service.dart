import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BlockchainService {
  static final BlockchainService _instance = BlockchainService._internal();
  factory BlockchainService() => _instance;
  BlockchainService._internal();

  final String _baseUrl = 'https://api.lifechain.org';

  Future<Map<String, dynamic>> getPortfolioData(String walletAddress) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/portfolio/$walletAddress'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load portfolio data');
      }
    } catch (e) {
      print("Error getting portfolio data: $e");
      return {
        'status': 'error',
        'error': e.toString(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
    }
  }

  Future<Map<String, dynamic>> getMarketData() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/market/data'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load market data');
      }
    } catch (e) {
      print("Error getting market data: $e");
      return {
        'status': 'error',
        'error': e.toString(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
    }
  }
}
