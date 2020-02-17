import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

class StorageUtils {
  static StorageUtils singleton;
  static SharedPreferences prefs;
  static Lock lock = Lock();

  static Future<StorageUtils> getInstance() async {
    if (singleton == null) {
      await lock.synchronized(() async {
        if (singleton == null) {
          // keep local instance till it is fully initialized.
          // 保持本地实例直到完全初始化。
          var singleton = StorageUtils();
          await singleton.init();
          singleton = singleton;
        }
      });
    }
    return singleton;
  }

  StorageUtils();

  Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  /// put object.
  static Future<bool> putObject(String key, Object value) {
    if (prefs == null) return null;
    return prefs.setString(key, value == null ? "" : json.encode(value));
  }

  /// get obj.
  static T getObj<T>(String key, T f(Map v), {T defValue}) {
    Map map = getObject(key);
    return map == null ? defValue : f(map);
  }

  /// get object.
  static Map getObject(String key) {
    if (prefs == null) return null;
    String data = prefs.getString(key);
    return (data == null || data.isEmpty) ? null : json.decode(data);
  }

  /// put object list.
  static Future<bool> putObjectList(String key, List<Object> list) {
    if (prefs == null) return null;
    List<String> dataList = list?.map((value) {
      return json.encode(value);
    })?.toList();
    return prefs.setStringList(key, dataList);
  }

  /// get obj list.
  static List<T> getObjList<T>(String key, T f(Map v), {List<T> defValue = const []}) {
    List<Map> dataList = getObjectList(key);
    List<T> list = dataList?.map((value) {
      return f(value);
    })?.toList();
    return list ?? defValue;
  }

  /// get object list.
  static List<Map> getObjectList(String key) {
    if (prefs == null) return null;
    List<String> dataLis = prefs.getStringList(key);
    return dataLis?.map((value) {
      Map dataMap = json.decode(value);
      return dataMap;
    })?.toList();
  }

  /// get string.
  static String getString(String key, {String defValue = ''}) {
    if (prefs == null) return defValue;
    return prefs.getString(key) ?? defValue;
  }

  /// put string.
  static Future<bool> putString(String key, String value) {
    if (prefs == null) return null;
    return prefs.setString(key, value);
  }

  /// get bool.
  static bool getBool(String key, {bool defValue = false}) {
    if (prefs == null) return defValue;
    return prefs.getBool(key) ?? defValue;
  }

  /// put bool.
  static Future<bool> putBool(String key, bool value) {
    if (prefs == null) return null;
    return prefs.setBool(key, value);
  }

  /// get int.
  static int getInt(String key, {int defValue = 0}) {
    if (prefs == null) return defValue;
    return prefs.getInt(key) ?? defValue;
  }

  /// put int.
  static Future<bool> putInt(String key, int value) {
    if (prefs == null) return null;
    return prefs.setInt(key, value);
  }

  /// get double.
  static double getDouble(String key, {double defValue = 0.0}) {
    if (prefs == null) return defValue;
    return prefs.getDouble(key) ?? defValue;
  }

  /// put double.
  static Future<bool> putDouble(String key, double value) {
    if (prefs == null) return null;
    return prefs.setDouble(key, value);
  }

  /// get string list.
  static List<String> getStringList(String key, {List<String> defValue = const []}) {
    if (prefs == null) return defValue;
    return prefs.getStringList(key) ?? defValue;
  }

  /// put string list.
  static Future<bool> putStringList(String key, List<String> value) {
    if (prefs == null) return null;
    return prefs.setStringList(key, value);
  }

  /// get dynamic.
  static dynamic getDynamic(String key, {Object defValue}) {
    if (prefs == null) return defValue;
    return prefs.get(key) ?? defValue;
  }

  /// have key.
  static bool haveKey(String key) {
    if (prefs == null) return null;
    return prefs.getKeys().contains(key);
  }

  /// get keys.
  static Set<String> getKeys() {
    if (prefs == null) return null;
    return prefs.getKeys();
  }

  /// remove.
  static Future<bool> remove(String key) {
    if (prefs == null) return null;
    return prefs.remove(key);
  }

  /// clear.
  static Future<bool> clear() {
    if (prefs == null) return null;
    return prefs.clear();
  }

  ///Sp is initialized.
  static bool isInitialized() {
    return prefs != null;
  }
}
