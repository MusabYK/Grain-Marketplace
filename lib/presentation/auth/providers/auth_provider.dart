import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/auth/login_user.dart';
import '../../../domain/usecases/auth/register_user.dart';
import '../../../domain/repositories/auth_repository.dart'; // Import the abstract repository
import '../../../data/repositories/auth_repository_impl.dart'; // Import the implementation
import '../../../data/datasources/auth_datasource.dart'; // Import the datasource

enum AuthStatus {
  uninitialized,
  authenticated,
  unauthenticated,
  authenticating,
  registering,
}

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  AuthStatus _status = AuthStatus.uninitialized;
  String? _errorMessage;

  final AuthRepository _authRepository; // Use the abstract repository

  AuthProvider({AuthRepository? authRepository})
    : _authRepository =
          authRepository ?? AuthRepositoryImpl(AuthDataSourceImpl()) {
    _authRepository.authStateChanges.listen(_onAuthStateChanged);
  }

  User? get currentUser => _currentUser;
  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;

  Future<void> _onAuthStateChanged(fb_auth.User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = AuthStatus.unauthenticated;
      _currentUser = null;
    } else {
      final result = await _authRepository.getCurrentUser();
      result.fold(
        (failure) {
          _status = AuthStatus.unauthenticated; // Could not fetch user details
          _currentUser = null;
          _errorMessage = failure.message;
        },
        (user) {
          if (user != null) {
            _currentUser = user;
            _status = AuthStatus.authenticated;
          } else {
            _status = AuthStatus.unauthenticated;
            _currentUser = null;
          }
        },
      );
    }
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    final result = await LoginUser(_authRepository).call(email, password);
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _status = AuthStatus.unauthenticated;
      },
      (user) {
        _currentUser = user;
        _status = AuthStatus.authenticated;
      },
    );
    notifyListeners();
  }

  Future<void> register(
    String email,
    String password,
    String userType,
    String name,
    String phone,
  ) async {
    _status = AuthStatus.registering;
    _errorMessage = null;
    notifyListeners();

    final result = await RegisterUser(
      _authRepository,
    ).call(email, password, userType, name, phone);
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _status = AuthStatus.unauthenticated;
      },
      (user) {
        _currentUser = user;
        _status = AuthStatus.authenticated;
      },
    );
    notifyListeners();
  }

  // Placeholder for the updated method in your AuthProvider
  Future<bool> updateUser({
    required String uid,
    required String name,
    required String email,
    String? location,
  }) async {
    // 1. Set isLoading=true and notify listeners
    // 2. Call your backend repository method (e.g., userRepository.updateUser())
    // 3. If successful, update the local _currentUser object
    //    _currentUser = _currentUser.copyWith(name: name, email: email, location: location);
    // 4. Set isLoading=false and notify listeners
    // 5. Return success status
    // ... actual implementation details will vary based on your backend logic
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network call

    // Placeholder update logic:
    _currentUser = _currentUser?.copyWith(
      name: name,
      email: email,
      location: location, // Assuming 'location' is a field on your user model
    );
    notifyListeners();
    return true;
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    _status = AuthStatus.unauthenticated;
    _currentUser = null;
    notifyListeners();
  }
}
