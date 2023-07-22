import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:sembast/sembast.dart';

Future<void> addToDBTxn(String dbPath, String store_name, dynamic data) async {
  Database db = await databaseFactoryIo.openDatabase(dbPath);
  var store = intMapStoreFactory.store(store_name);
  int key;
  await db.transaction((txn) async {
    key = await store.add(txn, data);
  });
}
