import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  late SharedPreferences sharedPreferences;
  static CacheHelper casheHelper = CacheHelper._();
  CacheHelper._();
  static CacheHelper get instance => casheHelper;
  Future init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Object? getData(key) {
    return sharedPreferences.get(key);
  }

  Future<bool> saveData(key, value) async {
    if (value is String) return await sharedPreferences.setString(key, value);
    if (value is int) return await sharedPreferences.setInt(key, value);
    if (value is bool) return await sharedPreferences.setBool(key, value);
    return await sharedPreferences.setDouble(key, value);
  }

  Future<bool> removeData(key) async {
    return await sharedPreferences.remove(key);
  }
}
