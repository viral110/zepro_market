import 'package:get_storage/get_storage.dart';

GetStorage getStorage = GetStorage();

getData({ String key}) {
  return getStorage.read(key);
}

putData({ String key,  String val}) {
  return getStorage.write(key, val);
}

removeData({ String key}) {
  getStorage.remove(key);
}
