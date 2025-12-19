import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

/// Provider for managing user profile
class UserProvider with ChangeNotifier {
  UserProfile _profile = UserProfile(
    name: 'Asjid',
    registrationNumber: 'FA23-BSE',
  );

  UserProfile get profile => _profile;

  static const String _storageKey = 'user_profile';

  /// Load user profile from local storage
  Future<void> loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? profileJson = prefs.getString(_storageKey);

      if (profileJson != null) {
        final Map<String, dynamic> data = json.decode(profileJson);
        _profile = UserProfile.fromJson(data);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
    }
  }

  /// Save user profile to local storage
  Future<void> saveProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String profileJson = json.encode(_profile.toJson());
      await prefs.setString(_storageKey, profileJson);
    } catch (e) {
      debugPrint('Error saving profile: $e');
    }
  }

  /// Update user name
  Future<void> updateName(String name) async {
    _profile = _profile.copyWith(name: name);
    await saveProfile();
    notifyListeners();
  }

  /// Update registration number
  Future<void> updateRegistrationNumber(String regNumber) async {
    _profile = _profile.copyWith(registrationNumber: regNumber);
    await saveProfile();
    notifyListeners();
  }

  /// Update profile image
  Future<void> updateProfileImage(String? imagePath) async {
    _profile = _profile.copyWith(profileImagePath: imagePath);
    await saveProfile();
    notifyListeners();
  }

  /// Update entire profile
  Future<void> updateProfile({
    String? name,
    String? registrationNumber,
    String? profileImagePath,
  }) async {
    _profile = UserProfile(
      name: name ?? _profile.name,
      registrationNumber: registrationNumber ?? _profile.registrationNumber,
      profileImagePath: profileImagePath ?? _profile.profileImagePath,
    );
    await saveProfile();
    notifyListeners();
  }
}
