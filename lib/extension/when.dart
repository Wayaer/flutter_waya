import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_waya/flutter_waya.dart';

/// English: The super evolution version💖💖💖 of [switch] method, all basic types of values can be compared, including [List], [Map], [Set], and [Iterable].<br>
/// All need do is [value] in [Map.keys] of [conditionMap], its corresponding [ValueGetter] method will be executed
///
/// 中文: 方法[switch]的超级进化版本💖💖💖，所有基本类型的value都可以比较，包括[List],[Map]，[Set]，以及[Iterable]。<br>
/// 只要[conditionMap]的[Map.keys]中有[value]的话，就会执行其对应的[ValueGetter]方法
///
///
///example:
///```dart
/// String? kind = whenValue<List, String>(
///   ["apple", "orange"],
///   {
///     ["cat", "dog"]: () {
///       return "pets";
///     },
///     ["apple", "orange"]: () {
///       return "fruits";
///     },
///     ["red", "white", "black"]: () {
///       return "colors";
///     },
///   },
/// );
/// ```
T? whenValue<V, T>(V value, Map<V, ValueGetter<T>> conditionMap) {
  return conditionMap.entries
      .firstOrNullWhere((element) =>
          const DeepCollectionEquality().equals(element.key, value))
      ?.value();
}

/// English: The when function of the Kotlin version of the method [switch].<br>
/// As long as the first true is found in [Map.keys] of [conditionMap], its corresponding [ValueGetter] method will be executed immediately and the relative value will be returned.<br>
/// If it is not found, it will return null; if you need a default value, you can add a MapEntry with a key equal to true at the end of the Map
///
/// Special attention!!! Due to the characteristics of [Map], you need to ensure that [Map.keys] in [conditionMap] does not have multiple true values.
/// If you cannot guarantee it, it is recommended to use the [whenTrue] or [whenBool] method to avoid program problems
///
/// 中文: 方法[switch]的kotlin版本的when函数.<br>
/// 只要在[conditionMap]的[Map.keys]中发现第一个true,就会立刻执行其对应的[ValueGetter]方法，并返回相对的值.<br>
/// 如果没有找到的话，会返回null;如果需要默认值，可以在Map中最后加入一个key等于true的MapEntry
///
/// 特别注意!!! 由于[Map]的特性，需要确保[conditionMap]中的[Map.keys]不会出现多个true的值。
/// 如果不能保证，建议使用[whenTrue]或者[whenBool]方法，这样可以避免程序出现问题
///
///
///example:
///```dart
/// String? winner = when<String>({
///   "Dart is Language".contains("UI"): () {
///     return "Flutter";
///   },
///   "Flutter is UI Framework".contains("UI"): () {
///     return "Flutter";
///   },
/// });
/// ```
T? when<T>(Map<bool, ValueGetter<T>> conditionMap) {
  for (var element in conditionMap.entries) {
    if (element.key) {
      return element.value();
    }
  }
  return null;
}

/// English: The when function of the Kotlin version of the method [switch]，its conditional expression will be calculated。.<br>
/// As long as [conditionMap] to [Map.keys] appears first execution result is true, it will immediately perform corresponding [ValueGetter] method, and an opposite return value.<br>
/// If it is not found, it will return null; if you need a default value, you can add a MapEntry with a key equal to true at the end of the Map
///
/// 中文: 方法[switch]的kotlin版本的when函数.<br>，其条件表达式会进行计算。
/// 只要在[conditionMap]的[Map.keys]中第一个出现执行结果为true,就会立刻执行其对应的[ValueGetter]方法，并返回相对的值.<br>
/// 如果没有找到的话，会返回null;如果需要默认值，可以在Map中最后加入一个key等于true的MapEntry
///
///
///example:
///```dart
///String? something = whenTrue<String>({
///      () {
///    if (1 + 100 * 1000 < 2000) {
///      return false;
///    } else if ("Who is my lovely baby?".length > 10) {
///      return true;
///    } else {
///      return false;
///    }
///  }: () {
///    return "Test OK";
///  },
///      () {
///    return int.tryParse("3.14*") != null;
///  }: () {
///    return "PI get";
///  }
///});
/// ```
T? whenTrue<T>(Map<ValueGetter<bool>, ValueGetter<T>> conditionMap) {
  for (var element in conditionMap.entries) {
    if (element.key.call()) {
      return element.value();
    }
  }
  return null;
}
