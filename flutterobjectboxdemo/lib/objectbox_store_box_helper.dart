import 'package:flutterobjectboxdemo/objectbox.g.dart';
import 'package:flutterobjectboxdemo/user.dart';

class OpenStoreAndBoxHelper {
  Future<Store> openObjectBoxStore() async {
    final store = await openStore();
    return store;
  }

  Future<Box<User>> openUserBox(Store store) async {
    Box<User> userBox = store.box<User>();
    return userBox;
  }

  closeStore(Store store) {
    if (!store.isClosed()) {
      store.close();
    }
  }
}
