import 'package:get_storage/get_storage.dart';

class ELocalStorage {
  late final GetStorage _storage;
  static ELocalStorage? _instance;
  ELocalStorage._internal();
  factory ELocalStorage.instance() {
    return _instance ??= ELocalStorage._internal();
  }

  static Future<void> init(String bucketName) async {
    await GetStorage.init(bucketName);
    _instance = ELocalStorage._internal();
    _instance!._storage = GetStorage(bucketName);
  }

  Future<void> saveData<E>(String key, E value) async {
    await _storage.write(key, value);
  }

  E? readData<E>(String key) {
    return _storage.read<E>(key);
  }

  Future<void> removeData<E>(String key) async {
    await _storage.remove(key);
  }

  Future<void> clearAll() async {
    await _storage.erase();
  }
}
