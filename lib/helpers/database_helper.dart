import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wallet_cryptocurrency/models/coinModel.dart';

class DataBaseHelper {
  static Database _db;
  static const String SYMBOL = 'symbol';
  static const String NAME = 'name';
  static const String IMAGE = 'ImageUrl';
  static const String TABLE = 'coins';
  static const String DB_NAME = 'flutter_dev.db';

  // check the db available or not and return the value
  Future<Database> get fetchMyDatabase async {
    if (_db != null) {
      return _db;
    }
    _db = await _initializeDb();
    return _db;
  }

  // intialize the database
  _initializeDb() async {
    String path = join(await getDatabasesPath(), DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _createMyTable);
    return db;
  }

  //create my table if not available
  _createMyTable(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($SYMBOL INTEGER PRIMARY KEY, $NAME TEXT, $IMAGE TEXT)");
  }

  // Save the Quote once user clicked the button
  saveCoin(Coin coin) async {
    var dbClient = await fetchMyDatabase;
    await dbClient.insert(TABLE, coin.toMap());
  }

  // Close the connection to database
  Future closeDbConnection() async {
    var dbClient = await fetchMyDatabase;
    dbClient.close();
  }

  // Fetch the Saved Quotes from Table
  Future<List<Coin>> fetchSavedCoins() async {
    var dbClient = await fetchMyDatabase;
    List<Map> maps =
        await dbClient.query(TABLE, columns: [SYMBOL, NAME, IMAGE]);
    List<Coin> coins = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        coins.add(Coin.fromMap(maps[i]));
      }
    }
    return coins;
  }

  Future<int> deleteCoinFromFavorite(int id) async {
    var dbClient = await fetchMyDatabase;
    return await dbClient.delete(TABLE, where: '$SYMBOL = ?', whereArgs: [id]);
  }
}
