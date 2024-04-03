import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _userCity = "USER_CITY";
const _userSubscriptionEmail = "USER_EMAIL";

class StorageService extends GetxService {
  static StorageService get to => Get.find();
  late final SharedPreferences _preferences;

  Future<StorageService> init() async {
    _preferences = await SharedPreferences.getInstance();
    return this;
  }

  Future<bool> _set(String key, String value) =>
      _preferences.setString(key, value);

  String _getString(String key) => _preferences.getString(key) ?? "";

  Future<bool> setUserCity(String city) => _set(_userCity, city);

  String getUserCity() => _getString(_userCity);

  Future<bool> setUserEmail(String email) =>
      _set(_userSubscriptionEmail, email);

  String getUserEmail() => _getString(_userSubscriptionEmail);
}
