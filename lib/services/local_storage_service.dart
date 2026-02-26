import 'dart:convert';

import 'package:hive/hive.dart';

import '../models/models.dart';

class LocalStorageService {
  LocalStorageService._();
  static final instance = LocalStorageService._();

  static const _boxName = 'aurapal';
  static const _profileKey = 'profile';
  static const _auraReadingsKey = 'auraReadings';
  static const _palmReadingsKey = 'palmReadings';
  static const _friendsKey = 'friends';

  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  Future<void> saveProfile(UserProfile profile) async {
    await _box.put(_profileKey, jsonEncode(profile.toJson()));
  }

  UserProfile getProfile() {
    final raw = _box.get(_profileKey) as String?;
    if (raw == null) {
      final profile = UserProfile(userId: 'local-user', displayName: 'Aura Explorer');
      saveProfile(profile);
      return profile;
    }
    return UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveAuraReading(AuraReading reading) async {
    final readings = getAuraReadings()..add(reading);
    await _box.put(_auraReadingsKey, jsonEncode(readings.map((e) => e.toJson()).toList()));
  }

  List<AuraReading> getAuraReadings() {
    final raw = _box.get(_auraReadingsKey) as String?;
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List;
    return decoded.map((e) => AuraReading.fromJson((e as Map).cast<String, dynamic>())).toList();
  }

  Future<void> savePalmReading(PalmReading reading) async {
    final readings = getPalmReadings()..add(reading);
    await _box.put(_palmReadingsKey, jsonEncode(readings.map((e) => e.toJson()).toList()));
  }

  List<PalmReading> getPalmReadings() {
    final raw = _box.get(_palmReadingsKey) as String?;
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List;
    return decoded.map((e) => PalmReading.fromJson((e as Map).cast<String, dynamic>())).toList();
  }

  Future<void> saveFriends(List<FriendSummary> friends) async {
    await _box.put(_friendsKey, jsonEncode(friends.map((e) => e.toJson()).toList()));
  }

  List<FriendSummary> getFriends() {
    final raw = _box.get(_friendsKey) as String?;
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List;
    return decoded.map((e) => FriendSummary.fromJson((e as Map).cast<String, dynamic>())).toList();
  }

  Future<String> exportJson() async {
    final map = {
      'profile': getProfile().toJson(),
      'auraReadings': getAuraReadings().map((e) => e.toJson()).toList(),
      'palmReadings': getPalmReadings().map((e) => e.toJson()).toList(),
      'friends': getFriends().map((e) => e.toJson()).toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(map);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}
