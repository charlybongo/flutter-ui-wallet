import 'package:flutter/cupertino.dart';
import 'package:wallet_cryptocurrency/models/coinModel.dart';

class FavouritesBloc extends ChangeNotifier {
  int _count = 0;
  List<Coin> items = [];

  void addCount() {
    _count++;
    notifyListeners();
  }

  void addItems(Coin data) {
    items.add(data);
    notifyListeners();
  }

  int get count {
    return _count;
  }

  List<Coin> get itemsList {
    return items;
  }
}
