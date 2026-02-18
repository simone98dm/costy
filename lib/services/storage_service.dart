import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/subscription.dart';

class StorageService {
  static const _key = 'subscriptions';

  Future<List<Subscription>> loadSubscriptions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList
        .map((e) => Subscription.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveAll(List<Subscription> subs) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(subs.map((s) => s.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  Future<void> saveSubscription(Subscription sub) async {
    final subs = await loadSubscriptions();
    subs.add(sub);
    await _saveAll(subs);
  }

  Future<void> deleteSubscription(String id) async {
    final subs = await loadSubscriptions();
    subs.removeWhere((s) => s.id == id);
    await _saveAll(subs);
  }

  Future<void> updateSubscription(Subscription sub) async {
    final subs = await loadSubscriptions();
    final index = subs.indexWhere((s) => s.id == sub.id);
    if (index != -1) {
      subs[index] = sub;
      await _saveAll(subs);
    }
  }
}
