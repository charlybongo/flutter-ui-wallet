import 'package:flutter/material.dart';

class Coin {
  Coin({
    @required this.name,
    @required this.imageUrl,
    @required this.symbol,
    @required this.price,
    @required this.changePercentage,
    @required this.marketCap,
    final this.status,
  });

  String name;
  String symbol;
  int marketCap;
  String imageUrl;
  num price;
  String status;
  num changePercentage;

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
        status: json['status'],
        name: json['name'],
        marketCap: json['market_cap'],
        imageUrl: json['image'],
        symbol: json['symbol'],
        price: json['current_price'],
        changePercentage: json['price_change_percentage_24h']);
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'image': imageUrl, symbol: 'symbol'};
  }

  Coin.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    imageUrl = map['imageUrl'];
    symbol = map['symbol'];
  }
}

List<Coin> coinList = [];
