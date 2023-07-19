import 'package:sembast/utils/value_utils.dart';
import 'dart:async';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
  dynamic findinDB  (String dbPath, String field, String equals, String store_text) async {
  Database db = await databaseFactoryIo.openDatabase(dbPath);
  var finder = Finder(filter: Filter.equals(field, equals));
  var store = intMapStoreFactory.store(store_text);
  var findRecord = await store.findFirst(db, finder: finder);
  return findRecord;
}

