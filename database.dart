import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast_io.dart';
import '../interface/product.dart';

Future<Database> openDatabase() async {
  final appDocumentDir = await getApplicationDocumentsDirectory();
  final dbPath = join(appDocumentDir.path, 'products_database.db');

  DatabaseFactory dbFactory = databaseFactoryIo;
  return await dbFactory.openDatabase(dbPath);
}

Future<void> saveProduct(Product product) async {
  final database = await openDatabase();

  await database.transaction((txn) async {
    final store = intMapStoreFactory.store('products');
    await store.record(product.id).put(txn, product.toMap());
  });

  await database.close();
}

Future<void> deleteProduct(int id) async {
  final _productsStore = intMapStoreFactory.store('products');
  final database = await openDatabase();

  await database.transaction((txn) async {
    await _productsStore.record(id).delete(txn);
  });

  await database.close();
}
