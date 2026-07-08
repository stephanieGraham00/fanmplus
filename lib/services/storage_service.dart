import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post_model.dart';
import '../models/message_model.dart';
import '../models/cycle_model.dart';
import '../models/user_model.dart';
import '../models/doctor_model.dart';
import '../models/appointment_model.dart';
import '../models/medical_record_model.dart';

class StorageService extends ChangeNotifier {
  List<PostModel> _posts = [];
  List<MessageModel> _messages = [];
  List<UserModel> _users = [];
  List<DoctorModel> _doctors = [];
  List<AppointmentModel> _appointments = [];
  List<MedicalRecordModel> _medicalRecords = [];
  CycleModel _cycle = CycleModel();

  List<PostModel> get posts => _posts;
  List<MessageModel> get messages => _messages;
  List<UserModel> get users => _users;
  List<DoctorModel> get doctors => _doctors;
  List<AppointmentModel> get appointments => _appointments;
  List<MedicalRecordModel> get medicalRecords => _medicalRecords;
  CycleModel get cycle => _cycle;

  Future<void> init() async {
    await Future.wait([
      _load('posts', (d) => _posts = d.map((e) => PostModel.fromJson(e)).toList()),
      _load('messages', (d) => _messages = d.map((e) => MessageModel.fromJson(e)).toList()),
      _load('users', (d) => _users = d.map((e) => UserModel.fromJson(e)).toList()),
      _load('doctors', (d) => _doctors = d.map((e) => DoctorModel.fromJson(e)).toList()),
      _load('appointments', (d) => _appointments = d.map((e) => AppointmentModel.fromJson(e)).toList()),
      _load('medical_records', (d) => _medicalRecords = d.map((e) => MedicalRecordModel.fromJson(e)).toList()),
      _loadCycle(),
    ]);
    notifyListeners();
  }

  Future<void> _load(String key, void Function(List<Map<String, dynamic>>) callback) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(key);
      if (data != null) {
        final list = json.decode(data) as List;
        callback(list.cast<Map<String, dynamic>>());
      }
    } catch (e) {
      debugPrint('Load $key error: $e');
    }
  }

  Future<void> _save(String key, List<Map<String, dynamic>> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, json.encode(data));
  }

  Future<void> _loadCycle() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('cycle');
      if (data != null) _cycle = CycleModel.fromJson(json.decode(data));
    } catch (e) {
      debugPrint('Load cycle error: $e');
    }
  }

  Future<void> _saveCycle() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cycle', json.encode(_cycle.toJson()));
  }

  Future<void> addPost(PostModel post) async {
    _posts.insert(0, post);
    await _save('posts', _posts.map((p) => p.toJson()).toList());
    notifyListeners();
  }

  Future<void> toggleLike(String postId, String userId) async {
    final i = _posts.indexWhere((p) => p.id == postId);
    if (i == -1) return;
    final p = _posts[i];
    if (p.likes.contains(userId)) _posts[i] = p.copyWith(likes: List.from(p.likes)..remove(userId));
    else _posts[i] = p.copyWith(likes: List.from(p.likes)..add(userId));
    await _save('posts', _posts.map((p) => p.toJson()).toList());
    notifyListeners();
  }

  Future<void> sendMessage(MessageModel msg) async {
    _messages.add(msg);
    await _save('messages', _messages.map((m) => m.toJson()).toList());
    notifyListeners();
  }

  List<MessageModel> getConversation(String id1, String id2) {
    return _messages.where((m) =>
      (m.senderId == id1 && m.receiverId == id2) ||
      (m.senderId == id2 && m.receiverId == id1)
    ).toList()..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  Future<void> updateCycle(CycleModel c) async {
    _cycle = c;
    await _saveCycle();
    notifyListeners();
  }

  Future<void> addUser(UserModel u) async {
    if (!_users.any((x) => x.id == u.id)) {
      _users.add(u);
      await _save('users', _users.map((x) => x.toJson()).toList());
      notifyListeners();
    }
  }

  Future<void> toggleFollow(String current, String target) async {
    final i = _users.indexWhere((u) => u.id == target);
    if (i == -1) return;
    final u = _users[i];
    if (u.followers.contains(current)) _users[i] = u.copyWith(followers: List.from(u.followers)..remove(current));
    else _users[i] = u.copyWith(followers: List.from(u.followers)..add(current));
    await _save('users', _users.map((x) => x.toJson()).toList());
    notifyListeners();
  }

  Future<void> addDoctor(DoctorModel d) async {
    _doctors.add(d);
    await _save('doctors', _doctors.map((x) => x.toJson()).toList());
    notifyListeners();
  }

  Future<void> removeDoctor(String id) async {
    _doctors.removeWhere((d) => d.id == id);
    await _save('doctors', _doctors.map((x) => x.toJson()).toList());
    notifyListeners();
  }

  Future<void> addAppointment(AppointmentModel a) async {
    _appointments.add(a);
    await _save('appointments', _appointments.map((x) => x.toJson()).toList());
    notifyListeners();
  }

  Future<void> saveMedicalRecord(MedicalRecordModel r) async {
    final i = _medicalRecords.indexWhere((m) => m.id == r.id);
    if (i == -1) _medicalRecords.add(r);
    else _medicalRecords[i] = r;
    await _save('medical_records', _medicalRecords.map((x) => x.toJson()).toList());
    notifyListeners();
  }

  List<DoctorModel> doctorsBySpecialty(String specialty) {
    return _doctors.where((d) => d.specialty.toLowerCase().contains(specialty.toLowerCase())).toList();
  }
}
