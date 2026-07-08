import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const _boxName = 'fanmplus';
  static late Box<String> _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<String>(_boxName);
  }

  // User
  static Future<void> saveUser(String key, String value) async => _box.put('user_$key', value);
  static String? getUser(String key) => _box.get('user_$key');
  static Future<void> removeUser() async {
    final keys = _box.keys.where((k) => k.toString().startsWith('user_'));
    await Future.wait(keys.map((k) => _box.delete(k)));
  }

  // Cycle
  static Future<void> saveCycle(String key, String value) async => _box.put('cycle_$key', value);
  static String? getCycle(String key) => _box.get('cycle_$key');
  static Future<void> saveCycleData(Map<String, dynamic> data) async {
    await _box.put('cycle_all', jsonEncode(data));
  }
  static Map<String, dynamic>? getCycleData() {
    final raw = _box.get('cycle_all');
    return raw != null ? jsonDecode(raw) as Map<String, dynamic> : null;
  }

  // Journal
  static Future<void> saveJournal(String json) async => _box.put('journals', json);
  static String? getJournal() => _box.get('journals');

  // Todos
  static Future<void> saveTodos(String json) async => _box.put('todos', json);
  static String? getTodos() => _box.get('todos');

  // Appointments
  static Future<void> saveAppointments(String json) async => _box.put('appointments', json);
  static String? getAppointments() => _box.get('appointments');

  // Favorites
  static Future<void> saveFavorites(String json) async => _box.put('favorites', json);
  static String? getFavorites() => _box.get('favorites');

  // Generic
  static Future<void> save(String key, String value) async => _box.put(key, value);
  static String? load(String key) => _box.get(key);
  static Future<void> delete(String key) async => _box.delete(key);
  static Future<void> clear() async => _box.clear();

  // All keys for debugging
  static List<String> getAllKeys() => _box.keys.cast<String>().toList();
}
