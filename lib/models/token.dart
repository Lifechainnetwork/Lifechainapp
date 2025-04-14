class Token {
  final String id;
  final String name;
  final String symbol;
  final int decimals;
  final String totalSupply;
  final String owner;
  final double balance;
  final double price;

  Token({
    required this.id,
    required this.name,
    required this.symbol,
    required this.decimals,
    required this.totalSupply,
    required this.owner,
    this.balance = 0.0,
    this.price = 0.0,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      id: json['id'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      decimals: json['decimals'] as int,
      totalSupply: json['total_supply'] as String,
      owner: json['owner'] as String,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'decimals': decimals,
      'total_supply': totalSupply,
      'owner': owner,
      'balance': balance,
      'price': price,
    };
  }
}
