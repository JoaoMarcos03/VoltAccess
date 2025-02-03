import 'package:flutter/foundation.dart';
import '../models/membership.dart';
import '../models/user_profile.dart';

class UserService extends ChangeNotifier {
  UserProfile? _currentUser;
  MembershipType _currentMembership = MembershipType.payAsYouGo;
  int _usedSecondsThisWeek = 0;  // Changed from minutes to seconds

  // Test users with different memberships and profiles
  static final Map<String, Map<String, dynamic>> testUsers = {
    'free@test.com': {
      'password': '123456',
      'profile': UserProfile(
        email: 'free@test.com',
        name: 'John Smith',
        phoneNumber: '+351 912 345 678',
        creditCard: '**** **** **** 1234',
        dateOfBirth: '1990-01-01',
        defaultMembership: MembershipType.payAsYouGo,
      ),
    },
    'basic@test.com': {
      'password': '123456',
      'profile': UserProfile(
        email: 'basic@test.com',
        name: 'Maria Silva',
        phoneNumber: '+351 923 456 789',
        creditCard: '**** **** **** 5678',
        dateOfBirth: '1985-05-15',
        defaultMembership: MembershipType.basic,
      ),
    },
    'premium@test.com': {
      'password': '123456',
      'profile': UserProfile(
        email: 'premium@test.com',
        name: 'António Santos',
        phoneNumber: '+351 934 567 890',
        creditCard: '**** **** **** 9012',
        dateOfBirth: '1988-12-30',
        defaultMembership: MembershipType.premium,
      ),
    },
  };

  // Getters
  UserProfile? get currentUser => _currentUser;
  MembershipType get currentMembership => _currentMembership;
  int get usedMinutesThisWeek => _usedSecondsThisWeek ~/ 60;
  
  int get totalFreeSeconds {
    final plan = Membership.plans[_currentMembership]!;
    return plan.freeMinutesPerWeek * 60; // Convert minutes to seconds
  }

  int get remainingFreeSeconds {
    return totalFreeSeconds - _usedSecondsThisWeek;
  }

  String formatDuration(int totalSeconds) {
    final hours = (totalSeconds / 3600).floor();
    final minutes = ((totalSeconds % 3600) / 60).floor();
    final seconds = totalSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get membershipInfo {
    switch (_currentMembership) {
      case MembershipType.payAsYouGo:
        return 'Pay as you go';
      case MembershipType.basic:
        return 'Basic Plan: ${formatDuration(remainingFreeSeconds)} free remaining';
      case MembershipType.premium:
        return 'Premium Plan: ${formatDuration(remainingFreeSeconds)} free remaining';
    }
  }

  void loginUser(String email) {
    final userInfo = testUsers[email];
    if (userInfo != null) {
      _currentUser = userInfo['profile'] as UserProfile;
      _currentMembership = _currentUser!.defaultMembership;
      _usedSecondsThisWeek = 0;
      notifyListeners();
    }
  }

  void updateMembership(MembershipType newType) {
    _currentMembership = newType;
    _usedSecondsThisWeek = 0;  // Reset seconds instead of minutes
    notifyListeners();
  }

  void addUsedSeconds(int seconds) {
    if (_currentMembership != MembershipType.payAsYouGo) {
      // Ensure we don't subtract more than available free time
      final actualSecondsToAdd = seconds.clamp(0, totalFreeSeconds);
      _usedSecondsThisWeek += actualSecondsToAdd;
      notifyListeners();
    }
  }

  void logout() {
    _currentUser = null;
    _currentMembership = MembershipType.payAsYouGo;
    _usedSecondsThisWeek = 0;  // Reset seconds
    notifyListeners();
  }

  void updateUserInfo({
    String? name,
    String? email,
    String? phoneNumber,
    String? dateOfBirth,
    String? creditCard,
  }) {
    if (_currentUser != null) {
      final updatedProfile = UserProfile(
        email: email ?? _currentUser!.email,
        name: name ?? _currentUser!.name,
        phoneNumber: phoneNumber ?? _currentUser!.phoneNumber,
        creditCard: creditCard ?? _currentUser!.creditCard,
        dateOfBirth: dateOfBirth ?? _currentUser!.dateOfBirth,
        defaultMembership: _currentUser!.defaultMembership,
      );

      // Update test user data to persist changes during session
      testUsers[_currentUser!.email] = {
        'password': testUsers[_currentUser!.email]!['password'],
        'profile': updatedProfile,
      };

      _currentUser = updatedProfile;
      notifyListeners();
    }
  }
}
