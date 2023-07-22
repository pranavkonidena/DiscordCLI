import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:sembast/sembast.dart';

Future <dynamic>  notNullFindRecord (String dbPath, String store_string, String field) async {
  Database db = await databaseFactoryIo.openDatabase(dbPath);
  var store = intMapStoreFactory.store(store_string);
  var userRecord =
      await store.find(db, finder: Finder(filter: Filter.notNull(field)));
  return userRecord;
}

Future <dynamic>  notNullFindFirstRecord (String dbPath, String store_string, String field) async {
  Database db = await databaseFactoryIo.openDatabase(dbPath);
  var store = intMapStoreFactory.store(store_string);
  var userRecord =
      await store.findFirst(db, finder: Finder(filter: Filter.notNull(field)));
  return userRecord;
}

