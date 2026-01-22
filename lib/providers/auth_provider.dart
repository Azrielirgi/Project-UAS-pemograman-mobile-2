import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:catering_system/models/user_profile.dart';
import 'package:catering_system/services/firebase_service.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  UserProfile? _currentUser;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _error;

  // Getters
  UserProfile? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get error => _error;

  // Initialize - Check if user already logged in
  Future<void> initialize() async {
    try {
      await _firebaseService.initializeFirebase();
      // Check for saved session
      await _checkSavedSession();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Check if user has saved session
  Future<void> _checkSavedSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedEmail = prefs.getString('user_email');
      final savedName = prefs.getString('user_name');

      if (savedEmail != null && savedName != null) {
        _currentUser = UserProfile(
          id: prefs.getString('user_id') ?? '',
          email: savedEmail,
          fullName: savedName,
          phoneNumber: prefs.getString('user_phone') ?? '',
          address: prefs.getString('user_address') ?? '',
          city: prefs.getString('user_city') ?? '',
          createdAt: DateTime.parse(
            prefs.getString('user_created_at') ?? DateTime.now().toString(),
          ),
          profileImageUrl: prefs.getString('user_image') ?? '',
        );
        _isAuthenticated = true;
        notifyListeners();
      } else {
        // Mock user untuk testing tanpa login
        _currentUser = UserProfile(
          id: 'user_123',
          email: 'test@catering.com',
          fullName: 'Ahmad Reza',
          phoneNumber: '+62 812 3456 7890',
          address: 'Jl. Merdeka No. 123, Jakarta Selatan',
          city: 'Jakarta',
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          profileImageUrl: '',
        );
        _isAuthenticated = true;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Sign Up
  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String address,
    required String city,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final success = await _firebaseService.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );

      if (success) {
        _currentUser = UserProfile(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          email: email,
          fullName: fullName,
          phoneNumber: phoneNumber,
          address: address,
          city: city,
          createdAt: DateTime.now(),
        );
        _isAuthenticated = true;
        // Save session
        await _saveSession(_currentUser!);
      }

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign In
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final success = await _firebaseService.signIn(
        email: email,
        password: password,
      );

      if (success) {
        _currentUser = await _firebaseService.getUserProfile(
          DateTime.now().millisecondsSinceEpoch.toString(),
        );
        _isAuthenticated = true;
        // Save session
        if (_currentUser != null) {
          await _saveSession(_currentUser!);
        }
      }

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Save user session to local storage
  Future<void> _saveSession(UserProfile user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', user.email);
      await prefs.setString('user_name', user.fullName);
      await prefs.setString('user_id', user.id);
      await prefs.setString('user_phone', user.phoneNumber);
      await prefs.setString('user_address', user.address);
      await prefs.setString('user_city', user.city);
      await prefs.setString('user_created_at', user.createdAt.toString());
      await prefs.setString('user_image', user.profileImageUrl);
    } catch (e) {
      debugPrint('Error saving session: $e');
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firebaseService.signOut();
      // Clear saved session
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_email');
      await prefs.remove('user_name');
      await prefs.remove('user_id');
      await prefs.remove('user_phone');
      await prefs.remove('user_address');
      await prefs.remove('user_city');
      await prefs.remove('user_created_at');
      await prefs.remove('user_image');

      _currentUser = null;
      _isAuthenticated = false;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update Profile
  Future<bool> updateProfile(UserProfile profile) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firebaseService.updateUserProfile(profile);
      _currentUser = profile;
      // Save updated session
      await _saveSession(profile);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Reset Password
  Future<bool> resetPassword(String email) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final success = await _firebaseService.resetPassword(email);

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
