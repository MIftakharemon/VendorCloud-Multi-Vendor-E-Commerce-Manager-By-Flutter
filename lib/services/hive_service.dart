import 'package:hive_flutter/hive_flutter.dart';

import '../models/product_model.dart';
import '../models/user_model.dart';

class HiveService {
  static const String _boxName = 'userBox';
  static const String _userKey = 'user';

  Future<void> init() async {
    try {
      await Hive.initFlutter();


      Hive.registerAdapter(UserModelAdapter());
      Hive.registerAdapter(AvatarAdapter());
      Hive.registerAdapter(LocationAdapter());
      Hive.registerAdapter(OtherPermissionsAdapter());

      await Hive.openBox<UserModel>(_boxName);} catch (e) {}
  }

  Future<void> saveUser(UserModel user) async {
    try {
      final box = Hive.box<UserModel>(_boxName);
      await box.put(_userKey, user);} catch (e) {
      print('The user didnt saved......................');
    }
  }

  Future<UserModel?> getUser() async {
    try {
      final box = Hive.box<UserModel>(_boxName);
      return box.get(_userKey);
    } catch (e) {return null;
    }
  }

  Future<void> clearUser() async {
    try {
      final box = Hive.box<UserModel>(_boxName);
      await box.delete(_userKey);
    } catch (e) {
    }
  }
}