import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:sembast/sembast.dart';

Future<bool> equalfQueryfindFirst(
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

Future<bool> equalQueryfind(
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

Future<dynamic> equalQueryFindRecord(
    String dbPath, String store_string, String field, String value) async {
  Database db = await databaseFactoryIo.openDatabase(dbPath);
  var store = intMapStoreFactory.store(store_string);
  var userRecord =
      await store.find(db, finder: Finder(filter: Filter.equals(field, value)));
  return userRecord;
}

Future <dynamic> equalQueryFindFirstRecord(String dbPath, String store_string, String field, String value) async {
  Database db = await databaseFactoryIo.openDatabase(dbPath);
  var store = intMapStoreFactory.store(store_string);
  var userRecord =
      await store.findFirst(db, finder: Finder(filter: Filter.equals(field, value)));
  return userRecord;
}