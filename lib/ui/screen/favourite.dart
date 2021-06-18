import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_cryptocurrency/helpers/fproviders.dart';

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    var favouritesBloc = Provider.of<FavouritesBloc>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              itemCount: favouritesBloc.items.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _listCryptoItem(
                  iconUrl: favouritesBloc.items[index].imageUrl,
                  myCrypto: favouritesBloc.items[index].name,
                  myBalance: favouritesBloc.items[index].price,
                  myProfit: favouritesBloc.items[index].symbol,
                  precent: favouritesBloc.items[index].changePercentage,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _listCryptoItem(
      {String iconUrl,
      double precent = 0,
      String myCrypto,
      myBalance,
      myProfit}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(
              '$iconUrl',
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
                    '$myCrypto',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    '$myProfit',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$myBalance',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  precent >= 0 ? '+ $precent %' : '$precent %',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: precent >= 0 ? Colors.green : Colors.pink,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
