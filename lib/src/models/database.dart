import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast.dart';

class Db {
   Db._();

  static Future<void> addToDBTxn(
      String dbPath, String store_name, dynamic data) async {
    Database db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store(store_name);
    int key;
    await db.transaction((txn) async {
      key = await store.add(txn, data);
    });
  }

  static Future<bool> equalfQueryfindFirst(
    String dbPath, String store_string, String field, String value) async {
  Database db = await databaseFactoryIo.openDatabase(dbPath);
  var store = intMapStoreFactory.store(store_string);
  var userRecord = await store.findFirst(db,
      finder: Finder(filter: Filter.equals(field, value)));
  if (userRecord == null) {
    return false;
  } else {
    return true;
  }
}


static Future<bool> equalQueryfind(
    String dbPath, String store_string, String field, String value) async {
  Database db = await databaseFactoryIo.openDatabase(dbPath);
  var store = intMapStoreFactory.store(store_string);
  var userRecord =
      await store.find(db, finder: Finder(filter: Filter.equals(field, value)));
  if (userRecord.isEmpty) {
    return false;
  } else {
    return true;
  }
}

static Future<dynamic> equalQueryFindRecord(
    String dbPath, String store_string, String field, String value) async {
  Database db = await databaseFactoryIo.openDatabase(dbPath);
  var store = intMapStoreFactory.store(store_string);
  var userRecord =
      await store.find(db, finder: Finder(filter: Filter.equals(field, value)));
  return userRecord;
}

static Future <dynamic> equalQueryFindFirstRecord(String dbPath, String store_string, String field, String value) async {
  Database db = await databaseFactoryIo.openDatabase(dbPath);
  var store = intMapStoreFactory.store(store_string);
  var userRecord =
      await store.findFirst(db, finder: Finder(filter: Filter.equals(field, value)));
  return userRecord;
}



static Future <dynamic>  notNullFindRecord (String dbPath, String store_string, String field) async {
  Database db = await databaseFactoryIo.openDatabase(dbPath);
  var store = intMapStoreFactory.store(store_string);
  var userRecord =
      await store.find(db, finder: Finder(filter: Filter.notNull(field)));
  return userRecord;
}

static Future <dynamic>  notNullFindFirstRecord (String dbPath, String store_string, String field) async {
  Database db = await databaseFactoryIo.openDatabase(dbPath);
  var store = intMapStoreFactory.store(store_string);
  var userRecord =
      await store.findFirst(db, finder: Finder(filter: Filter.notNull(field)));
  return userRecord;
}
}
