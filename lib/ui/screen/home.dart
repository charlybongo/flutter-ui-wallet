import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallet_cryptocurrency/helpers/fproviders.dart';
import 'package:wallet_cryptocurrency/models/coinModel.dart';
import 'package:wallet_cryptocurrency/ui/component.dart';
import 'package:wallet_cryptocurrency/ui/screen/favourite.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> savedCoins = [];
  int value = 0;
  Future<List<Coin>> fetchCoin() async {
    coinList = [];

    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false'));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = json.decode(response.body);
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            coinList.add(Coin.fromJson(map));
          }
        }
        print(coinList.first.price);
        setState(() {
          coinList;
        });
      }
      return coinList;
    } else
      throw Exception('Failed to Load coins');
  }

  @override
  void initState() {
    fetchCoin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var favouritesBloc = Provider.of<FavouritesBloc>(context);

    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: coinList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailsPage(coinList[index])),
                );

                print(coinList[index]);
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.network(
                        coinList[index].imageUrl,
                        width: 50,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              coinList[index].name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                              coinList[index].symbol,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          favouritesBloc.addCount();
                          // print(bookmarkBloc.count);

                          Coin itemModel = new Coin(
                            name: coinList[index].name,
                            changePercentage: coinList[index].changePercentage,
                            marketCap: coinList[index].marketCap,
                            price: coinList[index].price,
                            symbol: coinList[index].symbol,
                            imageUrl: coinList[index].imageUrl,
                          );

                          favouritesBloc.addItems(itemModel);

                          print(favouritesBloc.items[index].name);
                          print(favouritesBloc.items.length);

                          setState(() {
                            coinList[index].status = "true";
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            coinList[index].status == "true"
                                ? Icon(
                                    Icons.favorite,
                                    size: 30,
                                    color: Colors.blue,
                                  )
                                : Icon(
                                    Icons.favorite_border,
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        });
  }
}

class DetailsPage extends StatefulWidget {
  final Coin coin;

  DetailsPage(
    this.coin,
  );

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coin.name),
      ),
      body: Container(
          child: Card(
        child: Column(
          children: [
            Row(
              children: [
                Text('Symbol:  ',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                Text(widget.coin.symbol,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              children: [
                Text('market Cap:  ',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                Text(widget.coin.marketCap.toString(),
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              children: [
                Text('price change Percentage:  ',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                Text(widget.coin.changePercentage.toString(),
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
